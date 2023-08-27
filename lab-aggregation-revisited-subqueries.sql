USE sakila;


# Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT c.first_name, c.last_name, c.email
FROM customer c
WHERE c.customer_id IN (SELECT DISTINCT r.customer_id FROM rental r);

# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    AVG(p.amount) AS total_amount
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY r.customer_id, full_name
ORDER BY total_amount DESC;

/* Select the name and email address of all the customers who have rented the "Action" movies.
Write the query using multiple join statements
Write the query using sub queries with multiple WHERE clause and IN condition
Verify if the above two queries produce the same results or not*/

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email AS email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category f ON f.film_id = i.film_id
JOIN category ca ON ca.category_id = f.category_id
WHERE ca.name = 'Action'
GROUP BY full_name, email;


SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email AS email
FROM customer c
WHERE c.customer_id IN (
    SELECT r.customer_id
    FROM rental r
    WHERE r.inventory_id IN (
        SELECT i.inventory_id
        FROM inventory i
        WHERE i.film_id IN (
            SELECT f.film_id
            FROM film f
            JOIN film_category fc ON f.film_id = fc.film_id
            JOIN category cat ON fc.category_id = cat.category_id
            WHERE cat.name = 'Action'
        )
    )
);

/*Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
*/

SELECT
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    AVG(p.amount) AS total_amount,
    CASE
        WHEN AVG(p.amount) BETWEEN 0 AND 2 THEN 'low'
        WHEN AVG(p.amount) BETWEEN 2 AND 4 THEN 'medium'
        ELSE 'high'
    END AS payment_label
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY r.customer_id, full_name
ORDER BY total_amount DESC;

