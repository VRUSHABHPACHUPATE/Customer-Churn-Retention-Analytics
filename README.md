# Customer Churn & Retention Analytics

**An End-to-End Data Analytics Project Using SQL, Python, and Power BI**

An end-to-end data analytics project focused on understanding customer churn, identifying key churn drivers, and segmenting customers based on historical churn risk. This project combines SQL analysis, Python-based exploratory data analysis, and interactive Power BI dashboards to transform customer data into meaningful business insights.

---

## Project Overview

Customer churn is a significant challenge for subscription-based businesses because customer attrition can affect recurring revenue and long-term growth.

This project analyzes the IBM Telco Customer Churn dataset to understand customer behavior, identify segments with elevated historical churn rates, and develop a rule-based risk segmentation framework.

The project demonstrates an end-to-end analytics workflow, from data validation and cleaning to exploratory analysis, risk segmentation, dashboard development, and business recommendations.

## Business Objectives

- Measure customer churn and retention rates.
- Identify customer segments with higher churn rates.
- Analyze churn patterns across contracts, tenure, internet services, payment methods, and support services.
- Develop consistent rule-based customer risk segmentation.
- Build interactive dashboards to communicate analytical findings.
- Translate data-driven findings into actionable business recommendations.

## Tools and Technologies

| Technology | Application |
|---|---|
| MySQL | Data validation, SQL queries, joins, aggregations, CTEs, window functions, and churn analysis |
| Python | Data cleaning, exploratory data analysis, risk segmentation, and visualizations |
| Pandas | Data manipulation and analysis |
| NumPy | Numerical operations |
| Matplotlib | Data visualization |
| Power BI | Interactive dashboards, KPI reporting, and visual analytics |
| DAX | Measures and calculated columns |
| GitHub | Version control and project documentation |

## Dataset

The project uses the IBM Telco Customer Churn dataset, which contains customer demographics, subscribed services, contract information, billing details, tenure, and churn status.

**Dataset Summary**

- Total customer records: 7,043
- Total columns: 21
- Unique customer IDs: 7,043
- Duplicate customer IDs: 0
- Missing `TotalCharges` values after numeric conversion: 11

The 11 missing `TotalCharges` values were preserved rather than automatically replaced with zero. These records have zero tenure and a churn status of `No`.

The dataset is used for analytical and educational purposes.

---

## Project Methodology

### 1. Data Validation and Cleaning

- Inspected dataset dimensions, columns, and data types.
- Checked for duplicate customer records.
- Validated customer ID uniqueness.
- Identified missing values in `TotalCharges`.
- Converted `TotalCharges` to a numeric data type in Python.
- Preserved missing charge values to avoid introducing unsupported assumptions.

### 2. SQL Analysis — MySQL

- Created and queried the customer churn database.
- Developed the analytical view `vw_customer_churn_analysis`.
- Calculated overall customer churn and retention metrics.
- Analyzed churn by contract type, tenure, internet service, payment method, monthly charges, and technical support.
- Applied aggregations, joins, CTEs, and window functions.
- Examined the relationship between contract type and internet service.
- Implemented rule-based customer risk scoring.
- Cross-validated important results against Python analysis.

### 3. Python Exploratory Data Analysis

- Used Pandas for data inspection and cleaning.
- Analyzed customer churn distribution and key customer characteristics.
- Generated visualizations using Matplotlib.
- Compared churn rates across customer segments.
- Investigated contract, tenure, payment, internet service, and support-related churn patterns.
- Implemented the same rule-based risk scoring framework used in SQL.
- Validated customer counts, churn metrics, and risk categories against SQL results.

### 4. Power BI Dashboard Development

- Imported and prepared the customer dataset.
- Created DAX measures for customer counts and churn rate.
- Developed calculated columns for tenure groups and customer risk segmentation.
- Built KPI cards and interactive charts.
- Added slicers for customer segment exploration.
- Designed a two-page dashboard covering overall churn performance, churn drivers, and risk analysis.

---

## Key Performance Indicators

| Metric | Result |
|---|---:|
| Total Customers | 7,043 |
| Churned Customers | 1,869 |
| Retained Customers | 5,174 |
| Overall Churn Rate | 26.54% |
| Overall Retention Rate | 73.46% |
| Average Monthly Charges | 64.76 |
| Average Customer Tenure | 32.37 months |

The dataset does not specify a currency for `MonthlyCharges`; therefore, the average monthly charge is reported without a currency symbol.

---

## Key Findings

### 1. Churn by Contract Type

| Contract Type | Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| Month-to-month | 3,875 | 1,655 | 42.71% |
| One year | 1,473 | 166 | 11.27% |
| Two year | 1,695 | 48 | 2.83% |

**Insight:** Month-to-month customers have the highest observed churn rate. Longer-term contract groups have substantially lower historical churn rates.

### 2. Churn by Customer Tenure

| Tenure Group | Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| 0–12 months | 2,186 | 1,037 | 47.44% |
| 13–24 months | 1,024 | 294 | 28.71% |
| 25–48 months | 1,594 | 325 | 20.39% |
| 49–72 months | 2,239 | 213 | 9.51% |

**Insight:** Customers in their first 12 months have the highest observed churn rate, highlighting the importance of early customer engagement and onboarding.

### 3. Churn by Internet Service

| Internet Service | Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| Fiber optic | 3,096 | 1,297 | 41.89% |
| DSL | 2,421 | 459 | 18.96% |
| No internet service | 1,526 | 113 | 7.40% |

**Insight:** Fiber optic customers have a higher observed churn rate than the other internet service groups. Further investigation is needed to understand the underlying reasons.

### 4. Churn by Payment Method

| Payment Method | Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| Electronic check | 2,365 | 1,071 | 45.29% |
| Mailed check | 1,612 | 308 | 19.11% |
| Bank transfer (automatic) | 1,544 | 258 | 16.71% |
| Credit card (automatic) | 1,522 | 232 | 15.24% |

**Insight:** Electronic check customers have the highest observed churn rate among the payment method groups.

### 5. Churn by Technical Support

| Technical Support | Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| No | 3,473 | 1,446 | 41.64% |
| Yes | 2,044 | 310 | 15.17% |
| No internet service | 1,526 | 113 | 7.40% |

**Insight:** Customers without technical support have a substantially higher observed churn rate than customers with technical support.

These findings represent associations in the dataset and do not establish that any individual factor directly causes customer churn.

---

## Customer Churn Risk Analysis

A rule-based risk scoring framework was developed to identify customer segments with elevated historical churn rates.

### Risk Scoring Rules

| Customer Characteristic | Risk Points |
|---|---:|
| Month-to-month contract | +2 |
| Tenure of 12 months or less | +2 |
| Fiber optic internet service | +1 |
| Electronic check payment method | +1 |

The resulting risk score ranges from 0 to 6.

### Risk Classification

- **High Risk:** Score greater than or equal to 5.
- **Medium Risk:** Score greater than or equal to 3 and less than 5.
- **Low Risk:** Score less than 3.

### Risk Segment Results

| Risk Category | Customers | Churned Customers | Historical Churn Rate |
|---|---:|---:|---:|
| Low Risk | 3,590 | 269 | 7.49% |
| Medium Risk | 2,214 | 804 | 36.31% |
| High Risk | 1,239 | 796 | 64.25% |

**Key Insight:** The High Risk segment has the highest historical churn rate, while the Low Risk segment has the lowest.

The same scoring rules were implemented in SQL, Python, and Power BI to maintain consistency across the project.

**Important:** This framework is based on manually defined business rules. It is not a trained machine-learning model, and the historical churn rates are not guaranteed predictions of future customer behavior.

---

## Power BI Dashboards

The Power BI report contains two interactive dashboard pages.

### Page 1 — Customer Churn Overview

**KPIs**
- Total Customers
- Churned Customers
- Retained Customers
- Churn Rate

**Visualizations**
- Churn Rate by Tenure Group
- Customer Churn Rate by Contract Type
- Churn Rate by Internet Service
- Customer Retention vs. Churn

**Interactive Slicers**
- Internet Service
- Contract
- Senior Citizen Status

This page provides a high-level overview of customer churn and retention, allowing users to compare customer segments and identify groups with elevated churn rates.

### Page 2 — Churn Drivers & Risk Analysis

**KPIs**
- High-Risk Customers
- High-Risk Churn Rate
- Average Monthly Charges

**Visualizations**
- Churn Rate by Payment Method
- Customer Retention vs. Churn by Contract Type
- Churn Rate by Risk Category
- Churn Rate by Monthly Charges Group
- Churn Rate by Technical Support
- Churn Rate by Online Security

**Interactive Slicers**
- Contract
- Internet Service
- Senior Citizen Status

This page focuses on churn drivers and rule-based risk segmentation, helping users explore differences in historical churn rates across customer groups.

---

## Business Recommendations

Based on the observed patterns, the following actions could be investigated:

1. **Improve early customer retention:** Evaluate onboarding, engagement, and support strategies for customers in their first 12 months.
2. **Investigate contract-related churn:** Explore suitable incentives for month-to-month customers to consider longer-term contracts.
3. **Review fiber optic customer experience:** Investigate pricing, service quality, customer expectations, and support experiences.
4. **Examine electronic check payments:** Investigate whether billing concerns, payment friction, or customer characteristics contribute to the observed churn pattern.
5. **Strengthen customer support:** Evaluate support accessibility, issue resolution, and customer satisfaction.
6. **Prioritize retention analysis:** Use the rule-based risk segments to guide further investigation and evaluate targeted retention initiatives.

These recommendations are based on observed associations and should be validated through further analysis before implementation.

---

## Project Structure

```text
Customer-Churn-Retention-Analytics/
├── data/
│   └── Telco-Customer-Churn.csv
├── powerbi/
│   └── Customer_Churn_Retention_Analytics.pbix
├── python/
│   └── churn_eda.py
├── sql/
│   └── churn_analysis.sql
├── notebooks/
├── reports/
└── README.md
```

The `notebooks/` and `reports/` directories are reserved for future additions. The Python analysis was performed using a `.py` script rather than a Jupyter notebook.

---

## How to Run the Project

### Prerequisites

- MySQL Server and MySQL Workbench
- Python 3
- Microsoft Power BI Desktop

### 1. Dataset Setup

Place the Telco Customer Churn CSV file inside the `data/` directory.

Expected filename:

`Telco-Customer-Churn.csv`

### 2. Run the SQL Analysis

1. Open MySQL Workbench.
2. Open `sql/churn_analysis.sql`.
3. Review the database setup statements.
4. Execute the script in the appropriate MySQL environment.
5. Review the analytical queries and validation results.

### 3. Run the Python Analysis

Install the required Python libraries:

```bash
pip install pandas numpy matplotlib
```

Run the Python script from the project root:

```bash
python python/churn_eda.py
```

Ensure the dataset path configured in the script matches your local project directory.

### 4. Open the Power BI Report

1. Open `powerbi/Customer_Churn_Retention_Analytics.pbix` in Power BI Desktop.
2. Update the CSV data source path if prompted.
3. Refresh the data if required.
4. Navigate between the two dashboard pages and interact with the slicers.

---

## Limitations

- The analysis describes historical customer behavior and does not establish causation.
- The risk scoring framework uses manually defined rules rather than a trained predictive model.
- Historical churn rates should not be interpreted as guaranteed future outcomes.
- Findings are specific to the provided dataset and may not generalize to every business.
- Missing `TotalCharges` values were preserved, and analyses using this field may handle those missing values differently.
- Business recommendations require further investigation and validation before implementation.

---

## Author

**Vrushabh Pachupate**

Aspiring Data Analyst | SQL | Python | Power BI

GitHub: [@VRUSHABHPACHUPATE](https://github.com/VRUSHABHPACHUPATE)

---

If you find this project useful, feel free to explore the SQL analysis, Python script, and Power BI report.