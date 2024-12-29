# Stroke Prediction Dataset Practice
Whilst looking for health data scientist positions, I've stumbled upon some that focus on stroke research. To become more familiar with this domain of medicine, I've decided to practice health data analysis on a stroke-centered dataset - https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset

## PPDAC Cycle Plan 
Reading the excellent "The Art Of Statistics" by Prof.Spiegelhalter, I came across a holistic problem-solving model that can serve as the starting point for a data analysis project - the Problem-Plan-Data-Analysis-Conclusions (PPDAC) cycle.
* **(1) Problem** - Understanding and defining the problem
* **(2) Plan** -  What to measure and how
* **(3) Data** - Collection, management, and cleaning
* **(4) Analysis** - Constructing visualisation, looking for patterns through basic and more specialist statistical analysis like prediction modelling.
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

## Dataset
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

I plan to do the formatting of variables and exploratory data analysis (summary statistics, Q-Q plots, box-plots, t-tests etc.), followed by survival analysis and prediction modelling in an RMD to be knitted into an interactive HTML document. 

## Resources/Further Reading
I've planned the analysis using the following resources:

* Other repos on my github - https://github.com/georgemelrose/Dummy-HES-APC-Data-Work , https://github.com/georgemelrose/Mental-Health-Data-Practice
  
* The excellent HealthyR textbook - https://argoshare.is.ed.ac.uk/healthyr_book/

* The unsurpassable survival analysis tutorial of Dr Emily Zabor - https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html
  
* The example survival analysis of research biostatiscian Mr Jacky Choi - https://jmc2392.github.io/survival.html
