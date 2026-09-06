Dataset: Fintech Mobile Money Platform (Kenya)

This is a simulated mobile-money fintech dataset modeled on Kenya's mobile financial services ecosystem (M-Pesa-style). It captures the full customer lifecycle across accounts, transactions, credit products, and fraud monitoring, stored as a SQLite database with 15 tables and 4 views.

Scope:

~1,000 customers across 7 income bands and KYC statuses, linked to demographic and registration data
~3,015 transactions (payments, transfers, bill payments, withdrawals, merchant payments) across Mobile, USSD, App, and Agent channels, spanning January 2024 – December 2025
500 loans (Salary Advance, Business Loan, Mobile Credit) with repayment schedules and delinquency tracking (days_past_due)
150 fraud events with risk scores and investigation outcomes
Supporting entities: 100 agents, 150 merchants, 7 products, and a customer_360 table that pre-aggregates each customer's balances, transaction activity, and loan exposure

Why this dataset: it mirrors a real fintech's operational data warehouse — normalized transactional tables alongside a denormalized customer_360 view — making it well suited for practicing data cleaning, multi-table joins, aggregation, time-series analysis, and fraud/credit-risk EDA end to end.

Known data quality notes (intentional/observed, worth flagging in the cleaning step):

transactions and fact_transactions largely duplicate each other; fact_transactions adds derived columns (transaction_hour, amount_bucket, is_successful)
vw_monthly_kpis uses MySQL syntax (DATE_FORMAT) incompatible with SQLite and will need to be rebuilt with strftime()
Nulls in merchant_id/agent_id are expected (a transaction routes through one or the other, not both)
