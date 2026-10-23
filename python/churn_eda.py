import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the Telco Customer Churn dataset

df = pd.read_csv("data/Telco-Customer-Churn.csv")

# Display the first five rows

print("\nFIRST FIVE ROWS")
print(df.head())

# Display dataset dimensions

print("\nDATASET SHAPE")
print(df.shape)

# Display column names

print("\nCOLUMN NAMES")
print(df.columns.tolist())

# Display data types and non-null counts

print("\nDATASET INFORMATION")
df.info()

# Check missing values

print("\nMISSING VALUES")
print(df.isnull().sum())

# Check duplicate rows

print("\nDUPLICATE ROWS")
print(df.duplicated().sum())


# Investigate TotalCharges data quality

print("\nTOTALCHARGES DATA TYPE")
print(df["TotalCharges"].dtype)

print("\nBLANK TOTALCHARGES VALUES")
print((df["TotalCharges"].str.strip() == "").sum())

print("\nCUSTOMERS WITH BLANK TOTALCHARGES")
print(
df.loc[
df["TotalCharges"].str.strip() == "",
["customerID", "tenure", "MonthlyCharges", "TotalCharges", "Churn"]
]
)

print("\nCUSTOMERS WITH ZERO TENURE")
print((df["tenure"] == 0).sum())

# ==========================================

# DATA CLEANING

# ==========================================

# Create a copy so the original dataset remains unchanged

df_clean = df.copy()

# Convert TotalCharges from string to numeric

df_clean["TotalCharges"] = pd.to_numeric(
df_clean["TotalCharges"],
errors="coerce"
)

print("\n--- DATA CLEANING RESULTS ---")

# Check the updated data type

print("\nTotalCharges data type:")
print(df_clean["TotalCharges"].dtype)

# Check missing values after conversion

print("\nMissing TotalCharges values:")
print(df_clean["TotalCharges"].isna().sum())

# Check dataset dimensions

print("\nDataset shape after cleaning:")
print(df_clean.shape)

# Display the cleaned TotalCharges summary

print("\nTotalCharges summary:")
print(df_clean["TotalCharges"].describe())

# ==========================================

# EXPLORATORY DATA ANALYSIS (EDA)

# ==========================================

# 1. Understand the distribution of Churn

print("\n--- CUSTOMER CHURN DISTRIBUTION ---")

print(df_clean["Churn"].value_counts())

print("\n--- CUSTOMER CHURN PERCENTAGES ---")

print(
df_clean["Churn"].value_counts(normalize=True).mul(100).round(2)
)

# ==========================================

# OVERALL CHURN RATE KPI

# ==========================================

total_customers = len(df_clean)

churned_customers = (df_clean["Churn"] == "Yes").sum()

retained_customers = (df_clean["Churn"] == "No").sum()

churn_rate = (churned_customers / total_customers) * 100

retention_rate = (retained_customers / total_customers) * 100

print("\n--- OVERALL CUSTOMER KPIs ---")

print(f"Total Customers: {total_customers:,}")
print(f"Churned Customers: {churned_customers:,}")
print(f"Retained Customers: {retained_customers:,}")
print(f"Churn Rate: {churn_rate:.2f}%")
print(f"Retention Rate: {retention_rate:.2f}%")


# ==========================================

# CUSTOMER CHURN VISUALIZATION

# ==========================================

# Count customers in each churn category

'''churn_counts = df_clean["Churn"].value_counts().reindex(["No", "Yes"])

# Create the chart

plt.figure(figsize=(8, 5))

sns.barplot(
x=churn_counts.index,
y=churn_counts.values
)

# Add chart title and labels

plt.title("Customer Churn Distribution", fontsize=16)
plt.xlabel("Churn Status", fontsize=12)
plt.ylabel("Number of Customers", fontsize=12)

# Display values above the bars

for index, value in enumerate(churn_counts.values):
    plt.text(index, value + 50, f"{value:,}", ha="center", fontsize=11)
    plt.tight_layout()

# Display the chart

plt.show()'''


# ==========================================

# CHURN ANALYSIS BY CONTRACT TYPE

# ==========================================

print("\n--- CHURN RATE BY CONTRACT TYPE ---")

contract_churn = (df_clean.groupby("Contract").agg(Total_Customers=("customerID", "count"),Churned_Customers=("Churn",lambda x: (x == "Yes").sum())))

contract_churn["Churn_Rate"] = (contract_churn["Churned_Customers"]/ contract_churn["Total_Customers"]* 100)

contract_churn["Churn_Rate"] = contract_churn["Churn_Rate"].round(2)

print(contract_churn)



# ==========================================

# CONTRACT TYPE CHURN VISUALIZATION

# ==========================================

'''plt.figure(figsize=(9, 5))

sns.barplot(
x=contract_churn.index,
y=contract_churn["Churn_Rate"]
)

plt.title("Customer Churn Rate by Contract Type", fontsize=16)
plt.xlabel("Contract Type", fontsize=12)
plt.ylabel("Churn Rate (%)", fontsize=12)

# Display churn rates above the bars

for index, value in enumerate(contract_churn["Churn_Rate"]):
    plt.text(index, value + 1, f"{value:.2f}%", ha="center", fontsize=11)
    plt.tight_layout()
plt.show()
'''

# ==========================================

# CUSTOMER TENURE ANALYSIS

# ==========================================

# Group customers by tenure in months

df_clean["Tenure_Group"] = pd.cut(df_clean["tenure"],bins=[-1, 12, 24, 48, 72],labels=["0-12 Months", "13-24 Months", "25-48 Months", "49-72 Months"])

print("\n--- CHURN RATE BY TENURE GROUP ---")

tenure_churn = (df_clean.groupby("Tenure_Group", observed=True).agg(Total_Customers=("customerID", "count"),Churned_Customers=("Churn", lambda x: (x == "Yes").sum())))

tenure_churn["Churn_Rate"] = (tenure_churn["Churned_Customers"]/ tenure_churn["Total_Customers"]* 100).round(2)

print(tenure_churn)

# ==========================================

# TENURE CHURN VISUALIZATION

# ==========================================

'''plt.figure(figsize=(10, 5))

sns.barplot(
x=tenure_churn.index,
y=tenure_churn["Churn_Rate"]
)

plt.title("Customer Churn Rate by Tenure Group", fontsize=16)
plt.xlabel("Customer Tenure", fontsize=12)
plt.ylabel("Churn Rate (%)", fontsize=12)

# Display churn rates above the bars

for index, value in enumerate(tenure_churn["Churn_Rate"]):
    plt.text(index, value + 1, f"{value:.2f}%", ha="center", fontsize=10)
    plt.tight_layout()
plt.show()'''

# ==========================================

# CHURN ANALYSIS BY MONTHLY CHARGES

# ==========================================

# Group customers according to their monthly charges

df_clean["Monthly_Charge_Group"] = pd.cut(
df_clean["MonthlyCharges"],
bins=[0, 35, 70, float("inf")],
labels=["Low", "Medium", "High"],
include_lowest=True
)

print("\n--- CHURN RATE BY MONTHLY CHARGE GROUP ---")

charge_churn = (
df_clean.groupby("Monthly_Charge_Group", observed=True)
.agg(
Total_Customers=("customerID", "count"),
Churned_Customers=("Churn", lambda x: (x == "Yes").sum())
)
)

charge_churn["Churn_Rate"] = (
charge_churn["Churned_Customers"]
/ charge_churn["Total_Customers"]
* 100
).round(2)

print(charge_churn)


# ==========================================

# CHURN ANALYSIS BY INTERNET SERVICE

# ==========================================

print("\n--- CHURN RATE BY INTERNET SERVICE ---")

internet_churn = (df_clean.groupby("InternetService", observed=True).agg(Total_Customers=("customerID", "count"),Churned_Customers=("Churn", lambda x: (x == "Yes").sum())))

internet_churn["Churn_Rate"] = (internet_churn["Churned_Customers"]/ internet_churn["Total_Customers"]* 100).round(2)

print(internet_churn)


# ==========================================

# CHURN ANALYSIS BY PAYMENT METHOD

# ==========================================

print("\n--- CHURN RATE BY PAYMENT METHOD ---")

payment_churn = (df_clean.groupby("PaymentMethod", observed=True).agg(Total_Customers=("customerID", "count"),Churned_Customers=("Churn", lambda x: (x == "Yes").sum())))
payment_churn["Churn_Rate"] = (payment_churn["Churned_Customers"]/ payment_churn["Total_Customers"]* 100).round(2)

print(payment_churn)

# ==========================================

# CHURN ANALYSIS BY TECHNICAL SUPPORT

# ==========================================

print("\n--- CHURN RATE BY TECHNICAL SUPPORT ---")

support_churn = (df_clean.groupby("TechSupport", observed=True).agg(Total_Customers=("customerID", "count"),Churned_Customers=("Churn", lambda x: (x == "Yes").sum())))

support_churn["Churn_Rate"] = (support_churn["Churned_Customers"]/ support_churn["Total_Customers"]* 100).round(2)

print(support_churn)


# ==========================================

# MULTI-FACTOR CHURN ANALYSIS

# Contract Type + Internet Service

# ==========================================

print("\n--- CHURN RATE BY CONTRACT AND INTERNET SERVICE ---")

segment_churn = (df_clean.groupby(["Contract", "InternetService"],observed=True).agg(
Total_Customers=("customerID", "count"),Churned_Customers=("Churn",lambda x: (x == "Yes").sum())))

segment_churn["Churn_Rate"] = (segment_churn["Churned_Customers"]/ segment_churn["Total_Customers"]* 100).round(2)

print(segment_churn)
 

 # ==========================================

# CUSTOMER CHURN RISK SCORING

# ==========================================

# Start every customer's risk score at zero

df_clean["Risk_Score"] = 0

# Rule 1: Month-to-month contract

df_clean.loc[
df_clean["Contract"] == "Month-to-month",
"Risk_Score"
] += 2

# Rule 2: Tenure of 12 months or less

df_clean.loc[
df_clean["tenure"] <= 12,
"Risk_Score"
] += 2

# Rule 3: Fiber optic internet service

df_clean.loc[
df_clean["InternetService"] == "Fiber optic",
"Risk_Score"
] += 1

# Rule 4: Electronic check payment method

df_clean.loc[
df_clean["PaymentMethod"] == "Electronic check",
"Risk_Score"
] += 1

# Assign risk categories based on total score

df_clean["Risk_Category"] = pd.cut(
df_clean["Risk_Score"],
bins=[-1, 2, 4, 6],
labels=["Low Risk", "Medium Risk", "High Risk"]
)

print("\n--- CUSTOMER CHURN RISK SCORE DISTRIBUTION ---")

print(
df_clean["Risk_Category"].value_counts().reindex(
["High Risk", "Medium Risk", "Low Risk"]
)
)


# ==========================================

# RISK CATEGORY VALIDATION

# ==========================================

print("\n--- CHURN RATE BY RISK CATEGORY ---")

risk_analysis = (
df_clean.groupby("Risk_Category", observed=True).agg(Total_Customers=("customerID", "count"),Churned_Customers=("Churn", lambda x: (x == "Yes").sum())))

risk_analysis["Churn_Rate"] = (risk_analysis["Churned_Customers"]/ risk_analysis["Total_Customers"]* 100).round(2)

print(risk_analysis)


# ==========================================

# RISK CATEGORY CHURN VISUALIZATION

# ==========================================
'''
risk_plot = risk_analysis.reindex(
["Low Risk", "Medium Risk", "High Risk"]
)

plt.figure(figsize=(9, 5))

sns.barplot(
x=risk_plot.index,
y=risk_plot["Churn_Rate"]
)

plt.title("Historical Churn Rate by Risk Category", fontsize=16)
plt.xlabel("Customer Risk Category", fontsize=12)
plt.ylabel("Historical Churn Rate (%)", fontsize=12)

# Display percentages above the bars

for index, value in enumerate(risk_plot["Churn_Rate"]):
    plt.text(index, value + 1, f"{value:.2f}%", ha="center", fontsize=11)
    plt.tight_layout()
plt.show()'''

# ==========================================

# FINAL DATA AND KPI VALIDATION

# ==========================================

print("\n--- FINAL DATA VALIDATION ---")

# 1. Verify total customer records

print("Total rows:", len(df_clean))

# 2. Verify unique customer IDs

print("Unique customer IDs:", df_clean["customerID"].nunique())

# 3. Verify duplicate customer IDs

print("Duplicate customer IDs:", df_clean["customerID"].duplicated().sum())

# 4. Verify missing values in TotalCharges

print("Missing TotalCharges:", df_clean["TotalCharges"].isna().sum())

# 5. Verify churn counts

print("\nChurn counts:")
print(df_clean["Churn"].value_counts())

# 6. Verify overall churn and retention rates

total_customers = len(df_clean)
churned_customers = (df_clean["Churn"] == "Yes").sum()
retained_customers = (df_clean["Churn"] == "No").sum()

churn_rate = churned_customers / total_customers * 100
retention_rate = retained_customers / total_customers * 100

print("\nOverall KPIs:")
print(f"Total customers: {total_customers:,}")
print(f"Churned customers: {churned_customers:,}")
print(f"Retained customers: {retained_customers:,}")
print(f"Churn rate: {churn_rate:.2f}%")
print(f"Retention rate: {retention_rate:.2f}%")

# 7. Verify that churn and retention counts add up

print(
"\nCounts reconcile:",churned_customers + retained_customers == total_customers)

# 8. Verify the rule-based risk score

print("\nRisk score range:")
print("Minimum:", df_clean["Risk_Score"].min())
print("Maximum:", df_clean["Risk_Score"].max())

print("\nRisk category counts:")
print(
df_clean["Risk_Category"]
.value_counts()
.reindex(["Low Risk", "Medium Risk", "High Risk"])
)
