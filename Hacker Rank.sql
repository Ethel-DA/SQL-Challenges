 --Question 1
--Samantha is interested in finding the total number of different projects completed.
--Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order.
--If there is more than one project that have the same number of completion days, then order by the start date of the project


SELECT start_date, 
MIN(end_date) AS end_date 
FROM
(
SELECT 
    start_date 
FROM projects 
WHERE start_date NOT IN ( SELECT end_date FROM projects)
) AS S,
(
SELECT end_date 
FROM projects 
WHERE end_date NOT IN ( SELECT start_date FROM projects)
) AS E
WHERE start_date < end_date
GROUP BY 1
ORDER BY DATEDIFF(MIN(end_date), start_date);

--___________________________________________________________________________________________________________________________________________________________________________________

--Question 2
--Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY. Continent) and their respective average city populations (CITY. Population) rounded down to the nearest integer.


SELECT c1.continent, 
        FLOOR(AVG(c2.population)) AS population
FROM country c1
 JOIN city c2
ON c1.code = c2.countrycode
GROUP BY 1;

--___________________________________________________________________________________________________________________________________________________________________________________


--Question 3
--Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.
--Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. 
--Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age.
--Input Format
--The following tables contain data on the wands in Ollivander's inventory:
-- Wands: The id is the id of the wand, code is the code of the wand, coins_needed is the total number of gold galleons needed to buy the wand, and power denotes the quality of the wand (the higher the power, the better the wand is).
--Wands_Property: The code is the code of the wand, age is the age of the wand, and is_evil denotes whether the wand is good for the dark arts. 
--If the value of is_evil is 0, it means that the wand is not evil. The mapping between code and age is one-one, meaning that if there are two pairs,  and , then  and .



WITH cte AS
(
    SELECT
        w.id,
        wp.age,
        w.coins_needed,
        ROW_NUMBER() OVER(PARTITION BY wp.age, w.power ORDER BY w.coins_needed) AS rn,
        w.power
    FROM Wands w
    INNER JOIN Wands_Property wp
    ON w.code = wp.code
    WHERE wp.is_evil = 0
)
SELECT
    id,
    age,
    coins_needed,
    power
FROM cte
WHERE rn = 1
ORDER BY  power desc , age DESC;
