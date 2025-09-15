/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
 
 with yearly_product_sales as (
 select
	 -- if u want changes during month just change year func to month --
	 year(f.order_date) order_year,
	 p.product_name,
	 sum(f.sales_amount) current_sales
	 from gold.fact_sales f
 left join gold.dim_products p
 on f.product_key = p.product_key
 where order_date is not null
 group by 
	year(f.order_date),
	p.product_name
)

select 
	order_year,
	product_name,
	current_Sales,
	avg(current_sales) over(partition by product_name) currnet_avg,
	current_Sales - avg(current_sales) over(partition by product_name) as diff_avg,
	case when current_Sales - avg(current_sales) over(partition by product_name) > 0 Then 'Above Avg'
		 when current_Sales - avg(current_sales) over(partition by product_name) < 0 Then 'Below Avg'
		 else 'Equal to Avg'
	end as Flag,
	-- Year Over Year --
	lag(current_sales) over( partition by product_name order by order_year) py_sales,
	current_Sales - lag(current_sales) over( partition by product_name order by order_year) as diff_avg,
	case when current_Sales - lag(current_sales) over( partition by product_name order by order_year) > 0 Then 'Increase'
		 when current_Sales - lag(current_sales) over( partition by product_name order by order_year) < 0 Then 'Decrease'
		 else 'No Change'
	end as diif_avg_year

from yearly_product_sales
order by product_name , order_year 

	