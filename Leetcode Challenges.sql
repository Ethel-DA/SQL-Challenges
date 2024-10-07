--Question 1
--Write an SQL query to report the latest login for all users in the year 2020. Do not include the users who did not login in 2020.

SELECT  user_id , max(time_stamp) AS Last_stamp
FROM Logins
WHERE time_stamp LIKE '%2020%'
GROUP BY 1;

OR 

SELECT DISTINCT user_id, MAX(time_stamp) last_stamp
FROM Logins
WHERE YEAR(time_stamp) = '2020'
GROUP BY user_id;

--__________________________________________________________________________________________________________________________________________________________________________

--Question2
--Write an SQL query that will, for each user, return the number of followers.
--Return the result table ordered by user_id in asc.

SELECT user_id , 
 COUNT(follower_id) AS Followers_count
FROM Followers
GROUP BY user_id   
ORDER BY user_id ASC;
--_____________________________________________________________________________________________________________________________________________________________________

--Question3
--Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.

SELECT user_id,
    CONCAT(UPPER(SUBSTRING(name, 1, 1)), 
    LOWER(SUBSTRING(name, 2, length(name)))) AS name
FROM users;

--_____________________________________________________________________________________________________________________________________________________________________


--Question 4
--Write an SQL query to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
--Return the result table sorted in any order.


SELECT customer_id,
 COUNT(visit_id) AS count_no_trans
FROM visits
WHERE visit_id NOT IN (SELECT visit_id FROM transactions)
GROUP BY customer_id
ORDER BY count_no_trans;

--_____________________________________________________________________________________________________________________________________________________________________


--Question 5
--Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.
 
SELECT 
    u.user_id AS buyer_id, 
    u.join_date AS join_date, 
	COUNT(o.order_id) AS orders_in_2019
FROM users u
LEFT JOIN orders o ON u.user_id = o.buyer_id
AND year(o.order_date) = '2019'
GROUP BY u.user_id, u.join_date;

--_____________________________________________________________________________________________________________________________________________________________________

--Question 6
--Write an SQL query to calculate the bonus of each employee. The bonus of an employee is 100% of their salary if the ID of the employee is an odd number and the employee name does not start with the character 'M'. The bonus of an employee is 0 otherwise.

SELECT employee_id, 
CASE WHEN employee_id % 2 = 0 THEN 0
 WHEN name LIKE 'M%' THEN 0
   ELSE salary 
 END AS bonus
FROM employees
