/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

 select
 category,
 total_sales,
 sum(total_sales) over() over_all_sales,
 concat(round((cast(total_sales as float) / sum(total_sales) over()) *100,2),'%') Percentage_Sales
 from (
 select
	 p.category,
	 sum(f.sales_amount) total_sales
 from gold.fact_sales f
 left join gold.dim_products p
 on p.product_key = f.product_key
 group by p.category
 )t
order by total_sales desc