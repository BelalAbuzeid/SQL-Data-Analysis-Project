/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

select
cost_range,
count(product_key) count_product
from (
	select
	product_key,
	product_name,
	cost,
	case when cost < 100 then 'Below 100'
		 when cost between 100 and 500 then '100-500'
		 when cost between 500 and 1000 then '500-1000'
		 else 'Above 1000'
	end cost_range
	from gold.dim_products
)t
group by cost_range
order by count_product desc

----------------------------------------------------------------------------
/*Group customers into three segments based on their spending behavior:

VIP: at least 12 months of history and spending more than €5,000.
Regular: at least 12 months of history but spending €5,000 or less.
New: lifespan less than 12 months.

And find the total number of customers by each group. */

select 
customer_category,
count(customer_category) Number_Customers
from (
select 
	customer_key,
	total_Sales,
	life_span,
	case when total_sales > 5000 and life_Span >= 12 then 'VIP'
		 when total_sales <= 5000 and life_Span >= 12 then 'Regular'
		 else 'New'
	end as Customer_Category
from (
	select
		c.customer_key,
		sum(f.sales_amount) as total_sales,
		min (order_date) first_order,
		max(order_date) last_order,
		datediff(month,min(order_date),max(order_date)) life_span
	from gold.fact_sales f
	left join gold.dim_customers c
	on c.customer_key = f.customer_key
	group by c.customer_key
)t
)y
group by customer_category
order by Number_Customers desc

