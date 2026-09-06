--  Day 1/30 — SELECT & Column Basics
select * from customers limit 4;

-- 2. Specific columns only
SELECT customer_id, first_name, last_name, income_band 
 FROM customers LIMIT 10;

-- 3. Selecting from a transactional table
SELECT transaction_id, amount_kes, channel, status
 FROM transactions LIMIT 10;

-- 4. Selecting from a financial product table
SELECT loan_id, loan_product, approved_amount, loan_status
 FROM loans LIMIT 10;

-- 5. Selecting with column reordering (output order ≠ table order)
SELECT status, amount_kes, transaction_id 
FROM transactions LIMIT 10;


-- 6. Pagination with LIMIT + OFFSET
SELECT customer_id, first_name 
 FROM customers LIMIT 10 OFFSET 20;

-- 7. Selecting a single column as a simple list
SELECT merchant_name 
 FROM merchants LIMIT 15;


-- Day 2/30 — Filtering Rows with WHERE


-- 1. Exact text match 
-- display the transactions that faailed
SELECT * 
 FROM transactions
  WHERE status = 'Failed';

-- 2. Numeric comparison
-- display the accounts with a current balance greater than 100,000
SELECT * 
 FROM accounts 
  WHERE current_balance > 100000;

-- 3. Filtering on a boolean-like flag
-- display the confirmed fraud events
SELECT * 
 FROM fraud_events
  WHERE confirmed_fraud = 1;

-- 4. Not-equal filter
-- display the loans that are not active
SELECT * 
 FROM loans 
  WHERE loan_status <> 'Active';

-- 5. Filtering on a foreign-key-style column
-- display all transactions for a specific customer
SELECT *
 FROM transactions
  WHERE customer_id = 'CUS001';

-- 6. Combining two conditions with AND
-- display all customers who are verified and active
SELECT * 
 FROM customers 
  WHERE kyc_status = 'Verified' AND customer_status = 'Active';

-- 7. Combining conditions with OR
-- display all loans that are either defaulted or have been past due for more than 30 days
SELECT *
 FROM loans 
  WHERE loan_status = 'Defaulted' OR days_past_due > 30;

-- 8. Negating a condition with NOT
-- display all merchants that are not inactive
SELECT *
 FROM merchants
  WHERE NOT merchant_status = 'Inactive';


---Day 3/30 — Comparison Operators, BETWEEN & IN


-- 1. BETWEEN on a monetary range
-- display all loans with approved amounts between 20,000 and 100,000
SELECT *
 FROM loans
  WHERE approved_amount BETWEEN 20000 AND 100000;

-- 2. BETWEEN on transaction size
-- display all transactions with amounts between 1,000 and 5,000
SELECT *
 FROM transactions
  WHERE amount_kes BETWEEN 1000 AND 5000;

-- 3. IN with a short list of categories
-- display all customers in the 20K-30K and 30K-50K income bands
SELECT *
 FROM customers
  WHERE income_band IN ('20K-30K', '30K-50K');

-- 4. IN with loan products
-- display all loans that are either Business Loans or Mobile Credit
SELECT *
 FROM loans
  WHERE loan_product IN ('Business Loan', 'Mobile Credit');

-- 5. IN with transaction channels
-- display all transactions that were made through Mobile or App channels
SELECT *
 FROM transactions
  WHERE channel IN ('Mobile', 'App');

-- 6. NOT IN to exclude categories
-- display all loans that are not paid or rejected
SELECT *
 FROM loans
  WHERE loan_status NOT IN ('Paid', 'Rejected');

-- 7. BETWEEN on interest rate
-- display all loans with interest rates between 10% and 15%
SELECT *
 FROM loans
  WHERE interest_rate BETWEEN 10 AND 15;

-- 8. BETWEEN on dates
-- display all transactions that occurred between January 1, 2024 and March 31, 2024
SELECT *
 FROM transactions
  WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31';

---

## Day 4/30 — Pattern Matching with LIKE


-- 1. Contains match
-- display all merchants whose name contains the word "Mart"
SELECT *
 FROM merchants
  WHERE merchant_name LIKE '%Mart%';

-- 2. Starts-with match
-- display all customers whose first name starts with "J"
SELECT *
 FROM customers
  WHERE first_name LIKE 'J%';

-- 3. Ends-with match
-- display all customers whose occupation ends with "Teacher"
SELECT *
 FROM customers
  WHERE occupation LIKE '%Teacher';
-- display all distinct occupations
SELECT DISTINCT occupation 
FROM customers;

-- 4. Contains match on a code/reference field
-- display all transactions whose reference number starts with "REF"
SELECT *
 FROM transactions
  WHERE reference_number LIKE 'REF%';

-- 5. Single-character wildcard with _
-- display all accounts whose account ID starts with "ACC00" and ends with any single character
SELECT *
 FROM accounts
  WHERE account_id LIKE 'ACC00_';

-- 6. Case-insensitive category search
-- display all merchants whose category contains the word "super" (case-insensitive)
SELECT *
 FROM merchants
  WHERE LOWER(merchant_category) LIKE '%super%';

-- 7. NOT LIKE to exclude a pattern
-- display all customers whose occupation does not contain the word "Student"
SELECT *
 FROM customers
  WHERE occupation NOT LIKE '%Student%';

-- 8. Multiple LIKE conditions combined
-- display all merchants whose name contains either "Shop" or "Store"
SELECT *
 FROM merchants
  WHERE merchant_name LIKE '%Shop%' OR merchant_name LIKE '%Store%';

## Day 5/30 — Handling NULLs


-- 1. Finding missing values
-- display all transactions that do not have a merchant ID assigned
SELECT *
 FROM transactions
  WHERE merchant_id IS NULL;

-- 2. Finding present values
-- display all transactions that have an agent ID assigned
SELECT *
 FROM transactions
  WHERE agent_id IS NOT NULL;

-- 3. Loans not yet approved (approval_date still null)
-- display all loans that have not yet been approved (approval_date is NULL)
SELECT *
 FROM loans
  WHERE approval_date IS NULL;

-- 4. COALESCE to substitute a default value
-- display all transactions, substituting 'N/A' for any missing merchant IDs
SELECT transaction_id, COALESCE(merchant_id, 'N/A') AS merchant_or_na 
 FROM transactions;

-- 5. IFNULL (MySQL shorthand for two-argument COALESCE)
-- display all loans, showing 'Pending' for any missing approval dates
SELECT loan_id, IFNULL(approval_date, 'Pending') AS approval_status
 FROM loans;

-- 6. Counting how many rows have a NULL in a column
-- display the count of transactions that are missing a merchant ID
SELECT COUNT(*) AS missing_merchant
 FROM transactions
  WHERE merchant_id IS NULL;

-- 7. COALESCE across three possible sources
-- display all transactions, showing the merchant ID if present, otherwise the agent ID, otherwise 'Direct'
SELECT transaction_id, COALESCE(merchant_id, agent_id, 'Direct') AS partner
 FROM transactions;

-- 8. Filtering out NULLs before aggregating
-- display the average fee amount for transactions that have a fee recorded
SELECT AVG(fee_kes) 
 FROM transactions 
  WHERE fee_kes IS NOT NULL;

## Day 6/30 — Aggregate Functions


-- 1. Row count
-- display the total number of transactions in the table
SELECT COUNT(*) AS total_transactions 
 FROM transactions;

-- 2. Sum of a numeric column
-- display the total value of all completed transactions
SELECT SUM(amount_kes) AS total_value
 FROM transactions
  WHERE status = 'Completed';

-- 3. Average
-- display the average interest rate across all loans
SELECT AVG(interest_rate) AS avg_interest_rate
 FROM loans;

-- 4. Min and max together
-- display the smallest and largest transaction amounts
SELECT MIN(amount_kes) AS smallest, MAX(amount_kes) AS largest 
 FROM transactions;

-- 5. Counting distinct values
-- display the number of unique customers who have made transactions
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
 FROM transactions;

-- 6. Multiple aggregates in one query
-- display the total number of loans, total approved amount, and average interest rate
SELECT COUNT(*) AS n_loans, SUM(approved_amount) AS total_disbursed, AVG(interest_rate) AS avg_rate
FROM loans;

-- 7. Aggregate with a filter
-- display the total fees collected for transaction fees only
SELECT SUM(fee_amount) AS total_fees FROM fees WHERE fee_type = 'Transaction Fee';

-- 8. Aggregate on a derived/calculated column
-- display the average days past due for active loans
SELECT AVG(days_past_due) AS avg_dpd
 FROM loans
  WHERE loan_status = 'Active';


## Day 7/30 — Grouping with GROUP BY


-- 1. Group by a single category
-- display the number of transactions per channel
SELECT channel, COUNT(*) AS n_transactions
 FROM transactions
  GROUP BY channel;

-- 2. Group by with SUM
-- display the total transaction value per transaction type
SELECT transaction_type, SUM(amount_kes) AS total_value
 FROM transactions
  GROUP BY transaction_type;

-- 3. Group by loan product
-- display the number of loans and average interest rate per loan product
SELECT loan_product, COUNT(*) AS n_loans, AVG(interest_rate) AS avg_rate
 FROM loans
  GROUP BY loan_product;

-- 4. Group by customer income band
-- display the number of customers in each income band
SELECT income_band, COUNT(*) AS n_customers
 FROM customers GROUP BY income_band;

-- 5. Group by merchant category
-- display the number of merchants in each category
SELECT merchant_category, COUNT(*) AS n_merchants
 FROM merchants
  GROUP BY merchant_category;

-- 6. Group by customer type
-- display the average income band (as a proxy for income level) per customer type
SELECT customer_type, AVG(income_band IS NOT NULL) AS has_income_data
 FROM customers
  GROUP BY customer_type;

SELECT distinct(customer_type)
 from customers;

-- 7. Group by month (using a date function inside GROUP BY)
-- display the number of transactions per month
SELECT strftime(transaction_date, '%Y-%m') AS txn_month, COUNT(*) AS n
 FROM transactions 
  GROUP BY txn_month
   ORDER BY txn_month;

-- 8. Group by two columns at once
-- display the number of transactions per channel and status combination
SELECT channel, status, COUNT(*) AS n
 FROM transactions
  GROUP BY channel, status;


## Day 8/30 — Filtering Groups with HAVING


-- 1. Only categories above a count threshold
-- display only loan products that have more than 50 loans
SELECT loan_product, COUNT(*) AS n_loans
 FROM loans
  GROUP BY loan_product
   HAVING COUNT(*) > 50;

-- 2. Only channels above an average value threshold
-- display only transaction channels where the average transaction amount is greater than 5,000
SELECT channel, AVG(amount_kes) AS avg_amt
 FROM transactions
  GROUP BY channel 
   HAVING AVG(amount_kes) > 5000;

-- 3. Only merchant categories with total value above a threshold
-- display only merchant categories where the total transaction value exceeds 500,000
SELECT merchant_category, SUM(t.amount_kes) AS total
FROM transactions t JOIN merchants m ON t.merchant_id = m.merchant_id
GROUP BY merchant_category HAVING SUM(t.amount_kes) > 500000;

-- 4. Combining WHERE (pre-filter) and HAVING (post-filter) in one query
-- display only loan products that are active and have more than 10 defaults
SELECT loan_product, COUNT(*) AS n_defaults
FROM loans WHERE loan_status = 'Defaulted'
GROUP BY loan_product HAVING COUNT(*) > 10;

-- 5. HAVING with a ratio calculation
-- display only transaction channels where the failure rate exceeds 30%
SELECT channel,
       SUM(CASE WHEN status='Failed' THEN 1 ELSE 0 END) / COUNT(*) AS fail_rate
FROM transactions
 GROUP BY channel
  HAVING fail_rate > 0.01;

-- 6. HAVING combined with ORDER BY
-- display only income bands with more than 100 customers, ordered by count descending
SELECT income_band, COUNT(*) AS n FROM customers
GROUP BY income_band HAVING COUNT(*) > 100 ORDER BY n DESC;


## Day 9/30 — Removing Duplicates with DISTINCT
-- 1. Unique income bands
-- display all unique income bands from the customers table
SELECT DISTINCT income_band 
 FROM customers;

-- 2. Unique transaction channels
-- display all unique transaction channels from the transactions table
SELECT DISTINCT channel
 FROM transactions;

-- 3. Unique loan products
-- display all unique loan products from the loans table
SELECT DISTINCT loan_product
 FROM loans;

-- 4. Unique merchant categories
-- display all unique merchant categories from the merchants table
SELECT DISTINCT merchant_category
 FROM merchants;

-- 5. Unique combinations of two columns
-- display all unique combinations of customer type and KYC status
SELECT DISTINCT customer_type, kyc_status
 FROM customers;

-- 6. Counting distinct values directly
-- display the number of unique loan products
SELECT COUNT(DISTINCT loan_product) AS n_products
 FROM loans;

-- 7. Distinct values with a filter applied first
-- display all unique transaction statuses for transactions made through the USSD channel
SELECT DISTINCT status 
 FROM transactions
  WHERE channel = 'USSD';


## Day 10/30 — Aliasing with AS
-- 1. Simple column alias
-- display customer ID and income band, with aliases for the output column names
SELECT customer_id AS id, income_band AS income
 FROM customers;

-- 2. Table alias shortening a query
-- display customer ID and first name from the customers table, using a table alias
SELECT c.customer_id, c.first_name
 FROM customers AS c LIMIT 5;

-- 3. Alias on a calculated column
-- display loan ID and estimated interest (approved amount * interest rate / 100) with an alias for the calculated column
SELECT loan_id, approved_amount * interest_rate / 100 AS estimated_interest
 FROM loans;

-- 4. Alias combining two columns
-- display customer full name by concatenating first and last names, with an alias for the output column
SELECT CONCAT(first_name, ' ', last_name) AS full_name
 FROM customers;

-- 5. Alias on an aggregate
-- display the number of transactions per channel, with an alias for the count
SELECT channel, COUNT(*) AS transaction_count
 FROM transactions
  GROUP BY channel;

-- 6. Multiple table aliases in a join
-- display transaction ID and customer first name, using aliases for both tables
SELECT t.transaction_id, c.first_name
FROM transactions AS t JOIN customers AS c ON t.customer_id = c.customer_id LIMIT 5;

-- 7. Alias without the AS keyword (also valid in MySQL)
-- display loan ID and approved amount, with an alias for the approved amount column
SELECT loan_id, approved_amount AS total_amount
 FROM loans LIMIT 5;

## Day 11/30 — Conditional Logic with CASE WHEN
-- 1. Income segmentation
-- display customer ID and a segment label based on income band
SELECT customer_id,
  CASE WHEN income_band IN ('20K-30K','30K-50K') THEN 'Mass Market'
       WHEN income_band IN ('50K-100K','100K-250K') THEN 'Middle Income'
       ELSE 'High Income' END AS segment
FROM customers;

-- 2. Transaction size bucket
-- display transaction ID and a size bucket label based on the amount
SELECT transaction_id,
  CASE WHEN amount_kes < 1000 THEN 'Small'
       WHEN amount_kes < 10000 THEN 'Medium'
       ELSE 'Large' END AS size_bucket
FROM transactions;

-- 3. Loan risk flag
-- display loan ID and a risk flag based on days past due
SELECT loan_id,
  CASE WHEN days_past_due > 60 THEN 'High Risk'
       WHEN days_past_due > 0 THEN 'Watch'
       ELSE 'Healthy' END AS risk_flag
FROM loans;

-- 4. Fraud severity based on risk score
-- display fraud event ID and a severity label based on the risk score
SELECT fraud_event_id,
  CASE WHEN risk_score >= 0.8 THEN 'Critical'
       WHEN risk_score >= 0.5 THEN 'Elevated'
       ELSE 'Low' END AS severity
FROM fraud_events;

-- 5. Account balance tier
-- display account ID and a tier label based on current balance
SELECT account_id,
  CASE WHEN current_balance > 200000 THEN 'Premium'
       WHEN current_balance > 50000 THEN 'Standard'
       ELSE 'Basic' END AS tier
FROM accounts;

-- 6. Binary flag using CASE
-- display loan ID and a binary flag indicating whether the loan is defaulted (1) or not (0)
SELECT loan_id, CASE WHEN loan_status = 'Defaulted' THEN 1 ELSE 0 END AS is_default 
 FROM loans;

-- 7. CASE inside an aggregate (very common pattern)
-- display the number of completed and failed transactions per channel
SELECT COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_count
 FROM transactions;

## Day 12/30 — Date & Time Functions
-- 1. Extract year-month
-- display transaction ID and the year-month of the transaction date
SELECT transaction_id, strftime(transaction_date, '%Y-%m') AS txn_month
 FROM transactions LIMIT 10;

SELECT transaction_id, strftime('%Y-%m', transaction_date) AS txn_month
FROM transactions
LIMIT 10;

-- 2. Extract year only
-- display loan ID and the year of the application date
SELECT loan_id, strftime('%Y', application_date) AS application_year
 FROM loans LIMIT 10;

-- 3. Extract day of week name
-- display transaction ID and the day of the week of the transaction date
SELECT transaction_id, strftime('%w', transaction_date) AS weekday
 FROM transactions LIMIT 10;

-- 4. Difference between two dates
-- display loan ID and the number of days between application and approval
SELECT loan_id, strftime('%J', approval_date) - strftime('%J', application_date) AS days_to_approve
 FROM loans LIMIT 10;

-- 5. Adding time to a date
-- display loan ID and the expected maturity date by adding the term in days to the approval date
SELECT loan_id, strftime('%Y-%m-%d', approval_date, '+' || term_days || ' days') AS expected_maturity
 FROM loans LIMIT 10;

-- 6. Filtering using a date function
-- display all transactions that occurred in December (month = 12)
SELECT * FROM transactions WHERE strftime('%m', transaction_date) = '12';

-- 7. Days since an event, relative to today
-- display customer ID and the number of days since registration
SELECT customer_id, strftime('%J', 'now') - strftime('%J', registration_date) AS days_as_customer
 FROM customers LIMIT 10;

-- 8. Extracting hour from a datetime (useful for behavior patterns)
SELECT transaction_id, strftime('%H', transaction_date) AS txn_hour
 FROM transactions LIMIT 10;

## Day 13/30 — String Functions
-- 1. Concatenation
-- display customer full name by concatenating first and last names
SELECT first_name || ' ' || last_name AS full_name
 FROM customers LIMIT 10;

-- 2. Uppercase
-- display customer occupation in uppercase
SELECT UPPER(occupation) AS occupation_upper 
 FROM customers LIMIT 10;

-- 3. Lowercase
-- display merchant category in lowercase
SELECT LOWER(merchant_category) AS category_lower
 FROM merchants LIMIT 10;

-- 4. Substring extraction
-- display customer ID and the first three digits of their phone number
SELECT customer_id, substr(phone_number, 1, 3) AS phone_prefix
 FROM customers LIMIT 10;

-- 5. String length
-- display merchant name and its length
SELECT merchant_name, LENGTH(merchant_name) AS name_length
 FROM merchants LIMIT 10;

-- 6. Trimming whitespace
-- display customer occupation with leading/trailing whitespace removed
SELECT TRIM(occupation) AS clean_occupation FROM customers LIMIT 10;

-- 7. Find-and-replace within text
-- display loan product names with "Loan" replaced by "Credit"
SELECT REPLACE(loan_product, 'Loan', 'Credit') AS renamed_product
 FROM loans LIMIT 10;

-- 8. LEFT / RIGHT character extraction
-- display transaction ID and the first 3 and last 4 characters of the reference number
SELECT transaction_id,
       substr(reference_number, 1, 3) AS ref_prefix,
       substr(reference_number, -4) AS ref_suffix
FROM transactions
LIMIT 10;

## Day 14/30 — Numeric & Rounding Functions
-- 1. Rounding to 2 decimals
-- display loan ID and estimated interest (approved amount * interest rate / 100) rounded to 2 decimal places
SELECT loan_id, ROUND(approved_amount * interest_rate / 100, 2) AS est_interest
 FROM loans LIMIT 10;

-- 2. Rounding to whole numbers
-- display transaction ID and the amount rounded to the nearest whole number
SELECT transaction_id, ROUND(amount_kes) AS rounded_amount
 FROM transactions LIMIT 10;

-- 3. Always round up
-- display loan ID and the term in months, always rounding up to the next whole month
SELECT loan_id, CEILING(term_days / 30.0) AS term_months
 FROM loans LIMIT 10;

-- 4. Always round down
-- display loan ID and the term in months, always rounding down to the last whole month
SELECT loan_id, FLOOR(term_days / 30.0) AS full_months_only
 FROM loans LIMIT 10;

-- 5. Absolute value (useful for signed differences)
-- display loan ID and the absolute difference between requested and approved amounts
SELECT loan_id, ABS(requested_amount - approved_amount) AS amount_gap
 FROM loans LIMIT 10;

-- 6. Modulo / remainder
-- display transaction ID and the remainder when the amount is divided by 100
SELECT transaction_id, MOD(amount_kes, 100) AS remainder_from_100
 FROM transactions LIMIT 10;

-- 7. Truncating without rounding
-- display loan ID and the interest rate truncated to 1 decimal place
SELECT loan_id, TRUNCATE(interest_rate, 1) AS rate_1dp FROM loans LIMIT 10;

-- 8. Percentage calculation
-- display loan ID and the percentage of the approved amount that is still outstanding
SELECT loan_id, ROUND(100.0 * outstanding_balance / approved_amount, 1) AS pct_outstanding
 FROM loans LIMIT 10;

## JOINS( INNER JOIN, LEFT JOIN, SELF JOIN, CROSS JOIN, FULL OUTER JOIN)
## Day 15/30 — INNER JOIN


-- 1. Transactions with customer names
-- display transaction ID, amount, and the first and last name of the customer
SELECT t.transaction_id, t.amount_kes, c.first_name, c.last_name
FROM transactions t INNER JOIN customers c ON t.customer_id = c.customer_id LIMIT 10;

-- 2. Loans with customer details
SELECT l.loan_id, l.approved_amount, c.income_band
FROM loans l INNER JOIN customers c ON l.customer_id = c.customer_id LIMIT 10;

-- 3. Transactions with merchant details
SELECT t.transaction_id, t.amount_kes, m.merchant_name, m.merchant_category
FROM transactions t INNER JOIN merchants m ON t.merchant_id = m.merchant_id LIMIT 10;

-- 4. Fraud events with the underlying transaction
SELECT f.fraud_event_id, f.risk_score, t.amount_kes, t.channel
FROM fraud_events f INNER JOIN transactions t ON f.transaction_id = t.transaction_id LIMIT 10;

-- 5. Loan repayments with loan details
SELECT r.repayment_id, r.amount_paid, l.loan_product, l.customer_id
FROM loan_repayments r INNER JOIN loans l ON r.loan_id = l.loan_id LIMIT 10;

-- 6. Accounts with customer details
SELECT a.account_id, a.current_balance, c.first_name, c.customer_type
FROM accounts a INNER JOIN customers c ON a.customer_id = c.customer_id LIMIT 10;

-- 7. Customer product enrollments with product names
SELECT cp.customer_id, p.product_name, cp.enrollment_date
FROM customer_products cp INNER JOIN products p ON cp.product_id = p.product_id LIMIT 10;
```

---

## Day 16/30 — LEFT JOIN

```sql
-- 1. All customers, with loan info if it exists
SELECT c.customer_id, c.first_name, l.loan_id, l.loan_status
FROM customers c LEFT JOIN loans l ON c.customer_id = l.customer_id LIMIT 10;

-- 2. Customers who have NEVER taken a loan
SELECT c.customer_id, c.first_name
FROM customers c LEFT JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;

-- 3. Transactions, flagging which ones have a fraud record
SELECT t.transaction_id, t.amount_kes, f.fraud_event_id
FROM transactions t LEFT JOIN fraud_events f ON t.transaction_id = f.transaction_id LIMIT 10;

-- 4. Loans that have never received a repayment
SELECT l.loan_id, l.loan_product
FROM loans l LEFT JOIN loan_repayments r ON l.loan_id = r.loan_id
WHERE r.repayment_id IS NULL;

-- 5. Merchants with zero transactions
SELECT m.merchant_id, m.merchant_name
FROM merchants m LEFT JOIN transactions t ON m.merchant_id = t.merchant_id
WHERE t.transaction_id IS NULL;

-- 6. All accounts, with a count of transactions (0 if none)
SELECT a.account_id, COUNT(t.transaction_id) AS n_transactions
FROM accounts a LEFT JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id;

-- 7. Customers with no registered beneficiary
SELECT c.customer_id
FROM customers c LEFT JOIN beneficiaries b ON c.customer_id = b.customer_id
WHERE b.beneficiary_id IS NULL;
```

---

## Day 17/30 — Joining Three or More Tables

```sql
-- 1. Transaction + customer + merchant
SELECT t.transaction_id, c.customer_type, m.merchant_category, t.amount_kes
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN merchants m ON t.merchant_id = m.merchant_id
LIMIT 10;

-- 2. Loan + customer + repayments
SELECT l.loan_id, c.income_band, r.amount_paid, r.repayment_date
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN loan_repayments r ON l.loan_id = r.loan_id
LIMIT 10;

-- 3. Fraud event + transaction + customer
SELECT f.fraud_event_id, f.fraud_type, c.customer_id, c.kyc_status
FROM fraud_events f
JOIN transactions t ON f.transaction_id = t.transaction_id
JOIN customers c ON t.customer_id = c.customer_id
LIMIT 10;

-- 4. Transaction + account + customer (three-hop chain)
SELECT t.transaction_id, a.account_status, c.first_name
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
LIMIT 10;

-- 5. Customer product enrollment + product + customer
SELECT c.customer_id, c.customer_type, p.product_name, cp.status
FROM customer_products cp
JOIN customers c ON cp.customer_id = c.customer_id
JOIN products p ON cp.product_id = p.product_id
LIMIT 10;

-- 6. Transaction + fees + customer (spend + cost together)
SELECT t.transaction_id, t.amount_kes, f.fee_amount, c.income_band
FROM transactions t
JOIN fees f ON t.transaction_id = f.transaction_id
JOIN customers c ON t.customer_id = c.customer_id
LIMIT 10;
```

---

## Day 18/30 — Self Joins

```sql
-- 1. Every unique pair of beneficiaries for the same customer
SELECT a.customer_id, a.beneficiary_name AS b1, b.beneficiary_name AS b2
FROM beneficiaries a
JOIN beneficiaries b ON a.customer_id = b.customer_id AND a.beneficiary_id < b.beneficiary_id;

-- 2. Customers who share the same county (excluding self-pairs)
SELECT a.customer_id AS customer_1, b.customer_id AS customer_2, a.county_id
FROM customers a
JOIN customers b ON a.county_id = b.county_id AND a.customer_id < b.customer_id
LIMIT 20;

-- 3. Pairs of loans belonging to the same customer, to compare amounts
SELECT a.customer_id, a.loan_id AS loan_1, b.loan_id AS loan_2,
       a.approved_amount AS amount_1, b.approved_amount AS amount_2
FROM loans a
JOIN loans b ON a.customer_id = b.customer_id AND a.loan_id < b.loan_id;

-- 4. Merchants in the same category, for competitor-style comparison
SELECT a.merchant_name AS merchant_1, b.merchant_name AS merchant_2, a.merchant_category
FROM merchants a
JOIN merchants b ON a.merchant_category = b.merchant_category AND a.merchant_id < b.merchant_id
LIMIT 20;

-- 5. Transactions by the same customer on the same day (potential structuring pattern)
SELECT a.customer_id, a.transaction_id AS txn_1, b.transaction_id AS txn_2, a.transaction_date
FROM transactions a
JOIN transactions b
  ON a.customer_id = b.customer_id
  AND DATE(a.transaction_date) = DATE(b.transaction_date)
  AND a.transaction_id < b.transaction_id
LIMIT 20;
```

---

## Day 19/30 — Combining Result Sets with UNION

```sql
-- 1. Two different risk flags combined into one watchlist
SELECT customer_id, 'High Value Transaction' AS reason FROM transactions WHERE amount_kes > 50000
UNION
SELECT t.customer_id, 'Confirmed Fraud' AS reason
FROM fraud_events f JOIN transactions t ON f.transaction_id = t.transaction_id
WHERE f.confirmed_fraud = 1;

-- 2. UNION ALL to combine failed and reversed transactions (keeping duplicates)
SELECT transaction_id, amount_kes, 'Failed' AS issue FROM transactions WHERE status = 'Failed'
UNION ALL
SELECT transaction_id, amount_kes, 'Reversed' AS issue FROM transactions WHERE status = 'Reversed';

-- 3. Combining defaulted loans and severely overdue active loans
SELECT loan_id, customer_id, 'Defaulted' AS flag FROM loans WHERE loan_status = 'Defaulted'
UNION
SELECT loan_id, customer_id, 'Severely Overdue' AS flag FROM loans WHERE days_past_due > 60;

-- 4. Combining two different partner types (merchants and agents) into one list
SELECT merchant_id AS partner_id, merchant_name AS partner_name, 'Merchant' AS partner_type FROM merchants
UNION
SELECT agent_id, agent_name, 'Agent' FROM agents;

-- 5. Combining high spenders and multi-loan customers into one "engaged customer" list
SELECT customer_id, 'High Spender' AS reason FROM transactions GROUP BY customer_id HAVING SUM(amount_kes) > 200000
UNION
SELECT customer_id, 'Multiple Loans' AS reason FROM loans GROUP BY customer_id HAVING COUNT(*) > 1;
```

---

## Day 20/30 — Subqueries in WHERE

```sql
-- 1. Customers who have a defaulted loan
SELECT * FROM customers
WHERE customer_id IN (SELECT customer_id FROM loans WHERE loan_status = 'Defaulted');

-- 2. Customers who have NEVER taken a loan (NOT IN version of a LEFT JOIN)
SELECT * FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM loans);

-- 3. Transactions above the overall average amount (scalar subquery)
SELECT * FROM transactions
WHERE amount_kes > (SELECT AVG(amount_kes) FROM transactions);

-- 4. Loans larger than the average approved amount
SELECT * FROM loans
WHERE approved_amount > (SELECT AVG(approved_amount) FROM loans);

-- 5. Merchants that have had at least one fraud event
SELECT * FROM merchants
WHERE merchant_id IN (
    SELECT DISTINCT t.merchant_id FROM transactions t
    JOIN fraud_events f ON t.transaction_id = f.transaction_id
);

-- 6. The single largest transaction (using a subquery instead of ORDER BY + LIMIT)
SELECT * FROM transactions
WHERE amount_kes = (SELECT MAX(amount_kes) FROM transactions);

-- 7. Customers whose account balance is below the overall average
SELECT * FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM accounts WHERE current_balance < (SELECT AVG(current_balance) FROM accounts)
);
```

---

## Day 21/30 — Subqueries in FROM (Derived Tables)

```sql
-- 1. Average total spend per income band (average of a sum)
SELECT income_band, ROUND(AVG(customer_total), 0) AS avg_spend
FROM (
    SELECT c.customer_id, c.income_band, SUM(t.amount_kes) AS customer_total
    FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.income_band
) AS per_customer
GROUP BY income_band;

-- 2. Default rate per loan product, computed from a pre-aggregated derived table
SELECT loan_product, defaults / total AS default_rate
FROM (
    SELECT loan_product,
           COUNT(*) AS total,
           SUM(CASE WHEN loan_status = 'Defaulted' THEN 1 ELSE 0 END) AS defaults
    FROM loans WHERE loan_status IN ('Paid', 'Defaulted')
    GROUP BY loan_product
) AS product_stats;

-- 3. Top 5 customers by total spend, using a derived table then sorting
SELECT * FROM (
    SELECT customer_id, SUM(amount_kes) AS total_spend
    FROM transactions GROUP BY customer_id
) AS spend_summary
ORDER BY total_spend DESC LIMIT 5;

-- 4. Monthly transaction counts, then finding the busiest month
SELECT txn_month, n FROM (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month, COUNT(*) AS n
    FROM transactions GROUP BY txn_month
) AS monthly
ORDER BY n DESC LIMIT 1;

-- 5. Filtering on an aggregated derived column (alternative to HAVING)
SELECT * FROM (
    SELECT customer_id, COUNT(*) AS n_transactions FROM transactions GROUP BY customer_id
) AS txn_counts
WHERE n_transactions > 10;
```

---

## Day 22/30 — Correlated Subqueries

```sql
-- 1. Loans priced above the average rate for their own product
SELECT l.loan_id, l.loan_product, l.interest_rate
FROM loans l
WHERE l.interest_rate > (
    SELECT AVG(l2.interest_rate) FROM loans l2 WHERE l2.loan_product = l.loan_product
);

-- 2. Loans larger than the average loan size for their own product
SELECT l.loan_id, l.loan_product, l.approved_amount
FROM loans l
WHERE l.approved_amount > (
    SELECT AVG(l2.approved_amount) FROM loans l2 WHERE l2.loan_product = l.loan_product
);

-- 3. Customers whose transaction count exceeds the average for their income band
SELECT c.customer_id, c.income_band
FROM customers c
WHERE (SELECT COUNT(*) FROM transactions t WHERE t.customer_id = c.customer_id) > (
    SELECT AVG(txn_count) FROM (
        SELECT c2.customer_id, c2.income_band, COUNT(t2.transaction_id) AS txn_count
        FROM customers c2 LEFT JOIN transactions t2 ON c2.customer_id = t2.customer_id
        WHERE c2.income_band = c.income_band
        GROUP BY c2.customer_id, c2.income_band
    ) AS band_avg
);

-- 4. Fraud events riskier than the average for their own fraud type
SELECT f.fraud_event_id, f.fraud_type, f.risk_score
FROM fraud_events f
WHERE f.risk_score > (SELECT AVG(f2.risk_score) FROM fraud_events f2 WHERE f2.fraud_type = f.fraud_type);

-- 5. Merchants whose transaction total exceeds the average for their category
SELECT m.merchant_id, m.merchant_category
FROM merchants m
WHERE (SELECT SUM(t.amount_kes) FROM transactions t WHERE t.merchant_id = m.merchant_id) > (
    SELECT AVG(cat_total) FROM (
        SELECT m2.merchant_id, SUM(t2.amount_kes) AS cat_total
        FROM merchants m2 JOIN transactions t2 ON m2.merchant_id = t2.merchant_id
        WHERE m2.merchant_category = m.merchant_category
        GROUP BY m2.merchant_id
    ) AS cat_avg
);
```

---

## Day 23/30 — Common Table Expressions (CTEs)

```sql
-- 1. A single CTE for monthly totals, then a clean SELECT on top
WITH monthly AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month, SUM(amount_kes) AS total
    FROM transactions GROUP BY txn_month
)
SELECT * FROM monthly ORDER BY txn_month;

-- 2. CTE + window function for month-over-month change
WITH monthly AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month, SUM(amount_kes) AS total
    FROM transactions GROUP BY txn_month
)
SELECT txn_month, total, total - LAG(total) OVER (ORDER BY txn_month) AS mom_change
FROM monthly;

-- 3. Two chained CTEs — customer totals, then income-band summary
WITH customer_totals AS (
    SELECT c.customer_id, c.income_band, SUM(t.amount_kes) AS total_spend
    FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.income_band
),
band_summary AS (
    SELECT income_band, AVG(total_spend) AS avg_spend, COUNT(*) AS n_customers
    FROM customer_totals GROUP BY income_band
)
SELECT * FROM band_summary ORDER BY avg_spend DESC;

-- 4. CTE isolating a risk segment, then joining back to customer detail
WITH risky_customers AS (
    SELECT customer_id FROM loans WHERE loan_status = 'Defaulted'
)
SELECT c.customer_id, c.first_name, c.income_band
FROM customers c JOIN risky_customers r ON c.customer_id = r.customer_id;

-- 5. CTE used purely for readability on a multi-step fraud calculation
WITH fraud_by_type AS (
    SELECT fraud_type, COUNT(*) AS n, AVG(risk_score) AS avg_score
    FROM fraud_events GROUP BY fraud_type
)
SELECT * FROM fraud_by_type WHERE n > 10 ORDER BY avg_score DESC;
```

---

## Day 24/30 — Window Functions: ROW_NUMBER, RANK & DENSE_RANK

```sql
-- 1. Rank each customer's loans by size, largest first
SELECT customer_id, loan_id, approved_amount,
       RANK() OVER (PARTITION BY customer_id ORDER BY approved_amount DESC) AS loan_rank
FROM loans;

-- 2. Number each customer's transactions in date order
SELECT customer_id, transaction_id, transaction_date,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date) AS txn_sequence
FROM transactions;

-- 3. Dense rank merchants by total transaction value (no gaps in ranking)
SELECT merchant_id, SUM(amount_kes) AS total_value,
       DENSE_RANK() OVER (ORDER BY SUM(amount_kes) DESC) AS value_rank
FROM transactions GROUP BY merchant_id;

-- 4. Rank customers by account balance within their own income band
SELECT c.customer_id, c.income_band, a.current_balance,
       RANK() OVER (PARTITION BY c.income_band ORDER BY a.current_balance DESC) AS balance_rank
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id;

-- 5. Use ROW_NUMBER to grab only each customer's single most recent transaction
SELECT * FROM (
    SELECT t.*, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date DESC) AS rn
    FROM transactions t
) ranked
WHERE rn = 1;

-- 6. Rank loan products by their default rate
SELECT loan_product, default_rate,
       RANK() OVER (ORDER BY default_rate DESC) AS risk_rank
FROM (
    SELECT loan_product,
           SUM(CASE WHEN loan_status='Defaulted' THEN 1 ELSE 0 END) / COUNT(*) AS default_rate
    FROM loans WHERE loan_status IN ('Paid','Defaulted') GROUP BY loan_product
) AS product_risk;
```

---

## Day 25/30 — Running Totals, Moving Averages & LAG/LEAD

```sql
-- 1. Running total of a single customer's transactions over time
SELECT transaction_date, amount_kes,
       SUM(amount_kes) OVER (ORDER BY transaction_date) AS running_total
FROM transactions WHERE customer_id = 'CUS001' ORDER BY transaction_date;

-- 2. Compare each transaction to the customer's previous one
SELECT customer_id, transaction_date, amount_kes,
       LAG(amount_kes) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS prev_amount
FROM transactions;

-- 3. Look ahead to the next scheduled repayment
SELECT loan_id, repayment_date, amount_due,
       LEAD(repayment_date) OVER (PARTITION BY loan_id ORDER BY repayment_date) AS next_due_date
FROM loan_repayments;

-- 4. 3-transaction moving average per customer (bounded window frame)
SELECT customer_id, transaction_date, amount_kes,
       AVG(amount_kes) OVER (
           PARTITION BY customer_id ORDER BY transaction_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg_3
FROM transactions;

-- 5. Cumulative loan disbursement by month
SELECT DATE_FORMAT(application_date, '%Y-%m') AS month, SUM(approved_amount) AS monthly_disbursed,
       SUM(SUM(approved_amount)) OVER (ORDER BY DATE_FORMAT(application_date, '%Y-%m')) AS cumulative_disbursed
FROM loans GROUP BY month;

-- 6. Percentage change transaction-to-transaction using LAG
SELECT customer_id, transaction_date, amount_kes,
       ROUND(100.0 * (amount_kes - LAG(amount_kes) OVER (PARTITION BY customer_id ORDER BY transaction_date))
             / LAG(amount_kes) OVER (PARTITION BY customer_id ORDER BY transaction_date), 1) AS pct_change
FROM transactions;
```

---

## Day 26/30 — Views

```sql
-- 1. A basic reusable summary view
CREATE VIEW vw_loan_summary AS
SELECT loan_product, COUNT(*) AS n_loans, AVG(interest_rate) AS avg_rate, SUM(approved_amount) AS total_disbursed
FROM loans GROUP BY loan_product;
SELECT * FROM vw_loan_summary;

-- 2. A per-customer risk view combining three tables
CREATE VIEW vw_customer_risk_summary AS
SELECT c.customer_id, c.income_band,
       COUNT(DISTINCT l.loan_id) AS total_loans,
       SUM(CASE WHEN l.loan_status = 'Defaulted' THEN 1 ELSE 0 END) AS defaults,
       COUNT(DISTINCT f.fraud_event_id) AS fraud_flags
FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
LEFT JOIN transactions t ON c.customer_id = t.customer_id
LEFT JOIN fraud_events f ON f.transaction_id = t.transaction_id
GROUP BY c.customer_id, c.income_band;
SELECT * FROM vw_customer_risk_summary WHERE defaults > 0;

-- 3. A monthly KPI view for a dashboard to query directly
CREATE VIEW vw_monthly_kpis AS
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month,
       COUNT(*) AS n_transactions,
       SUM(amount_kes) AS total_value,
       SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) / COUNT(*) AS success_rate
FROM transactions GROUP BY month;
SELECT * FROM vw_monthly_kpis ORDER BY month;

-- 4. A fraud investigation queue view
CREATE VIEW vw_fraud_queue AS
SELECT fraud_event_id, transaction_id, fraud_type, risk_score, investigation_status
FROM fraud_events WHERE investigation_status IN ('New', 'Investigating')
ORDER BY risk_score DESC;
SELECT * FROM vw_fraud_queue;

-- 5. Dropping a view when it's no longer needed
DROP VIEW IF EXISTS vw_fraud_queue;
```

---

## Day 27/30 — Indexes & Query Performance

```sql
-- 1. Single-column index on a frequently filtered column
CREATE INDEX idx_txn_customer ON transactions(customer_id);

-- 2. Index on a column used for sorting/filtering by date
CREATE INDEX idx_txn_date ON transactions(transaction_date);

-- 3. Composite index for a common two-column filter pattern
CREATE INDEX idx_txn_customer_date ON transactions(customer_id, transaction_date);

-- 4. Index on a status column used in many WHERE clauses
CREATE INDEX idx_loan_status ON loans(loan_status);

-- 5. Checking whether a query uses an index
EXPLAIN SELECT * FROM transactions WHERE customer_id = 'CUS001';

-- 6. Checking a join's query plan
EXPLAIN
SELECT t.transaction_id, c.first_name
FROM transactions t JOIN customers c ON t.customer_id = c.customer_id
WHERE c.income_band = '100K-250K';

-- 7. Removing an index that's no longer useful
DROP INDEX idx_loan_status ON loans;
```

---

## Day 28/30 — Stored Procedures

```sql
-- 1. Basic procedure taking one input parameter
DELIMITER //
CREATE PROCEDURE GetCustomerLoanSummary(IN cust_id VARCHAR(10))
BEGIN
    SELECT loan_id, loan_product, approved_amount, loan_status
    FROM loans WHERE customer_id = cust_id;
END //
DELIMITER ;
CALL GetCustomerLoanSummary('CUS001');

-- 2. Procedure with a date-range parameter
DELIMITER //
CREATE PROCEDURE GetMonthlyRevenue(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month, SUM(fee_kes) AS revenue
    FROM transactions
    WHERE transaction_date BETWEEN start_date AND end_date
    GROUP BY month;
END //
DELIMITER ;
CALL GetMonthlyRevenue('2024-01-01', '2024-12-31');

-- 3. Procedure returning a filtered risk list with a numeric threshold parameter
DELIMITER //
CREATE PROCEDURE FlagHighRiskLoans(IN dpd_threshold INT)
BEGIN
    SELECT loan_id, customer_id, days_past_due
    FROM loans WHERE days_past_due > dpd_threshold ORDER BY days_past_due DESC;
END //
DELIMITER ;
CALL FlagHighRiskLoans(30);

-- 4. Procedure with an OUT parameter returning a single computed value
DELIMITER //
CREATE PROCEDURE GetCustomerTotalSpend(IN cust_id VARCHAR(10), OUT total_spend DECIMAL(14,2))
BEGIN
    SELECT SUM(amount_kes) INTO total_spend FROM transactions WHERE customer_id = cust_id;
END //
DELIMITER ;
CALL GetCustomerTotalSpend('CUS001', @total);
SELECT @total;
```

---

## Day 29/30 — Transactions & Data Integrity (COMMIT/ROLLBACK)

```sql
-- 1. A basic two-step money transfer wrapped in a transaction
START TRANSACTION;
UPDATE accounts SET current_balance = current_balance - 5000 WHERE account_id = 'ACC001';
UPDATE accounts SET current_balance = current_balance + 5000 WHERE account_id = 'ACC002';
COMMIT;

-- 2. Rolling back if a check fails partway through
START TRANSACTION;
UPDATE accounts SET current_balance = current_balance - 5000 WHERE account_id = 'ACC001';
-- (application checks resulting balance here; if it's negative:)
ROLLBACK;

-- 3. Recording a loan disbursement as a single atomic unit
START TRANSACTION;
UPDATE loans SET loan_status = 'Active' WHERE loan_id = 'LOAN001';
UPDATE accounts SET current_balance = current_balance + 20000 WHERE account_id = 'ACC001';
COMMIT;

-- 4. Recording a repayment and updating the outstanding balance together
START TRANSACTION;
INSERT INTO loan_repayments (repayment_id, loan_id, repayment_date, amount_due, amount_paid, repayment_status)
VALUES ('REP9999', 'LOAN001', CURDATE(), 5000, 5000, 'Paid');
UPDATE loans SET outstanding_balance = outstanding_balance - 5000 WHERE loan_id = 'LOAN001';
COMMIT;

-- 5. Using a SAVEPOINT to roll back only part of a transaction
START TRANSACTION;
UPDATE accounts SET current_balance = current_balance - 1000 WHERE account_id = 'ACC001';
SAVEPOINT after_debit;
UPDATE accounts SET current_balance = current_balance + 1000 WHERE account_id = 'ACC999'; -- wrong account
ROLLBACK TO after_debit;
UPDATE accounts SET current_balance = current_balance + 1000 WHERE account_id = 'ACC002'; -- corrected
COMMIT;
```

---

## Day 30/30 — Capstone: Full Business Reports

```sql
-- 1. Customer segmentation report (CTE + CASE + window function)
WITH customer_activity AS (
    SELECT c.customer_id, c.income_band,
           SUM(t.amount_kes) AS total_spend,
           SUM(CASE WHEN l.loan_status='Defaulted' THEN 1 ELSE 0 END) AS n_defaults
    FROM customers c
    LEFT JOIN transactions t ON c.customer_id = t.customer_id AND t.status='Completed'
    LEFT JOIN loans l ON c.customer_id = l.customer_id
    GROUP BY c.customer_id, c.income_band
)
SELECT income_band,
       CASE WHEN n_defaults > 0 THEN 'At-Risk'
            WHEN total_spend > 100000 THEN 'High Value'
            ELSE 'Standard' END AS segment,
       COUNT(*) AS n_customers
FROM customer_activity GROUP BY income_band, segment ORDER BY income_band, segment;

-- 2. Monthly business scorecard (aggregates + ratios in one query)
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month,
       COUNT(*) AS n_transactions,
       SUM(amount_kes) AS total_value,
       SUM(fee_kes) AS total_fees,
       ROUND(100.0 * SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) / COUNT(*), 1) AS success_rate_pct
FROM transactions GROUP BY month ORDER BY month;

-- 3. Loan portfolio health report by product (joins + CASE + aggregates)
SELECT loan_product,
       COUNT(*) AS total_loans,
       SUM(approved_amount) AS total_disbursed,
       SUM(outstanding_balance) AS total_outstanding,
       ROUND(100.0 * SUM(CASE WHEN loan_status='Defaulted' THEN 1 ELSE 0 END) /
             SUM(CASE WHEN loan_status IN ('Paid','Defaulted') THEN 1 ELSE 0 END), 1) AS default_rate_pct
FROM loans GROUP BY loan_product;

-- 4. Fraud investigation priority list (window function + join)
SELECT f.fraud_event_id, t.customer_id, f.fraud_type, f.risk_score,
       RANK() OVER (ORDER BY f.risk_score DESC) AS priority_rank
FROM fraud_events f
JOIN transactions t ON f.transaction_id = t.transaction_id
WHERE f.investigation_status = 'New';

-- 5. Top 10 customers by lifetime value (derived table + join + rank)
SELECT c.customer_id, c.first_name, c.last_name, spend.total_spend,
       RANK() OVER (ORDER BY spend.total_spend DESC) AS value_rank
FROM (
    SELECT customer_id, SUM(amount_kes) AS total_spend FROM transactions GROUP BY customer_id
) AS spend
JOIN customers c ON c.customer_id = spend.customer_id
ORDER BY spend.total_spend DESC LIMIT 10;
```


