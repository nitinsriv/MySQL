#cust_dimen 
#    - customer names
#    - customer's location: Province and Region
#	 - customer segment - if they are small business, consumer, corporate, home office

#Primary key: Cust_Id
#Province Ontario ahs highest number of customers and Province Ontario has lowest.
#corporater segment customers are highest and small business lowest.

#============================================================================

# market_fact 

# orders details: order id and order quantity
# product in the order: prod_id
# shipping details: ship_id and shipping_cost
# customer detail: cust_id
# finance details: for each order, single row gives discount , sales, profit and product_base_margin for the product in that order

# Foreign Key: Ship_Id, Prod_Id, Cust_Id, Ord_Id
# Mostly ordered: Prod_6 - Office Supplies > Paper mostly ordered. It is brought by Emily phan who is under Consumenr customer_segment. 
# highest sales also recorded for Prod_6

#=============================================================================

# order_dim

# Order_Date: date of Order
# Order_Priority: priority of order - LOW, HIGH, NOT SPECIFIED, MEDIUM, CRITICAL
# Order_Id and Ord_Id: map Id 


# Primary Key: Order_id, Ord_Id

# High order priority are more in nuumber and Medium lowest

#==============================================================================


# prod_dimen

#Product_Category: Main product category
#Product_Sub_Category: Sub category for Product
#Prod_id: Identified of product

# Primary Key: Prod_id  
# Office Supplies have highest number of sub categories and products and technology lowest in products


#===============================================================================


#shipping_dimen

#Ship_ID: shipping identifier
#Order_Id: Order Identifier
#Shipping Mode:  Modes of Transportation - DELIVERY TRUCK, EXPRESS AIR, REGULAR AIR
#Ship_Date: Date of shipping

#Primary Key: Ship_Id
#foreign Key: Order_Id

# Transportation is more by AIR 


#====================================================================================

# A. Find the total and the average sales (display total_sales and avg_sales)
select sum(sales) as TotalSales, avg(sales) as AverageSales from market_fact

# B. Display the number of customers in each region in decreasing order of no_of_customers. 
#    The result should be a table with columns Region, no_of_customers.

select region, count(*) as TotalCustomers from cust_dimen group by region order by TotalCustomers Desc

#C. Find the region having maximum customers (display the region name and max(no_of_customers)
select * from (select region, count(*) as TotalCustomers from cust_dimen group by region order by TotalCustomers Desc) as Result LIMIT 1


# D. Find the number and id of products sold 
#    in decreasing order of products sold (display product id, no_of_products sold)
select prod_id, count(*) as NoSold from market_fact group by prod_id order by NoSold Desc


# E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
#    and the number of tables purchased (display the customer name, no_of_tables purchased)

select c.customer_name, count(*) as NoOfTables 
from market_fact m, prod_dimen pd, cust_dimen c
where pd.product_sub_category='TABLES'
and m.prod_id = pd.prod_id  
and c.cust_id=m.cust_id
and c.region like 'ATLANTIC'
group by m.cust_id
order by NoOfTables Desc


#A. Display the product categories in descending order of profits (display the product
#   category wise profits i.e. product_category, profits)?

select pd.product_category, sum(m.profit) as TotalProfit
from prod_dimen pd, market_fact m 
where m.prod_id = pd.prod_id 
group by pd.product_category
order by TotalProfit Desc


# B. Display the product category, product sub-category and the profit 
# within each subcategory in three columns.

select pd.product_category, pd.product_sub_category, sum(m.profit) as TotalProfit
from prod_dimen pd, market_fact m 
where m.prod_id = pd.prod_id 
group by pd.product_category, pd.product_sub_category


# C. Where is the least profitable product subcategory shipped the most? 
#    For the least profitable product sub-category, display the region-wise no_of_shipments
#    and the profit made in each region in decreasing order of profits (i.e. region,
#    no_of_shipments, profit_in_each_region)
#    o Note: You can hardcode the name of the least profitable product subcategory

# Find Product sub Category least profitable

select pd.product_sub_category, sum(profit) as TotalProfit 
from prod_dimen pd, market_fact m, shipping_dimen s, cust_dimen c
where m.prod_id = pd.prod_id 
and c.cust_id = m.cust_id
and m.ship_id=s.ship_id
group by pd.prod_id order by TotalProfit asc
LIMIT 1


# Find location where least profitable (TABLES) shipped:

select c.province, c.region, count(*) as Total
from cust_dimen c, prod_dimen pdOuter, market_fact m
where pdOuter.product_sub_category like 'TABLES'
and m.prod_id = pdOuter.prod_id 
and c.cust_id = m.cust_id
group by region
order by Total Desc
LIMIT 1



select c.region, count(*), sum(m.profit) as TotalProfit
from cust_dimen c, prod_dimen pdOuter, market_fact m, shipping_dimen s
where pdOuter.product_sub_category like 'TABLES'
and m.prod_id = pdOuter.prod_id 
and c.cust_id = m.cust_id
and m.ship_id = s.ship_id
group by c.region
order by TotalProfit


