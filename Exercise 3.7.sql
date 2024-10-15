	/* In this task, you’ll practice everything you learned in the Exercise.
	You’ll write queries with joins between the address, country, city, customer, and payment tables using their common keys. 
	Create a new text document and call it “Answers 3.7.” As you’ve done in previous tasks,
	you’ll save your queries, outputs, and written answers in this document. */

	-- Tables: Address, Country, city, customer, payment 

	/* Write a query to find the top 10 countries for Rockbuster in terms of customer numbers.
	(Tip: you’ll have to use GROUP BY and ORDER BY, both of which follow the join.) */
	Select * from city; 
	Select * from address;
	Select * from Country;
	Select * from customer;
	Select * from payment;

Select count(customer_id) as Num_customers, country.country from customer as c
inner join address a on c.address_id = a.address_id
inner join city on city.city_id = a.city_id
inner join Country on country.country_id = city.country_id
group by country.country
order by num_customers desc
limit 10 ;
	
Select count(customer_id) as Num_customers, city.city,country.country  from customer as c
inner join address a on c.address_id = a.address_id
inner join city on city.city_id = a.city_id
inner join Country on country.country_id = city.country_id
group by city.city, country.country
order by num_customers desc
limit 10;



SELECT COUNT(c.customer_id) AS Num_customers, city.city, country.country
FROM customer AS c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country.country IN ('United States', 'turkey', 'Mexico', 'Brazil', 'Russian Federation', 'France','Philippines')
GROUP BY city.city, country.country
ORDER BY Num_customers DESC
LIMIT 10;

SELECT COUNT(c.customer_id) AS Num_customers, country.country,  city.city
FROM customer AS c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country.country IN ('United States', 'turkey', 'Mexico', 'Brazil', 'Russian Federation', 'France','Philippines')
GROUP BY city.city, country.country
ORDER BY Num_customers DESC
LIMIT 10;












/* Tip: After the join syntax,
you’ll need to use the WHERE clause with an operator, 
followed by GROUP BY and ORDER BY. Your output should include the 
following columns: 
Customer ID, Customer First Name and Last Name, Country, City, and Total Amount Paid. */


SELECT c.Customer_id, c.first_name,c.last_name,country.country,  city.city, SUM(payment.amount) as total_amount_paid
FROM customer AS c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ON city.city_id = a.city_id
INNER JOIN country ON country.country_id = city.country_id
Inner JOIN payment ON payment.customer_id = c.customer_id
WHERE city.city IN ('Aurora', 'Cabuyao', 'Sterling Heights', 'Korolev', 'Atlxco', 'Torren','So Leopoldo',
'Laredo', 'Ozamis', 'Imus')
GROUP BY c.customer_id, country.country,city.city
ORDER BY total_amount_paid DESC
LIMIT 10;

-- Top 10 Cities: Aurora, Cabuyao, Sterling Heights, korolev,Atlxco,Torren, So Leopoldo, 
-- Laredo, Ozamis, Imus









-- India = Adoni, China, United States = Aurora, Japan, Mexico,
-- Brazil, Russian Federation, Phillippines, turkey, Indonesia 
