/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 


select
order_date,
total_sales,
sum(total_Sales) over(partition by order_date order by order_date) as runing_total_sales
from (
select 
	datetrunc(month,order_date) order_date,
	sum(sales_amount) total_Sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month,order_date)
)t

----------------------------------------------------------------------------------------------------------------
-- Cumulative Sales Per Year --
-------------------------------

select
order_date,
total_sales,
sum(total_Sales) over(order by order_date) as runing_total_sales
from (
select 
	datetrunc(year,order_date) order_date,
	sum(sales_amount) total_Sales
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
)t

----------------------------------------------------------------------------------------------------------------

