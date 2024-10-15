-- CTE subquery for step 1: Calculate the total amount paid by customers from the top 10 countries
WITH total_amount_paid AS (
    SELECT 
        c.customer_id,               -- Select customer ID
        SUM(p.amount) AS total_amount_paid  -- Calculate the total amount paid by each customer
    FROM 
        customer AS c
    INNER JOIN address AS a ON c.address_id = a.address_id   -- Join with address to get customer address
    INNER JOIN city ON city.city_id = a.city_id              -- Join with city to get city information
    INNER JOIN country ON country.country_id = city.country_id -- Join with country to get country information
    INNER JOIN payment AS p ON c.customer_id = p.customer_id  -- Join with payment to sum amounts paid
    WHERE 
        city.city IN (
            -- Subquery to find cities in the top 10 countries with the most customers
            SELECT city.city
            FROM customer AS c
            INNER JOIN address AS a ON c.address_id = a.address_id
            INNER JOIN city ON city.city_id = a.city_id
            INNER JOIN country ON country.country_id = city.country_id
            WHERE country.country IN (
                -- Subquery to find the top 10 countries based on the number of customers
                SELECT country.country
                FROM customer AS c
                INNER JOIN address a ON c.address_id = a.address_id
                INNER JOIN city ON city.city_id = a.city_id
                INNER JOIN country ON country.country_id = city.country_id
                GROUP BY country.country
                ORDER BY COUNT(c.customer_id) DESC
                LIMIT 10
            )
            GROUP BY city.city
            ORDER BY COUNT(c.customer_id) DESC
            LIMIT 10
        )
    GROUP BY c.customer_id  -- Group by customer ID to calculate total per customer
    ORDER BY total_amount_paid DESC  -- Order by total amount paid in descending order
    LIMIT 5  -- Limit to the top 5 customers
)
-- Main query to calculate the average amount paid by these top 5 customers
SELECT ROUND(AVG(total_amount_paid)) AS average
FROM total_amount_paid; 



-- CTE step 2 subquery: Retrieve the top 5 customers by total amount paid, grouped by country
WITH top_5_customers AS (
    SELECT 
        c.customer_id,                 -- Select customer ID
        country.country,               -- Select the country of the customer
        SUM(p.amount) AS total_amount_paid  -- Calculate the total amount paid by each customer
    FROM customer AS c
    INNER JOIN address AS a ON c.address_id = a.address_id   -- Join with address to get customer address
    INNER JOIN city ON city.city_id = a.city_id              -- Join with city to get city information
    INNER JOIN country ON country.country_id = city.country_id -- Join with country to get country information
    INNER JOIN payment AS p ON c.customer_id = p.customer_id  -- Join with payment to sum amounts paid
    WHERE city.city IN (
        -- Similar subquery as before to filter cities in the top 10 countries
        SELECT city.city
        FROM customer AS c
        INNER JOIN address AS a ON c.address_id = a.address_id
        INNER JOIN city ON city.city_id = a.city_id
        INNER JOIN country ON country.country_id = city.country_id
        WHERE country.country IN (
            SELECT country.country
            FROM customer AS c
            INNER JOIN address a ON c.address_id = a.address_id
            INNER JOIN city ON city.city_id = a.city_id
            INNER JOIN country ON country.country_id = city.country_id
            GROUP BY country.country
            ORDER BY COUNT(c.customer_id) DESC
            LIMIT 10
        )
        GROUP BY city.city
        ORDER BY COUNT(c.customer_id) DESC
        LIMIT 10
    )
    GROUP BY c.customer_id, country.country  -- Group by customer ID and country to aggregate amounts
    ORDER BY total_amount_paid DESC  -- Order by total amount paid in descending order
    LIMIT 5  -- Limit to the top 5 customers
)
-- Main query to count all customers and top customers by country
SELECT 
    country.country,                              -- Select country
    COUNT(DISTINCT c.customer_id) AS all_customer_count,  -- Count all unique customers in the country
    COUNT(DISTINCT top_5_customers.customer_id) AS top_customer_count  -- Count unique top 5 customers
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id   -- Join to get customer address
INNER JOIN city ON city.city_id = a.city_id              -- Join to get city information
INNER JOIN country ON country.country_id = city.country_id -- Join to get country information
LEFT JOIN top_5_customers ON country.country = top_5_customers.country  -- Left join to include all countries
GROUP BY country.country  -- Group by country for aggregation
ORDER BY top_customer_count DESC;  -- Order by the number of top customers in descending order


# Summary of CTE Usage
# First CTE (total_amount_paid): This calculates the total amount paid by customers from the top 5 customers of the top 10 countries, allowing you to compute their average payment.

# Second CTE (top_5_customers): This identifies the top 5 customers by total payment within the same geographical constraints and joins this information with overall customer data to count all customers and specifically top customers by country.