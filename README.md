# 🧹 SQL Data Cleaning and 📊 EDA on Layoffs Dataset

This project demonstrates a comprehensive approach to data cleaning using SQL and subsequent exploratory data analysis (EDA) on a dataset detailing layoffs in 2022. The original dataset is sourced from [Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022).

## 🎯 Project Goals

The primary goals of this project are:

1. **🚫 Remove duplicates**: Ensure the dataset contains only unique entries.
2. **🔄 Standardize data**: Normalize values in various columns for consistency.
3. **🧽 Handle null and blank values**: Clean or impute missing and blank entries.
4. **🛠️ Optimize data structure**: Remove unnecessary columns and rows based on the analysis needs.

## 📁 Dataset and File Structure

`layoffs.csv`: The dataset file.

The initial dataset includes several columns such as company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, and funds_raised_millions. This data spans various industries and geographical locations.

`Data_cleaning_layoffs_proj.sql`: The Data cleaning process in SQL.

`layoffs_sql_proj.sql`: Exploratory Data Analysis conducted in SQL.


## 🧼 Data Cleaning Steps

1. **🔍 Duplicate Removal**: Identified and removed duplicate entries based on specific columns.
2. **📐 Data Standardization**:
   - Standardized company names and industry descriptions to a uniform format.
   - Corrected country names and standardized date formats.
3. **🧹 Handling Nulls and Blanks**:
   - Converted blank entries to `NULL` for easier manipulation.
   - Filled missing industry data based on other entries from the same company.

## 🔍 Exploratory Data Analysis (EDA)

Post-cleaning, various analyses were performed to understand:
- 📉 Trends in layoffs by industry and location.
- 🔗 Correlation between layoffs and company funding.
- 📅 Monthly and yearly patterns in layoffs.

### Key Questions Answered

During the EDA, we focused on answering specific questions that provide insights into the impact of layoffs across different dimensions of the dataset:

1. **What was the company with the biggest amount of layoffs?**
   - Identifies the major players most affected, highlighting potential vulnerability or industry shifts.
2. **What was the industry with the most layoffs overall? and in 2022?**
   - Offers insights into which sectors are declining or facing challenges, crucial for economic analysis and workforce planning.
3. **What year had the most layoffs?**
   - Helps understand economic cycles and could correlate with global economic conditions or sector-specific downturns.
4. **What stage of the business had the most layoffs?**
   - Sheds light on whether startups, mid-stage, or mature companies are more vulnerable to economic downturns.
5. **Show a rolling total for the layoffs throughout the months**
   - Provides a temporal view of layoffs, helping to identify trends or triggers throughout the year.
6. **What are the 5 companies that had the most layoffs in 2020, 2021, 2022, and 2023?**
   - Allows for a detailed tracking of company-specific trends over time, offering insights into long-term impacts.
7. **What are the 3 industries that got hit the hardest with layoffs in 2020, 2021, 2022, and 2023?**
   - Highlights the industries facing the most significant challenges over recent years, which can guide policy and investment decisions.

## 🛠️ Tools and Technologies

- **🗄️ SQL**: Used for data manipulation and cleaning.
