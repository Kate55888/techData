WITH description_table AS (
SELECT DISTINCT description
FROM film
)
SELECT description, COUNT() AS duplicates
FROM description_table
GROUP BY description
HAVING COUNT() > 1;

SELECT actor_id, COUNT() AS duplicates
FROM film_actor
GROUP BY actor_id
HAVING COUNT() > 1;

SELECT *
FROM film
WHERE rental_rate IS NULL;

SELECT *
FROM film_actor
WHERE actor_id IS NULL;

INSERT INTO error_log (error_message, date_created)
VALUES ('Error message text', CURRENT_TIMESTAMP);

