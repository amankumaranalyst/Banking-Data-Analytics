SELECT * FROM customer;

ALTER TABLE customer
CHANGE COLUMN `ï»¿Client ID` `Client ID` VARCHAR(20);

-- Q.1-> How many unique customers are present in the bank's customer database?

SELECT COUNT(DISTINCT `Client Id`) AS total_customers
FROM customer;

-- Q.2-> Which year had the highest number of new customers joining the bank?

SELECT 
    YEAR(STR_TO_DATE(`Joined Bank`, '%d-%m-%Y')) AS join_year,
    COUNT(*) AS total_customers
FROM customer
GROUP BY YEAR(STR_TO_DATE(`Joined Bank`, '%d-%m-%Y'))
ORDER BY total_customers DESC
LIMIT 1;

-- Q.3-> Identify the top 10 customers with the highest estimated income.
--       Display their Client ID, Name, Occupation, and Estimated Income.

SELECT 
    `Client Id`,
    Name,
    Occupation,
    `Estimated Income`
FROM customer
ORDER BY `Estimated Income` DESC
LIMIT 10;

-- Q.4-> For each loyalty classification, calculate the total number of customers, average estimated income, and average bank deposits.

SELECT 
    `Loyalty Classification`,
    COUNT(*) AS total_customers,
    ROUND(AVG(`Estimated Income`), 2) AS avg_income,
    ROUND(AVG(`Bank Deposits`), 2) AS avg_deposits
FROM customer
GROUP BY `Loyalty Classification`
ORDER BY avg_deposits DESC;

-- Q.5-> Identify customers whose bank loan amount is greater than their estimated income.
--     Display their Client ID, Name, Estimated Income, and Bank Loans.

SELECT 
    `Client Id`,
    Name,
    `Estimated Income`,
    `Bank Loans`
FROM customer
WHERE `Bank Loans` > `Estimated Income`
ORDER BY `Bank Loans` DESC;

-- Q.6-> Find all customers whose estimated income is higher than the overall average estimated income of all customers.

SELECT 
    `Client Id`,
    Name,
    `Estimated Income`
FROM customer
WHERE `Estimated Income` > (
    SELECT AVG(`Estimated Income`)
    FROM customer
)
ORDER BY `Estimated Income` DESC;

-- Q.7-> Find customers whose estimated income is equal to  the highest estimated income among Silver loyalty customers.

SELECT 
    `Client Id`,
    Name,
    `Loyalty Classification`,
    `Estimated Income`
FROM customer
WHERE `Estimated Income` = (
    SELECT MAX(`Estimated Income`)
    FROM customer
    WHERE `Loyalty Classification` = 'Silver'
)
ORDER BY `Estimated Income` DESC;


-- Q.8->Find customer pairs where both customers belong to the same loyalty classification,
--     but one customer has a higher estimated income than the other.

SELECT 
    c1.Name AS higher_income_customer,
    c2.Name AS lower_income_customer,
    c1.`Loyalty Classification`,
    c1.`Estimated Income` AS higher_income,
    c2.`Estimated Income` AS lower_income
FROM customer AS c1
JOIN customer AS c2
    ON c1.`Loyalty Classification` = c2.`Loyalty Classification`
   AND c1.`Estimated Income` > c2.`Estimated Income`
   AND c1.`Client Id` <> c2.`Client Id`;

-- Q.8-> Find customers whose bank deposits are higher than the average bank deposits of their own loyalty classification.

SELECT 
    c.client_id,
    c.Name,
    c.`Loyalty Classification`,
    c.`Bank Deposits`
FROM customer AS c
WHERE c.`Bank Deposits` > (
    SELECT AVG(c2.`Bank Deposits`)
    FROM customer AS c2
    WHERE c2.`Loyalty Classification` = c.`Loyalty Classification`
)
ORDER BY c.`Loyalty Classification`,
         c.`Bank Deposits` DESC;


-- Q.9-> Classify customers into Low, Medium, and High Financial Risk based on their Bank Loans relative to their Estimated Income:

SELECT
    `Client Id`,
    Name,
    `Estimated Income`,
    `Bank Loans`,
    ROUND(`Bank Loans` / `Estimated Income`, 2) AS loan_to_income_ratio,
    CASE
        WHEN `Bank Loans` / `Estimated Income` > 5
            THEN 'High Risk'
        WHEN `Bank Loans` / `Estimated Income` >= 2
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM customer
ORDER BY loan_to_income_ratio DESC;

-- Q.10-> Identify customers whose Bank Deposits are above the overall average deposit, 
--   but whose Credit Card Balance is below the overall average credit card balance.

SELECT
    `Client Id`,
    Name,
    `Bank Deposits`,
    `Credit Card Balance`
FROM customer
WHERE `Bank Deposits` > (
    SELECT AVG(`Bank Deposits`)
    FROM customer
)
AND `Credit Card Balance` < (
    SELECT AVG(`Credit Card Balance`)
    FROM customer
)
ORDER BY `Bank Deposits` DESC;

-- Q.11-> Create a financial strength category for each customer based on their deposits and loans:
--    Also calculate the difference between Bank Deposits and Bank Loans.

SELECT
    `Client Id`,
    Name,
    `Bank Deposits`,
    `Bank Loans`,
    (`Bank Deposits` - `Bank Loans`) AS financial_difference,
    CASE
        WHEN `Bank Deposits` > `Bank Loans`
            THEN 'Strong'
        WHEN `Bank Deposits` = `Bank Loans`
            THEN 'Balanced'
        ELSE 'Weak'
    END AS financial_status
FROM customer
ORDER BY financial_difference DESC;


-- Q.12-> Find the highest-income customer from each Loyalty Classification. 
-- Display the customer's name, loyalty classification, income, and rank within the loyalty segment.

WITH ranked_customers AS (
    SELECT
        `Client Id`,
        Name,
        `Loyalty Classification`,
        `Estimated Income`,
        RANK() OVER (
            PARTITION BY `Loyalty Classification`
            ORDER BY `Estimated Income` DESC
        ) AS income_rank
    FROM customer
)
SELECT
    `Client ID`,
    Name,
    `Loyalty Classification`,
    `Estimated Income`,
    income_rank
FROM ranked_customers
WHERE income_rank = 1
ORDER BY `Loyalty Classification`;


























































































