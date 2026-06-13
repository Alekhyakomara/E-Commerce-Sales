use datahub;
select * from ecommerce_sales_analysis;

select count(*) as total_records from ecommerce_sales_analysis; #1000 

-- 1. Total Sales per Product

SELECT product_id, product_name,
       (sales_month_1+sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+sales_month_12) AS total_units_sold
FROM ecommerce_sales_anlaysis
ORDER BY total_units_sold DESC;

-- 2. Revenue per Product

SELECT product_id, product_name,
       ((sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) * price) AS total_revenue
FROM ecommerce_sales_analysis
ORDER BY total_revenue DESC;

-- 3. Total revenue per Category

SELECT category,
       ((sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) * price) AS total_revenue
FROM ecommerce_sales_analysis
ORDER BY total_revenue DESC;

-- 4. Category-wise Sales (Revenue per category)

SELECT category,
       SUM(sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) AS total_units_sold,
       SUM((sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) * price) AS total_revenue
FROM ecommerce_sales_analysis
GROUP BY category
ORDER BY total_revenue DESC;   -- books,sports,Toys,Health,Electronics,clothing,Home&kitchen.

-- 5. Monthly Sales Trend (All Products)

SELECT 
   SUM(sales_month_1) AS Jan,
   SUM(sales_month_2) AS Feb,
   SUM(sales_month_3) AS Mar,
   SUM(sales_month_4) AS Apr,
   SUM(sales_month_5) AS May,
   SUM(sales_month_6) AS Jun,
   SUM(sales_month_7) AS Jul,
   SUM(sales_month_8) AS Aug,
   SUM(sales_month_9) AS Sep,
   SUM(sales_month_10) AS Oct,
   SUM(sales_month_11) AS Nov,
   SUM(sales_month_12) AS Decs
FROM ecommerce_sales_analysis;  -- Jan-498306,Feb-507661,Mar-506739,Apr-503823,May-487194,Jun-491653,Jul-507011,Aug-504569,Sep-491934,Oct-514798,Nov-505838,Decs-500386

-- 6. Top 10 Best selling products
SELECT product_id, product_name,category,
       ((sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) * price) AS total_revenue
FROM ecommerce_sales_analysis
ORDER BY total_revenue DESC Limit 10;

-- 6.  Product with highest review score (Minimum 50 reviews)
 
 SELECT product_id, product_name,category,review_score,review_count 
FROM ecommerce_sales_analysis WHERE review_count>=50
ORDER BY review_score DESC,review_count DESC Limit 10;  
-- health,sports,clothing,books,Toys,home&kitchen
 
-- 7. Product Growth (Month 1 vs Month 12)

SELECT product_id, product_name,
       (sales_month_12 - sales_month_1) AS growth
FROM ecommerce_sales_analysis
ORDER BY growth DESC;

-- 8. Average price by category 

SELECT category,avg(price) as average_price from ecommerce_sales_analysis 
GROUP BY category ORDER BY average_price DESC;

-- 9. correlation between Reviews and sales

SELECT product_id, product_name,review_score,review_count,
       (sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) AS total_units_sold
FROM ecommerce_sales_analysis
ORDER BY review_score DESC, total_units_sold DESC;

-- 10. Top Rated Products

SELECT product_name, review_score, review_count
FROM ecommerce_sales_analysis
ORDER BY review_score DESC, review_count DESC
LIMIT 10;

-- 11. Weighted Popularity (Reviews × Sales)

SELECT product_id, product_name,
       (review_score * review_count) AS weighted_review_score,
       (sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) AS total_units_sold
FROM ecommerce_sales_analysis
ORDER BY weighted_review_score DESC, total_units_sold DESC;

-- 12.product with no sales

SELECT product_id, product_name, category FROM ecommerce_sales_analysis 
 WHERE (sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12)=0;
       
-- 13. Products with Increasing Sales Trend (month_12>month_1)

SELECT product_id, product_name, category,sales_month_1,sales_month_12 
FROM ecommerce_sales_analysis WHERE sales_month_12 > sales_month_1
ORDER BY (sales_month_12-sales_month_1) DESC;

-- 14. Product with Decreasing Sales Trend (month_12<month_1)

SELECT product_id, product_name, category, sales_month_1, sales_month_12
FROM ecommerce_sales_analysis WHERE sales_month_12<sales_month_1
ORDER BY (sales_month_1-sales_month_12) DESC;

-- 15. Product with High reviews but Low Sales

SELECT product_id, product_name,category,review_score,review_count, 
       (sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12) AS total_units_sold 
FROM ecommerce_sales_analysis WHERE review_count>50 AND(sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12)<100 
ORDER BY review_score DESC; 

-- 16. Products with Price above Category Average

SELECT product_id, product_name, category, price FROM ecommerce_sales_analysis
WHERE price>(SELECT avg(price) AS average_price FROM ecommerce_sales_analysis WHERE category=category) 
ORDER BY category, price DESC;

-- 17. Products with Highest Revenue per Review

SELECT product_id, product_name, category, price, review_score, review_count,(price*
      (sales_month_1 + sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6+sales_month_7+sales_month_8+
       sales_month_9+sales_month_10+sales_month_11+ sales_month_12 ))/
IFNULL(review_count,0) AS revenue_per_review FROM ecommerce_sales_analysis
WHERE review_count>0 ORDER BY revenue_per_review DESC Limit 10;





