--Question 1
--Facebook
--Assume you are given the tables below about Facebook pages and page likes.
-- Write a query to return the page IDs of all the Facebook pages that don't have any likes. 
--The output should be in ascending order
--From <https://datalemur.com/questions/sql-page-with-no-likes> 

SELECT p1.page_id 
FROM pages p1
LEFT JOIN page_likes p2 ON p1.page_id = p2.page_id
WHERE p2.liked_date IS NULL
ORDER BY  page_id ASC ; 

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 2
--New York Times Questions:
--Assume that you are given the table below containing information on viewership by device type (where the three types are laptop, tablet, and phone). 
--Define “mobile” as the sum of tablet and phone viewership numbers. 
--Write a query to compare the viewership on laptops versus mobile devices. 
--Output the total viewership for laptop and mobile devices in the format of "laptop views" and "mobile_views" 
--From <https://datalemur.com/questions/laptop-mobile-viewership> 

SELECT 
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0  END) AS laptop_views,
      SUM(CASE WHEN device_type IN ('tablet' , 'phone' ) THEN 1 ELSE 0 
        END ) AS mobile_views
FROM viewership

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 3
--Microsoft
--Write a query to find the top 2 power users who sent the most messages on Microsoft Teams in August 2022. 
--Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending count of the messages.
--From <https://datalemur.com/questions/teams-power-users> 

SELECT 
    sender_id,
    COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/31/2022'
GROUP BY sender_id
ORDER BY message_count DESC 
LIMIT 2;

OR


SELECT 
  sender_id,
  COUNT(message_id) AS count_messages
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
  AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY count_messages 
LIMIT 2;

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 4 
--Walmart
--Assume you are given the following tables on Walmart transactions and products. 
--Find the number of unique product combinations that are bought together (purchased in the same transaction).
--For example, if I find two transactions where apples and bananas are bought, and another transaction where bananas and soy milk are bought, 
--My output would be 2 to represent the 2 unique combinations. Your output should be a single number.
--From <https://datalemur.com/questions/frequently-purchased-pairs> 

WITH cte_unique_products AS
    (
SELECT   t.product_id AS Product_id, p.product_name, t.transaction_id,t.user_id
FROM products p
    INNER JOIN transactions t using (product_id))
--Output the results in percentages rounded to 2 decimal places.
--Notes:
--Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions
--To avoid integer division, you should multiply the click-through rate by 100.0, not 100.
--From <https://datalemur.com/questions/click-through-rate> 

WITH cte1 AS 
 (SELECT  app_id, 
COUNT(*) as count_click 
FROM events
WHERE event_type = 'click'
AND EXTRACT( YEAR FROM timestamp) = '2022'
GROUP BY 1),

 cte2 AS
 ( SELECT app_id, 
COUNT(*) AS count_impression 
FROM events
WHERE event_type = 'impression'
and EXTRACT( YEAR FROM timestamp) = '2022'
GROUP BY 1)

Select cte1.app_id ,ROUND((count_click * 100.0  /count_impression),2) AS ctr 
FROM cte2
JOIN cte1 
USING (app_id)
GROUP BY  1 ,2

OR 

WITH CTE AS 
(
SELECT app_id AS app, SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
      SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS impressions
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = 2022
GROUP BY 1
)

SELECT app as app_id, ROUND(100.0 * clicks/impressions,2) as ctr
FROM CTE


--__________________________________________________________________________________________________________________________________________________________________________

--Question 19
--Given the reviews table, write a query to get the average stars for each product every month.
--The output should include the month in numerical value, product id, and average star rating rounded to two decimal places. 
--Sort the output based on month followed by the product id.
--From <https://datalemur.com/questions/sql-avg-review-ratings> 

SELECT EXTRACT(MONTH FROM submit_date) as month,product_id, 
ROUND(AVG(stars),2) 
FROM reviews
GROUP BY 1,2
ORDER BY 1,2
--__________________________________________________________________________________________________________________________________________________________________________

--Question 20
--Assume you are given the table containing information on Amazon customers and their spending on products in various categories.
-- Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.
--From <https://datalemur.com/questions/sql-highest-grossing> 

SELECT Category, product, sum(spend) Total_spend 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) ='2022'
GROUP BY 1,2
ORDER BY category, total_spend DESC
LIMIT 4
--__________________________________________________________________________________________________________________________________________________________________________

--Question 21
--When you log in to your retailer client's database, you notice that their product catalog data is full of gaps in the category column. 
--Can you write a SQL query that returns the product catalog with the missing data filled in?
--Assumptions
--• Each category is mentioned only once in a category column.
--• All the products belonging to same category are grouped together.
--• The first product from a product group will always have a defined category.
--• Meaning that the first item from each category will not have a missing category value.
--From <https://datalemur.com/questions/fill-missing-product> 

WITH fill_products
AS (SELECT
  product_id,
  category,
  name,
  COUNT(category) OVER (ORDER BY product_id) AS category_group
FROM products)
SELECT
  product_id,
  FIRST_VALUE (category) OVER (PARTITION BY category_group ORDER BY product_id) AS category,
  name
FROM fill_products
--__________________________________________________________________________________________________________________________________________________________________________

--Question 22
--This is the same question as problem #23 in the SQL Chapter of Ace the Data Science Interview!
--Assume you have the table below-containing information on Facebook user actions. Write a query to obtain active user retention in July 2022. 
--Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).
--Hint: An active user is a user who has user action ("sign-in", "like", or "comment") in the current month and last month
--From <https://datalemur.com/questions/user-retention> 

WITH active_users_last_month AS (
  SELECT DISTINCT user_id
  FROM user_actions
  WHERE DATE_TRUNC('month', "event_date") = DATE_TRUNC('month', date '2022-06-01')
    AND event_type IN ('sign-in', 'like', 'comment')
),
active_users_current_month AS (
  SELECT DISTINCT user_id
  FROM user_actions
  WHERE DATE_TRUNC('month', "event_date") = DATE_TRUNC('month', date '2022-07-01')
    AND event_type IN ('sign-in', 'like', 'comment')
)
SELECT 7 AS month, COUNT(DISTINCT aucm.user_id) AS monthly_active_users
FROM active_users_current_month aucm
JOIN active_users_last_month aulm ON aucm.user_id = aulm.user_id;
--__________________________________________________________________________________________________________________________________________________________________________
