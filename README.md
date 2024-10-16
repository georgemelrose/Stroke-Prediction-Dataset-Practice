# Stroke-Prediction-Dataset-Practice
Whilst looking for health data scientist positions, I've stumbled upon some that focus on stroke research. To become more familiar with this domain of medicine, I've decided to practice health data analysis on a stroke-centered dataset - https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset

This is a small dataset of 5110 rows and the following 12 columns:
1) id: unique identifier
2) gender: "Male", "Female" or "Other"
3) age: age of the patient
4) hypertension: 0 if the patient doesn't have hypertension, 1 if the patient has hypertension
5) heart_disease: 0 if the patient doesn't have any heart diseases, 1 if the patient has a heart disease
6) ever_married: "No" or "Yes"
7) work_type: "children", "Govt_jov", "Never_worked", "Private" or "Self-employed"
8) Residence_type: "Rural" or "Urban"
9) avg_glucose_level: average glucose level in blood
10) bmi: body mass index
11) smoking_status: "formerly smoked", "never smoked", "smokes" or "Unknown"*
12) stroke: 1 if the patient had a stroke or 0 if not
*Note: "Unknown" in smoking_status means that the information is unavailable for this patient

I plan to do the formatting of variables and exploratory data analysis (summary statistics, Q-Q plots, box-plots, t-tests etc.), followed by survival analysis and prediction modelling in an RMD to be knitted into an interactive HTML document. 

I've planned the analysis using the following resources:

* Other repos on my github - https://github.com/georgemelrose/Dummy-HES-APC-Data-Work , https://github.com/georgemelrose/Mental-Health-Data-Practice
  
* The excellent HealthyR textbook - https://argoshare.is.ed.ac.uk/healthyr_book/

* The unsurpassable survival analysis tutorial of Dr Emily Zabor - https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html
  
* The example survival analysis of research biostatiscian Mr Jacky Choi - https://jmc2392.github.io/survival.html
