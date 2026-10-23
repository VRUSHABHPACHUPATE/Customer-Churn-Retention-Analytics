CREATE DATABASE customer_churn_db;
USE customer_churn_db;
USE customer_churn_db;

CREATE TABLE telco_customers (
customerID VARCHAR(20) PRIMARY KEY,
gender VARCHAR(10),
SeniorCitizen TINYINT,
Partner VARCHAR(5),
Dependents VARCHAR(5),
tenure INT,
PhoneService VARCHAR(5),
MultipleLines VARCHAR(25),
InternetService VARCHAR(20),
OnlineSecurity VARCHAR(25),
OnlineBackup VARCHAR(25),
DeviceProtection VARCHAR(25),
TechSupport VARCHAR(25),
StreamingTV VARCHAR(25),
StreamingMovies VARCHAR(25),
Contract VARCHAR(30),
PaperlessBilling VARCHAR(5),
PaymentMethod VARCHAR(40),
MonthlyCharges DECIMAL(10,2),
TotalCharges DECIMAL(10,2),
Churn VARCHAR(5)
);
SHOW tables;
DESCRIBE telco_customers;

SELECT COUNT(*)
FROM telco_customers;

SELECT COUNT(*) AS missing_total_charges
FROM telco_customers
WHERE TotalCharges IS NULL;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customerID) AS unique_customers
FROM telco_customers;

USE customer_churn_db;

ALTER TABLE telco_customers
MODIFY COLUMN TotalCharges DECIMAL(10,2) NULL;

SELECT COUNT(*) AS total_customers
FROM telco_customers;

SELECT COUNT(*) AS missing_total_charges
FROM telco_customers
WHERE TotalCharges IS NULL;

DESCRIBE telco_customers;

SELECT COUNT(*) AS total_customers
FROM telco_customers;


USE customer_churn_db;

CREATE TABLE telco_staging (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen VARCHAR(10),
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure VARCHAR(10),
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges VARCHAR(20),
    TotalCharges VARCHAR(20),
    Churn VARCHAR(10)
);

SELECT COUNT(*) AS TOTAL_CUSTOMERS
FROM telco_staging;

SELECT COUNT(*) AS missing_total_charges
FROM telco_staging
WHERE TotalCharges IS NULL;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customerID) AS unique_customers
FROM telco_staging;

SELECT
    customerID,
    COUNT(*) AS occurrences
FROM telco_staging
GROUP BY customerID
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT
    COUNT(*) AS blank_total_charges
FROM telco_staging
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = '';
   
   SELECT *
FROM telco_staging
WHERE customerID = '7590-VHVEG';

SELECT
    customerID,
    COUNT(*) AS occurrences,
    COUNT(DISTINCT CONCAT_WS('|',
        gender,
        SeniorCitizen,
        Partner,
        Dependents,
        tenure,
        PhoneService,
        MultipleLines,
        InternetService,
        OnlineSecurity,
        OnlineBackup,
        DeviceProtection,
        TechSupport,
        StreamingTV,
        StreamingMovies,
        Contract,
        PaperlessBilling,
        PaymentMethod,
        MonthlyCharges,
        TotalCharges,
        Churn
    )) AS distinct_versions
FROM telco_staging
GROUP BY customerID
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


USE customer_churn_db;

CREATE TABLE telco_clean AS
SELECT DISTINCT *
FROM telco_staging;

SELECT COUNT(*) AS clean_rows
FROM telco_clean;


SELECT COUNT(*) AS missing_total_charges
FROM telco_clean
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = '';
   
   SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customerID) AS unique_customers
FROM telco_clean;

SELECT
    COUNT(*) AS missing_total_charges
FROM telco_clean
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = '';
   
   DESCRIBE telco_customers;
   
   SELECT
    COUNT(*) AS null_values
FROM telco_clean
WHERE TotalCharges IS NULL;

SELECT
    COUNT(*) AS blank_values
FROM telco_clean
WHERE TRIM(TotalCharges) = '';


SELECT COUNT(*) AS existing_rows
FROM telco_customers;

SELECT COUNT(DISTINCT customerID) AS unique_customers
FROM telco_customers;

SELECT COUNT(*) AS missing_total_charges
FROM telco_customers
WHERE TotalCharges IS NULL;

SELECT
    c.customerID
FROM telco_clean AS c
LEFT JOIN telco_customers AS f
    ON c.customerID = f.customerID
WHERE f.customerID IS NULL;

SELECT
    c.customerID,
    c.tenure,
    c.MonthlyCharges,
    c.TotalCharges,
    c.Churn
FROM telco_clean AS c
LEFT JOIN telco_customers AS f
    ON c.customerID = f.customerID
WHERE f.customerID IS NULL;


SELECT
    COUNT(*) AS missing_customers,
    SUM(
        CASE
            WHEN TRIM(c.TotalCharges) = '' THEN 1
            ELSE 0
        END
    ) AS blank_total_charges
FROM telco_clean AS c
LEFT JOIN telco_customers AS f
    ON c.customerID = f.customerID
WHERE f.customerID IS NULL;


INSERT INTO telco_customers (
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn
)
SELECT
    c.customerID,
    c.gender,
    c.SeniorCitizen,
    c.Partner,
    c.Dependents,
    c.tenure,
    c.PhoneService,
    c.MultipleLines,
    c.InternetService,
    c.OnlineSecurity,
    c.OnlineBackup,
    c.DeviceProtection,
    c.TechSupport,
    c.StreamingTV,
    c.StreamingMovies,
    c.Contract,
    c.PaperlessBilling,
    c.PaymentMethod,
    CAST(c.MonthlyCharges AS DECIMAL(10,2)),
    CAST(NULLIF(TRIM(c.TotalCharges), '') AS DECIMAL(10,2)),
    c.Churn
FROM telco_clean AS c
LEFT JOIN telco_customers AS f
    ON c.customerID = f.customerID
WHERE f.customerID IS NULL;


SELECT COUNT(*) AS total_customers
FROM telco_customers;


SELECT COUNT(DISTINCT customerID) AS unique_customers
FROM telco_customers;

SELECT COUNT(*) AS missing_total_charges
FROM telco_customers
WHERE TotalCharges IS NULL;


#CHURN RATE PERCENTAGE
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,
    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,
    ROUND(
        SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telco_customers;


#CHURN RATE BY CONTRACT
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telco_customers
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;


#DOES CUSTOMER TENURE AFFECT CHURN?
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 Months'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 48 THEN '25-48 Months'
        ELSE '49-72 Months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customers

GROUP BY tenure_group

ORDER BY
    CASE tenure_group
        WHEN '0-12 Months' THEN 1
        WHEN '13-24 Months' THEN 2
        WHEN '25-48 Months' THEN 3
        WHEN '49-72 Months' THEN 4
    END;

#CUSTOMER CHURN BY INTERNET SERVICE
SELECT
    InternetService,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customers

GROUP BY InternetService

ORDER BY churn_rate_percentage DESC;

#CUSTOMER CHURN BY PAYMENT METHOD
SELECT
    PaymentMethod,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customers

GROUP BY PaymentMethod

ORDER BY churn_rate_percentage DESC;


#DOES MONTHLY SPENDING RELATE TO CHURN
SELECT
    CASE
        WHEN MonthlyCharges <= 35 THEN 'Low Charges'
        WHEN MonthlyCharges <= 70 THEN 'Medium Charges'
        ELSE 'High Charges'
    END AS charge_group,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customers

GROUP BY charge_group

ORDER BY
    CASE charge_group
        WHEN 'Low Charges' THEN 1
        WHEN 'Medium Charges' THEN 2
        WHEN 'High Charges' THEN 3
    END;
    
    
    
#Do senior citizens have a higher churn rate than non-senior citizens?

SELECT
    CASE
        WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
        ELSE 'Non-Senior Citizen'
    END AS customer_group,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customers

GROUP BY customer_group;


#CHURN BY GENDER

SELECT
    gender,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    SUM(
        CASE
            WHEN Churn = 'No' THEN 1
            ELSE 0
        END
    ) AS retained_customers,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customers

GROUP BY gender

ORDER BY churn_rate_percentage DESC;



#CTE's
WITH contract_churn AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers,
        ROUND(
            SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM telco_customers
    GROUP BY Contract
)
SELECT *
FROM contract_churn
ORDER BY churn_rate DESC;



#Find contracts above the overall churn rate
WITH contract_churn AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers,
        ROUND(
            SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM telco_customers
    GROUP BY Contract
),
overall_churn AS (
    SELECT
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*) AS overall_churn_rate
    FROM telco_customers
)
SELECT
    c.Contract,
    c.total_customers,
    c.churned_customers,
    c.churn_rate,
    ROUND(o.overall_churn_rate, 2) AS overall_churn_rate
FROM contract_churn AS c
CROSS JOIN overall_churn AS o
WHERE c.churn_rate > o.overall_churn_rate
ORDER BY c.churn_rate DESC;

#Find contract types exceeding the overall churn rate
WITH contract_churn AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers,
        ROUND(
            SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM telco_customers
    GROUP BY Contract
),
overall_churn AS (
    SELECT
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*) AS overall_churn_rate
    FROM telco_customers
)
SELECT
    c.Contract,
    c.total_customers,
    c.churned_customers,
    c.churn_rate,
    ROUND(o.overall_churn_rate, 2) AS overall_churn_rate
FROM contract_churn AS c
CROSS JOIN overall_churn AS o
WHERE c.churn_rate > o.overall_churn_rate
ORDER BY c.churn_rate DESC;

#Customer Churn Risk

WITH contract_churn AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers,
        ROUND(
            SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM telco_customers
    GROUP BY Contract
),
overall_churn AS (
    SELECT
        ROUND(
            SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS overall_churn_rate
    FROM telco_customers
)
SELECT
    c.Contract,
    c.total_customers,
    c.churned_customers,
    c.churn_rate,
    o.overall_churn_rate,
    ROUND(
        c.churn_rate - o.overall_churn_rate,
        2
    ) AS difference_from_overall
FROM contract_churn AS c
CROSS JOIN overall_churn AS o
ORDER BY c.churn_rate DESC;

#Rank customer segments by churn risk using CTEs

WITH contract_churn AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers,
        ROUND(
            SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM telco_customers
    GROUP BY Contract
),
ranked_contracts AS (
    SELECT
        Contract,
        total_customers,
        churned_customers,
        churn_rate,
        RANK() OVER (
            ORDER BY churn_rate DESC
        ) AS churn_risk_rank
    FROM contract_churn
)
SELECT *
FROM ranked_contracts
ORDER BY churn_risk_rank;

#Identify high-value customers who churn

WITH churned_customers AS (
    SELECT
        customerID,
        Contract,
        tenure,
        MonthlyCharges,
        TotalCharges,
        Churn
    FROM telco_customers
    WHERE Churn = 'Yes'
),
customer_value AS (
    SELECT
        *,
        CASE
            WHEN TotalCharges >= 2000 THEN 'High Value'
            WHEN TotalCharges >= 500 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_value_segment
    FROM churned_customers
)
SELECT
    customer_value_segment,
    COUNT(*) AS churned_customers,
    ROUND(SUM(TotalCharges), 2) AS total_historical_charges,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(tenure), 2) AS avg_tenure
FROM customer_value
GROUP BY customer_value_segment
ORDER BY total_historical_charges DESC;

#Identify the most vulnerable customer segments

WITH customer_segments AS (
    SELECT
        customerID,
        Contract,
        InternetService,
        PaymentMethod,
        CASE
            WHEN tenure <= 12 THEN 'New Customer'
            WHEN tenure <= 48 THEN 'Established Customer'
            ELSE 'Long-Term Customer'
        END AS tenure_group,
        Churn
    FROM telco_customers
),
segment_churn AS (
    SELECT
        Contract,
        InternetService,
        tenure_group,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers,
        ROUND(
            100.0 * SUM(
                CASE
                    WHEN Churn = 'Yes' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS churn_rate
    FROM customer_segments
    GROUP BY
        Contract,
        InternetService,
        tenure_group
),
ranked_segments AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY churn_rate DESC
        ) AS risk_rank
    FROM segment_churn
    WHERE total_customers >= 30
)
SELECT *
FROM ranked_segments
ORDER BY risk_rank, total_customers DESC;

#Build a Customer Churn Risk Classification

WITH customer_features AS (
    SELECT
        customerID,
        Contract,
        tenure,
        InternetService,
        PaymentMethod,
        MonthlyCharges,
        TotalCharges,
        Churn
    FROM telco_customers
),
customer_risk AS (
    SELECT
        *,
        (
            CASE
                WHEN Contract = 'Month-to-month'
                THEN 2
                ELSE 0
            END
            +
            CASE
                WHEN tenure <= 12
                THEN 2
                ELSE 0
            END
            +
            CASE
                WHEN InternetService = 'Fiber optic'
                THEN 1
                ELSE 0
            END
            +
            CASE
                WHEN PaymentMethod = 'Electronic check'
                THEN 1
                ELSE 0
            END
        ) AS risk_score
    FROM customer_features
)
SELECT
    CASE
        WHEN risk_score >= 5 THEN 'High Risk'
        WHEN risk_score >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category,
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS actual_churn_rate
FROM customer_risk
GROUP BY risk_category
ORDER BY actual_churn_rate DESC;

#Create a consolidated customer analysis dataset

CREATE OR REPLACE VIEW vw_customer_churn_analysis AS

WITH customer_features AS (
    SELECT
        customerID,
        gender,
        SeniorCitizen,
        Partner,
        Dependents,
        tenure,
        PhoneService,
        InternetService,
        Contract,
        PaymentMethod,
        MonthlyCharges,
        TotalCharges,
        Churn
    FROM telco_customers
),

customer_risk AS (
    SELECT
        *,
        (
            CASE
                WHEN Contract = 'Month-to-month' THEN 2
                ELSE 0
            END
            +
            CASE
                WHEN tenure <= 12 THEN 2
                ELSE 0
            END
            +
            CASE
                WHEN InternetService = 'Fiber optic' THEN 1
                ELSE 0
            END
            +
            CASE
                WHEN PaymentMethod = 'Electronic check' THEN 1
                ELSE 0
            END
        ) AS risk_score
    FROM customer_features
)


SELECT
    *,
    CASE
        WHEN risk_score >= 5 THEN 'High Risk'
        WHEN risk_score >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM customer_risk;



SELECT COUNT(*) AS total_customers
FROM vw_customer_churn_analysis;

SELECT
    risk_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM vw_customer_churn_analysis
GROUP BY risk_category
ORDER BY churn_rate DESC;

DESCRIBE vw_customer_churn_analysis;

#Finding 1: High-risk customers have very short tenure.
#Finding 2: The highest risk score has the highest observed churn proportion.
#Finding 3: Monthly charges alone do not explain churn.
SELECT
    risk_category,
    risk_score,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(tenure), 1) AS avg_tenure
FROM vw_customer_churn_analysis
GROUP BY risk_category, risk_score
ORDER BY risk_score DESC;

#RISK CLASSIFICATION VALIDATED SUCCESSFULLY
SELECT
    risk_category,
    MIN(risk_score) AS min_score,
    MAX(risk_score) AS max_score,
    COUNT(*) AS customer_count
FROM vw_customer_churn_analysis
GROUP BY risk_category
ORDER BY min_score DESC;

#final customer-level analytical view
SELECT
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS retained_customers,

    ROUND(
        AVG(CASE
            WHEN Churn = 'Yes' THEN 1.0
            ELSE 0.0
        END) * 100,
        2
    ) AS churn_rate,

    ROUND(AVG(MonthlyCharges), 2)
        AS avg_monthly_charges,

    ROUND(AVG(tenure), 2)
        AS avg_tenure

FROM vw_customer_churn_analysis;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customerID) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT customerID) AS duplicate_rows
FROM vw_customer_churn_analysis;

#VALIDATION
SELECT
    Churn,
    COUNT(*) AS total_customers
FROM vw_customer_churn_analysis
GROUP BY Churn;



USE customer_churn_db;

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customerID) AS unique_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END)
        AS retained_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS retention_rate
FROM vw_customer_churn_analysis;


#VALIDATING RISK CATEGORIES
USE customer_churn_db;

SELECT
    risk_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate
FROM vw_customer_churn_analysis
GROUP BY risk_category
ORDER BY
    CASE risk_category
        WHEN 'High Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        WHEN 'Low Risk' THEN 3
    END;
