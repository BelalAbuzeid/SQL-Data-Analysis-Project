/*
======================================================================
Product Report
======================================================================
Purpose:
- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers (unique)
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last sale)
   - average order revenue (AOR)
   - average monthly revenue
======================================================================
*/

create view gold.report_products as
select
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		total_sales,
		total_orders,
		quantity,
		total_customers,
		lifespan,
		avg_sell_price,
		case
			when total_sales > 50000 then 'High Performance'
			when total_sales <= 10000 then 'Mid Range'
			else 'Low Performance'
		end as product_segmant,
		datediff(month,last_sale,GETDATE()) recency,
		case
			when lifespan = 0 then total_sales
			else total_sales / lifespan
		end as avg_order_revenue
from(
	select
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost,
		sum(f.sales_amount) total_sales,
		count(distinct f.order_number) total_orders,
		count(f.quantity) quantity,
		count(distinct customer_key) total_customers,
		max(order_date) last_sale,
		datediff(month,min(order_date),max(order_date)) lifespan,
		round(avg(cast(sales_amount as float) / nullif(quantity,0)),1) as avg_sell_price
	from gold.fact_sales f
	left join gold.dim_products p
	on p.product_key = f.product_key
	where order_date is not null
	group by
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
)t
