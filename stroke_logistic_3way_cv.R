library(tidymodels)
library(dplyr)
library(broom)
library(themis)

set.seed(123)

#--------------------------------------------------
# 1) Ensure outcome is a factor and set class order
#    Assumes "yes" is the positive class
#--------------------------------------------------
stroke_data <- stroke_data %>%
  mutate(stroke_yn = factor(stroke_yn, levels = c("no", "yes")))

#--------------------------------------------------
# 2) Three-way split: train / validation / test
#    60% train, 20% validation, 20% test
#--------------------------------------------------
split_1 <- initial_split(stroke_data, prop = 0.60, strata = stroke_yn)
stroke_train <- training(split_1)
stroke_temp  <- testing(split_1)

split_2 <- initial_split(stroke_temp, prop = 0.50, strata = stroke_yn)
stroke_valid <- training(split_2)
stroke_test  <- testing(split_2)

# Optional: inspect class balance
stroke_train %>% count(stroke_yn) %>% mutate(prop = n / sum(n))
stroke_valid %>% count(stroke_yn) %>% mutate(prop = n / sum(n))
stroke_test  %>% count(stroke_yn) %>% mutate(prop = n / sum(n))

#--------------------------------------------------
# 3) Cross-validation on training set only
#--------------------------------------------------
set.seed(123)
stroke_folds <- vfold_cv(stroke_train, v = 5, strata = stroke_yn)

#--------------------------------------------------
# 4) Recipe
#    Add SMOTE only if you decide class imbalance is severe
#    Remove step_smote() if you do not want resampling
#--------------------------------------------------
stroke_recipe <- recipe(stroke_yn ~ ., data = stroke_train) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors())
  # %>% step_smote(stroke_yn)

#--------------------------------------------------
# 5) Logistic regression model
#--------------------------------------------------
log_model <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

#--------------------------------------------------
# 6) Workflow
#--------------------------------------------------
log_workflow <- workflow() %>%
  add_recipe(stroke_recipe) %>%
  add_model(log_model)

#--------------------------------------------------
# 7) Cross-validated performance on training set
#    Use probability-based and class-based metrics
#--------------------------------------------------
cv_metrics <- metric_set(roc_auc, pr_auc, accuracy, sens, spec, precision, recall, f_meas)

set.seed(123)
cv_results <- fit_resamples(
  log_workflow,
  resamples = stroke_folds,
  metrics = cv_metrics,
  control = control_resamples(save_pred = TRUE)
)

collect_metrics(cv_results)

#--------------------------------------------------
# 8) Fit model on full training set
#--------------------------------------------------
log_fit_train <- fit(log_workflow, data = stroke_train)

#--------------------------------------------------
# 9) Predict on validation set
#--------------------------------------------------
valid_preds <- bind_cols(
  stroke_valid %>% select(stroke_yn),
  predict(log_fit_train, new_data = stroke_valid),
  predict(log_fit_train, new_data = stroke_valid, type = "prob")
)

#--------------------------------------------------
# 10) Choose threshold on validation set only
#     Here we search thresholds and maximize F1
#     You could swap f_meas for sens, balanced accuracy, etc.
#--------------------------------------------------
threshold_grid <- tibble(threshold = seq(0.05, 0.50, by = 0.01))

valid_threshold_results <- threshold_grid %>%
  rowwise() %>%
  mutate(
    f1 = {
      preds <- valid_preds %>%
        mutate(
          pred_thresh = if_else(.pred_yes >= threshold, "yes", "no"),
          pred_thresh = factor(pred_thresh, levels = c("no", "yes"))
        )
      f_meas_vec(truth = preds$stroke_yn, estimate = preds$pred_thresh, event_level = "second")
    },
    sensitivity = {
      preds <- valid_preds %>%
        mutate(
          pred_thresh = if_else(.pred_yes >= threshold, "yes", "no"),
          pred_thresh = factor(pred_thresh, levels = c("no", "yes"))
        )
      sens_vec(truth = preds$stroke_yn, estimate = preds$pred_thresh, event_level = "second")
    },
    specificity = {
      preds <- valid_preds %>%
        mutate(
          pred_thresh = if_else(.pred_yes >= threshold, "yes", "no"),
          pred_thresh = factor(pred_thresh, levels = c("no", "yes"))
        )
      spec_vec(truth = preds$stroke_yn, estimate = preds$pred_thresh, event_level = "second")
    }
  ) %>%
  ungroup()

best_threshold <- valid_threshold_results %>%
  arrange(desc(f1)) %>%
  slice(1)

best_threshold

chosen_threshold <- best_threshold$threshold

# Validation performance at chosen threshold
valid_preds_final <- valid_preds %>%
  mutate(
    pred_thresh = if_else(.pred_yes >= chosen_threshold, "yes", "no"),
    pred_thresh = factor(pred_thresh, levels = c("no", "yes"))
  )

conf_mat(valid_preds_final, truth = stroke_yn, estimate = pred_thresh)

metric_set(accuracy, sens, spec, precision, recall, f_meas)(
  valid_preds_final,
  truth = stroke_yn,
  estimate = pred_thresh,
  event_level = "second"
)

roc_auc(valid_preds_final, truth = stroke_yn, .pred_yes, event_level = "second")
pr_auc(valid_preds_final, truth = stroke_yn, .pred_yes, event_level = "second")

#--------------------------------------------------
# 11) Refit on train + validation after threshold choice
#--------------------------------------------------
stroke_train_valid <- bind_rows(stroke_train, stroke_valid)

final_recipe <- recipe(stroke_yn ~ ., data = stroke_train_valid) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors())
  # %>% step_smote(stroke_yn)

final_workflow <- workflow() %>%
  add_recipe(final_recipe) %>%
  add_model(log_model)

final_fit <- fit(final_workflow, data = stroke_train_valid)

#--------------------------------------------------
# 12) Final one-time evaluation on test set
#--------------------------------------------------
test_preds <- bind_cols(
  stroke_test %>% select(stroke_yn),
  predict(final_fit, new_data = stroke_test),
  predict(final_fit, new_data = stroke_test, type = "prob")
) %>%
  mutate(
    pred_thresh = if_else(.pred_yes >= chosen_threshold, "yes", "no"),
    pred_thresh = factor(pred_thresh, levels = c("no", "yes"))
  )

# Final test confusion matrix
conf_mat(test_preds, truth = stroke_yn, estimate = pred_thresh)

# Final test metrics
metric_set(accuracy, sens, spec, precision, recall, f_meas)(
  test_preds,
  truth = stroke_yn,
  estimate = pred_thresh,
  event_level = "second"
)

roc_auc(test_preds, truth = stroke_yn, .pred_yes, event_level = "second")
pr_auc(test_preds, truth = stroke_yn, .pred_yes, event_level = "second")

#--------------------------------------------------
# 13) Coefficients and odds ratios from final model
#--------------------------------------------------
final_odds_ratios <- final_fit %>%
  extract_fit_parsnip() %>%
  tidy(conf.int = TRUE) %>%
  mutate(
    odds_ratio = exp(estimate),
    conf.low.or = exp(conf.low),
    conf.high.or = exp(conf.high)
  )

final_odds_ratios
