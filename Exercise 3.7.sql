-- -------------------------------------------------------
-- SQL Queries for Analyzing Rockbuster Customer Data
-- -------------------------------------------------------

-- Tables involved: Address, Country, City, Customer, Payment 

-- Query 1: Retrieve all records from relevant tables
SELECT * FROM city; 
SELECT * FROM address;
SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM payment;

-- -------------------------------------------------------
-- Query 2: Find the top 10 countries for Rockbuster 
-- based on the number of customers
SELECT COUNT(customer_id) AS Num_customers, 
       country.country 
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
GROUP BY country.country
ORDER BY Num_customers DESC
LIMIT 10;

-- -------------------------------------------------------
-- Query 3: Find the top 10 cities and countries 
-- based on the number of customers
SELECT COUNT(customer_id) AS Num_customers, 
       city.city, 
       country.country 
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
GROUP BY city.city, country.country
ORDER BY Num_customers DESC
LIMIT 10;

-- -------------------------------------------------------
-- Query 4: Count customers in specific countries
-- and group by city and country
SELECT COUNT(c.customer_id) AS Num_customers, 
       city.city, 
       country.country 
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country.country IN ('United States', 'Turkey', 'Mexico', 'Brazil', 'Russian Federation', 'France', 'Philippines')
GROUP BY city.city, country.country
ORDER BY Num_customers DESC
LIMIT 10;

-- -------------------------------------------------------
-- Query 5: Count customers in specific countries 
-- and display customer details along with total amount paid
SELECT c.customer_id, 
       c.first_name, 
       c.last_name, 
       country.country,  
       city.city, 
       SUM(payment.amount) AS total_amount_paid
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
INNER JOIN payment ON payment.customer_id = c.customer_id
WHERE city.city IN ('Aurora', 'Cabuyao', 'Sterling Heights', 'Korolev', 'Atlxco', 'Torren', 'So Leopoldo', 'Laredo', 'Ozamis', 'Imus')
GROUP BY c.customer_id, country.country, city.city
ORDER BY total_amount_paid DESC
LIMIT 10;

-- -------------------------------------------------------
-- Notes:
-- Top 10 Cities of Interest: 
-- Aurora, Cabuyao, Sterling Heights, Korolev, Atlxco, 
-- Torren, So Leopoldo, Laredo, Ozamis, Imus
