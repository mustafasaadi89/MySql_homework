-- use sakila;

-- 1a. select first and last name from table actor
-- 		select first_name, last_name from actor;

-- 1b. display first and last name in one column named Actor name
-- 		select concat(first_name," ",last_name) as Actor_Name from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
-- 		select actor_id, first_name,last_name from actor where first_name = "Joe"

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
-- 		select first_name, last_name from actor where last_name like "%LI%" ORDER BY last_name,first_name;

--  Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
-- select country_id, country from country where country in ("Afghanistan", "Bangladesh", "China")

--  Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
/*
alter TABLE actor 
add middle_name varchar(30) after first_name
*/

-- 3b
-- alter TABLE actor change COLUMN middle_name middle_name blob

-- 3c
-- alter table actor drop column middle_name

-- 4a. List the last names of actors, as well as how many actors have that last name.
-- select last_name, count(*) as CountLastName from actor GROUP BY last_name order by CountLastName desc

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
-- select last_name, count(*) as CountLastName from actor GROUP BY last_name having CountLastName >=2 order by CountLastName desc

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
-- select actor_id from actor where first_name = "GROUCHO" and last_name="WILLIAMS"
-- update actor set first_name = "HARPO" where actor_id = 172;

/*
4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, 
change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
*/

/*
update actor 
set first_name = "GROUCHO" 
where actor_id in(
	select actor_id from (select actor_id from actor where first_name = "HARPO" and last_name="WILLIAMS") as actor2);
 */
 
-- 5a You cannot locate the schema of the address table. Which query would you use to re-create it
-- show create table address;
-- describe address

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
/*
select first_name,last_name, address
from staff s
join address b
on s.address_id = b.address_id;
*/

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
/*
select concat(first_name," ",last_name), sum(amount) total
from staff as s
join payment as p
on s.staff_id = p.staff_id
where month(p.payment_date)=8
GROUP BY s.staff_id;
*/

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join
/*
select title, count(f.film_id) Number_Of_Actors_In_Film
from film_actor f
join film a 
using (film_id)
group by title
order by Number_Of_Actors_In_Film desc

*/

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- select count(*) Copies_of_Hunchback_Impossible from inventory where film_id in (select film_id from film where title = "Hunchback Impossible")

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
/*
select  last_name,first_name, sum(amount) Total_Paid
from payment p 
join customer c 
using (customer_id)
group by customer_id
order by last_name;
*/

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
-- use film and language tables

-- select title,language_id from film where title like "K%" or title like "Q%" and language_id in (select language_id from language where name = "English");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
-- select first_name, last_name from actor where actor_id in (select actor_id from film_actor where film_id in (select film_id from film where title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
-- use table customer and address

-- select first_name, last_name, email from customer where address_id in (select address_id from address where city_id in (select city_id from city where country_id in (select country_id from country where country = "CANADA")))

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
-- use table film, film_category,category

-- select title, description from film where film_id in (select film_id from film_category where category_id in (select category_id from category where name = "Family"))

-- 7e. Display the most frequently rented movies in descending order.
-- use table rental, inventory, film
-- select title, count(inventory_id) Times_Rented from film where film_id in (select film_id from inventory where inventory_id in (select inventory_id from rental))
/*
select f.title, count(r.inventory_id) Times_Rented 
from rental r
join inventory
using (inventory_id)
join film f
using (film_id)
group by film_id 
order by Times_Rented desc
*/

-- 7f. Write a query to display how much business, in dollars, each store brought in.
-- use table store and payment
/*
select sum(p.amount) GrossIncome, s.store_id
from payment p 
join staff s 
using (staff_id)
group by store_id
*/

-- 7g. Write a query to display for each store its store ID, city, and country.
-- use table store, address, city, country
/*
select s.store_id, c.city, co.country 
from store s 
join address
using (address_id)
join city c
using (city_id)
join country co
using (country_id)
*/

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
/*
select c.name, sum(p.amount) Total_Revenue
from payment p
join rental
using (rental_id)
join inventory
using (inventory_id)
join film_category
using (film_id)
join category c
using (category_id)
group by name
order by Total_Revenue desc
limit 5
*/

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
/*
create view Top_Five_Grossing_Movies as
select c.name, sum(p.amount) Total_Revenue
from payment p
join rental
using (rental_id)
join inventory
using (inventory_id)
join film_category
using (film_id)
join category c
using (category_id)
group by name
order by Total_Revenue desc
limit 5
*/

-- 8b. How would you display the view that you created in 8a?
-- select * from Top_Five_Grossing_Movies

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
-- drop view Top_Five_Grossing_Movies

  
