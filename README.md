# Stroke Prediction Dataset Practice
Whilst looking for health data scientist positions, I've stumbled upon some that focus on stroke research. To become more familiar with this domain of medicine, I've decided to practice health data analysis on a stroke-centered dataset - https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset

## PPDAC Cycle Plan 
Reading the excellent "The Art Of Statistics" by Prof.Spiegelhalter, I came across a holistic problem-solving model that can serve as the starting point for a data analysis project - the Problem-Plan-Data-Analysis-Conclusions (PPDAC) cycle.
* **(1) Problem** - Understanding and defining the problem
* **(2) Plan** -  What to measure and how
* **(3) Data** - Collection, management, and cleaning
* **(4) Analysis** - Constructing visualisation, looking for patterns through basic and more specialist statistical analysis like prediction modelling
* **(5) Conclusions** -  Interpretation and new ideas for future analysis

_“Although in practice the PPDAC cycle… may not be followed precisely, it underscores that formal techniques for statistical analysis play only one part in the work of a statistician or data scientist,”_ - Prof. Spiegelhalter.

With the above in mind, here is the PPDAC plan for this project-

### Problem

**Main Objective** - To myself explore and model stroke patient data, to better understand the factors associated with stroke and the predictors that are significant.

**Key Questions** -

* What are the key characteristics (demographic, health, and lifestyle) of patients who have had a stroke compared to those who have not?

* Are certain factors, such as age, BMI, hypertension, heart disease, or smoking status, strongly and significantly associated with stroke risk?
  
* How does survival analysis inform the relationship between patient characteristics and stroke risk over time?
  
* Can robust predictive models be built to identify individuals at high risk of stroke using the available data?

### Plan

**Data Preparation**
1. **Data Cleaning** - Check for missingness and decide on imputation or exclusion. Recode variables for consistency and survival analysis, like binary coding.
   
2. **Variable Formatting** - Make sure variable have appropriate variable types (numeric for age and factor for gender for example).
   
3. **Simulating Follow Up Time** - There is no follow up time present in the original dataset, so time variables need to be simulated to enable survival analysis. 

**EDA**
1. **Summary Statistics** for the numeric/integer variables.
   
2. **Different visualisations**: boxplots to examine relationships (avg_glucose_level vs stroke); Q-Q plots to assess the normality of continuous variables; bar charts for categorical variable relationships (e.g. work_type distribution by stroke status).

3. **Basic statistical tests** like t-tests and chi-squared tests to see if there any statistically significant associations between variables.

**Advanced Analysis** 

1. **Survival Analysis** -

* Kaplan-Meier curves to estimate stroke survival probabilities.

* Cox regression models to assess the risk factors affecting stroke survival times.

2. **Predictive Modelling** -

* Training different models like logistic regression, random forest or even XGBoost to predict stroke risk.
  
* Evaluating aforementioned models using metrics like AUC-ROC.

**Data**
This is a dataset of 5110 rows, each row representing 1 unique individual patient, and the following 12 columns:
* **id -** unique identifier
* **gender -** "Male", "Female" or "Other"
* **age -** age of the patient
* **hypertension -** 0 if the patient doesn't have hypertension, 1 if the patient has hypertension
* **heart_disease -** 0 if the patient doesn't have any heart diseases, 1 if the patient has a heart disease
* **ever_married -** "No" or "Yes"
* **work_type -** "children", "Govt_jov", "Never_worked", "Private" or "Self-employed"
* **Residence_type -** "Rural" or "Urban"
* **avg_glucose_level -** average glucose level in blood
* **bmi -** body mass index
* **smoking_status -** "formerly smoked", "never smoked", "smokes" or "Unknown"*
* **stroke -** 1 if the patient had a stroke or 0 if not
* *Note: "Unknown" in smoking_status means that the information is unavailable for this patient

***Potential Challenges*** - Missingness in important variables like bmi and smoking_status. Imbalance in the target variable of stroke, there probably being a majority class for not having stroke so fitting a log.regression model and others may not work well. No time variables - they need to be simulated. 

**Analysis**

1. **EDA** - Summarise and visualise important variables using tidyverse and finalfit. Assess relationships using finalfit and base R packages.
   
2. **Survival Analysis** - Utilising the survival, ggsurvfit, and gtsummary packages make KM plots for different variables and then generate a cox-regression model.
   
3. **Prediction Models** - Several steps to this: feature engineering & data preprocessing; train/test split & cross-validation; model fitting and evaluation.

**Conclusions (anticipated)** - 

***Outcomes*** - Identifying key risk factors associated with stroke; developing a prediction model to assess stroke risk (with good accuracy/metrics); RMD HTML document summarising aforementioned outcomes with EDA and background to the subject given. 

***Potential Impacts*** - Ehanced understanding of stroke risk factors; reproducible code for other health data analysis; clinical intervention strategies developed. 

## Resources/Further Reading
I've planned the analysis using the following resources:

* Other repos on my github - https://github.com/georgemelrose/Dummy-HES-APC-Data-Work , https://github.com/georgemelrose/Mental-Health-Data-Practice
  
* The excellent HealthyR textbook - https://argoshare.is.ed.ac.uk/healthyr_book/

* The unsurpassable survival analysis tutorial of Dr Emily Zabor - https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html
  
* The example survival analysis of research biostatiscian Mr Jacky Choi - https://jmc2392.github.io/survival.html
