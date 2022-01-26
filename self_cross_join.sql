# 1- Get all pairs of actors that worked together.
use sakila;
SELECT 
    a1.film_id,
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM
    (SELECT 
        a.actor_id, a.first_name, a.last_name, fa.film_id
    FROM
        sakila.actor a
    JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id) a1
        JOIN
    (SELECT 
        a.actor_id, a.first_name, a.last_name, fa.film_id
    FROM
        sakila.actor a
    JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id) a2
on
    a1.film_id = a2.film_id
        AND a1.actor_id <> a2.actor_id;
        
# 2- Get all pairs of customers that have rented the same film more than 3 times.        

SELECT 
    c1.customer_id AS customer_id1,
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer_name1,
    c2.customer_id AS customer_id2,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer_name2,
    COUNT(c1.rental_id) AS number_of_rentals,
    c1.film_id
FROM
    (SELECT 
        c.customer_id,
            c.first_name,
            c.last_name,
            r.rental_id,
            f.film_id
    FROM
        customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id) c1
        JOIN
    (SELECT 
        c.customer_id,
            c.first_name,
            c.last_name,
            r.rental_id,
            f.film_id
    FROM
        customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id) c2 ON c1.film_id = c2.film_id
        AND c1.customer_id <> c2.customer_id
GROUP BY 1 , 3
HAVING COUNT(c1.film_id) > 3
    AND COUNT(c2.film_id) > 3
ORDER BY 5 DESC;
# 3- Get all possible pairs of actors and films

SELECT 
    CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name,
    fa1.title
FROM
    actor
        CROSS JOIN
    (SELECT 
        f.film_id, f.title, fa.actor_id
    FROM
        film f
    JOIN film_actor fa ON f.film_id = fa.film_id) fa1
WHERE
    actor.actor_id = fa1.actor_id
LIMIT 50;
