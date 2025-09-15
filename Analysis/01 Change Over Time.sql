/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions


select
    year(order_date) as order_year,
    sum(sales_amount) as total_Sales,
    sum(quantity) as total_quantity,
    count(distinct customer_key) as total_customers
from gold.fact_sales
where order_date is not null
group by year(order_date) 
order by year(order_date)

--------------------------------------------------------------------------------------------------------------
-- Total Sales per Month --
-------------------------------------------

select
    year(order_date) as order_year,
    month(order_date) as order_month,
    sum(sales_amount) as monthly_sales,
    sum(quantity) as total_quantity,
    count(distinct customer_key) as total_customers
from gold.fact_sales
where order_date is not null
group by year(order_date), month(order_date)
order by year(order_date), month(order_date)

--------------------------------------------------------------------------------------------------------------
-- Total Sales per Megerd Year and Month --
-------------------------------------------

select
    datetrunc(month,order_date) as order_date,
    sum(sales_amount) as monthly_sales,
    sum(quantity) as total_quantity,
    count(distinct customer_key) as total_customers
from gold.fact_sales
where order_date is not null
group by datetrunc(month,order_date)
order by datetrunc(month,order_date)

--------------------------------------------------------------------------------------------------------------