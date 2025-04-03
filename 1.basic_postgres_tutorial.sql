-- Section 1. Querying Data

-- select
select * from customer;

-- column aliases
select first_name || ' ' || last_name as full_name, email from customer;
select first_name || ' ' || last_name full_name, email from customer;
select first_name || ' ' || last_name "full name" from customer;

-- order by. default ASC
select first_name, last_name from customer order by first_name;
select first_name, last_name from customer order by first_name asc;
select first_name, last_name from customer order by last_name desc;
select first_name, last_name from customer order by first_name asc, last_name desc;
select first_name, last_name from customer where first_name like '%Kelly%' order by first_name asc, last_name desc;
-- In this example, the ORDER BY clause sorts rows by values in the first name column first. Then it sorts the sorted rows by values in the last name column.
-- As you can see clearly from the output, two customers with the same first name Kelly have the last name sorted in descending order.
select first_name, LENGTH(first_name) len from customer order by len desc;

-- create table sort_demo(num INT);
-- insert into sort_demo(num) values (1), (2), (3), (null);
select num from sort_demo order by num;
select num from sort_demo order by num nulls first;
select num from sort_demo order by num nulls last;
select num from sort_demo order by num desc;
select num from sort_demo order by num desc nulls last;

-- distinct
/*
drop table public.colors;
create table colors(
  id SERIAL primary key,
  bcolor VARCHAR,
  fcolor VARCHAR
);
insert into colors (bcolor, fcolor) values ('red', 'red'), ('red', 'red'), ('red', null), (null, 'red'), (null, null), ('green', 'green'), ('blue', 'blue'), ('blue', 'blue');
*/
select id, bcolor, fcolor from colors;
select distinct bcolor from colors order by bcolor;
-- Note that PostgreSQL treats NULLs as duplicates so that it keeps one NULL for all NULLs when you apply the SELECT DISTINCT clause
select distinct bcolor, fcolor from colors order by bcolor, fcolor;
-- In this example, the query uses the values from both bcolor and fcolor columns to evaluate the uniqueness of rows
-- it is using (bcolor, fcolor) combination to evaluate uniqueness
select distinct rental_rate from film order by rental_rate;





-- Section 2. Filtering Data
-- where clause
select first_name, last_name from customer where first_name = 'Jamie';
select first_name, last_name from customer where first_name = 'Jamie' and last_name = 'Rice';
select first_name, last_name from customer where first_name = 'Adam' or last_name = 'Rodriguez';
select first_name, last_name from customer where first_name in ('Ann', 'Anne', 'Annie');
select first_name, last_name from customer where first_name like 'Ann%';
select first_name, last_name from customer where first_name like 'Bra%' and last_name != 'Motley';
select
	first_name, LENGTH(first_name) name_length
from
	customer
where
	first_name like 'A%'
	and 
	LENGTH(first_name) between 3 and 5
order by
	name_length;

-- and operator
select 1 = 1 as result;
select true and true as result;
select true and false as result;
select true and null as result;
select false and false as result;
select false and null as result;
select null and null as result;
select title, length, rental_rate from film where length > 180 and rental_rate < 1;

-- or operator
select 1 != 1 as result;
select true or true as result;
select true or false as result;
select true or null as result;
select false or false as result;
select false or null as result;
select null or null as result;
select title, rental_rate from film where rental_rate = 0.99 or rental_rate = 2.99;

-- limit clause
select film_id, title, release_year from film order by film_id limit 5;
select film_id, title, release_year from film order by film_id limit 4 offset 3;
select film_id, title, release_year from film order by film_id offset 3 limit 4; -- same as above
/*
First, sort films by film id in ascending order.
Second, skip the first three rows using the OFFSET 3 clause.
Second, take the next four rows using the LIMIT 4 clause.
*/
select film_id, title, rental_rate from film order by rental_rate asc limit 10;  -- top N rows
select film_id, title, rental_rate from film order by rental_rate desc limit 10; -- bottom N ROWS

-- fetch clause follows SQL standard (use fetch instead of limit)
-- use row or rows
select film_id, title from film order by title fetch first row only;
select film_id, title from film order by title fetch first 1 row only; -- same as above query
select film_id, title from film order by title fetch first 5 rows only;
select film_id, title from film order by title offset 5 rows fetch first 5 rows only; -- skip first five records

-- in operator
select film_id, title from film where film_id in (1, 2, 3);
select film_id, title from film where film_id=1 or film_id=2 or film_id=3; -- same as above query
select first_name, last_name from actor where last_name in ('Allen', 'Chase', 'Davis') order by last_name;
select
	payment_id,
	amount,
	payment_date
from
	payment
where
	payment_date::date in ('2007-02-15', '2007-02-16');
/*
In this example, the payment_date column has the type timestamp that consists of both date and time parts.
To match the values in the payment_date column with a list of dates, you need to cast them to date values that have the date part only.
To do that you use the :: cast operator:
payment_date::date
For example, if the timestamp value is 2007-02-15 22:25:46.996577, the cast operator will convert it to 2007-02-15.
*/
select film_id, title from film where film_id not in (1, 2, 3) order by film_id;
select film_id, title from film where film_id != 1 and film_id != 2 and film_id != 3 order by film_id; -- same as above query

-- between operator
-- value BETWEEN low AND high;       or
-- value >= low AND value <= high    -- same as above
-- value NOT BETWEEN low AND high    or
-- value < low OR value > high		 -- same as above
select payment_id, amount from payment where payment_id between 17503 and 17505 order by payment_id;
select payment_id, amount from payment where payment_id not between 17503 and 17505 order by payment_id;
-- use date in ISO 8601 format, which is YYYY-MM-DD
select payment_id, amount, payment_date from payment where payment_date between '2007-02-15' and '2007-02-20' and amount > 10 order by payment_date;
select payment_id, amount, payment_date from payment where payment_date::date between '2007-02-15' and '2007-02-20' and amount > 10 order by payment_date;

-- like operator
-- % is pattern and _ is wildcard
select 'Apple' like 'Apple' as result;
select 'Apple' like 'A%' as result;
select first_name, last_name from customer where first_name like '%er%' order by first_name;
select first_name, last_name from customer where first_name like '_her%' order by first_name;
/*
The pattern _her% matches any strings that satisfy the following conditions:
  - The first character can be anything.
  - The following characters must be 'her'.
  - There can be any number (including zero) of characters after 'her'.
*/
select first_name, last_name from customer where first_name not like 'Jen%' order by first_name;
select first_name, last_name from customer where first_name ilike 'BAR%';  -- case-insensitive matching
select first_name, last_name from customer where first_name ~~* 'BAR%';    -- same as above
/*
LIKE 	 -> ILIKE
NOT LIKE -> NOT ILIKE
~~		 -> LIKE
~~*      -> ILIKE
!~~	     -> NOT LIKE
!~~*     -> NOT ILIKE
*/

/*
Sometimes, the data, that you want to match, contains the wildcard characters % and _. For example:
The rents are now 10% higher than last month
The new film will have _ in the title

To instruct the LIKE operator to treat the wildcard characters % and _ as regular literal characters, you can use the ESCAPE option in the LIKE operator:
string LIKE pattern ESCAPE escape_character;
*/

/*
create table t(
   message text
);
insert into t(message)
values('The rents are now 10% higher than last month'),
      ('The new film will have _ in the title');
*/

select message from t;
select * from t where message like '%10$%%' escape '$'; 
-- In the pattern %10$%%, the first and last % are the wildcard characters (like '%10%') whereas the % appears after the escape character $ is a regular character.

-- null operator
select null = null as result; -- The comparison of NULL with a value will always result in null
select address, address2 from address where address2 is null;
select address, address2 from address where address2 is not null;
/*
Notice that the address2 is empty, not NULL. This is a good example of bad practice when it comes to storing empty strings and NULL in the same column.
To fix it, you can use the UPDATE statement to change the empty strings to NULL in the address2 column, which you will learn in the UPDATE tutorial.
 */





-- Section 3. Joining Multiple Tables
/*
CREATE TABLE basket_a (
    a INT PRIMARY KEY,
    fruit_a VARCHAR (100) NOT NULL
);
CREATE TABLE basket_b (
    b INT PRIMARY KEY,
    fruit_b VARCHAR (100) NOT NULL
);
INSERT INTO basket_a (a, fruit_a)
VALUES
    (1, 'Apple'),
    (2, 'Orange'),
    (3, 'Banana'),
    (4, 'Cucumber');
INSERT INTO basket_b (b, fruit_b)
VALUES
    (1, 'Orange'),
    (2, 'Apple'),
    (3, 'Watermelon'),
    (4, 'Pear');
*/

SELECT * FROM basket_a;
SELECT * FROM basket_b;

-- inner join (common elements)
select
	a,
	fruit_a,
	b,
	fruit_b
from
	basket_a
inner join basket_b
    on
	fruit_a = fruit_b;

-- left join (left table + common elements)
-- LEFT JOIN = LEFT OUTER JOIN
-- left table + common elements
select
	a,
	fruit_a,
	b,
	fruit_b
from
	basket_a
left join basket_b
   on fruit_a = fruit_b;

-- left table - common
-- To select rows from the left table that do not have matching rows in the right table, you use the left join with a WHERE clause.
select
	a,
	fruit_a,
	b,
	fruit_b
from
	basket_a
left join basket_b
    on fruit_a = fruit_b
where
	b is null;

-- right join (right table + common elements)
-- RIGHT JOIN = RIGHT OUTER JOIN
-- right table + common elements
select
	a,
	fruit_a,
	b,
	fruit_b
from
	basket_a
right join basket_b 
	on fruit_a = fruit_b;

-- right table - common elements
select
	a,
	fruit_a,
	b,
	fruit_b
from
	basket_a
right join basket_b
   on fruit_a = fruit_b
where
	a is null;

-- full outer join
-- left table + right table + common elements 
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL OUTER JOIN basket_b
    ON fruit_a = fruit_b;

-- left table + right table - common elements
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL JOIN basket_b
   ON fruit_a = fruit_b
WHERE a IS NULL OR b IS NULL;


/* All joins summarized
--inner join
SELECT a, fruit_a, b, fruit_b
FROM basket_a 
INNER JOIN basket_b 
ON fruit_a = fruit_b;

--left join or left outer join
SELECT a, fruit_a, b, fruit_b
FROM basket_a 
LEFT JOIN basket_b 
ON fruit_a = fruit_b;
-- WHERE b IS NULL; -- to skip common elements

--right join or right outer join
SELECT a, fruit_a, b, fruit_b
FROM basket_a 
RIGHT JOIN basket_b 
ON fruit_a = fruit_b;
-- WHERE a IS NULL; -- to skip common elements

--full outer join
SELECT a, fruit_a, b, fruit_b
FROM basket_a 
FULL OUTER JOIN basket_b 
ON fruit_a = fruit_b;
-- WHERE a IS NULL OR b IS NULL; -- to skip common elements
 */



/*
 * self analysis:
 * Table A with columns (a varchar(50), b varchar(50))
 * Table B with columns (b varchar(50), c varchar(50))
 * Table C with columns (c varchar(50), d varchar(50))
 * 
 * |---------------|-----------------|----------------|
 * | tableA		   | tableB		     | tableC         |
 * |---------------|-----------------|----------------|
 * | (p, Lion)	   | (s, Parrot)	 | (v, Zebra)     |
 * | (q, Tiger)`   | (t, Tiger)`	 | (w, Horse)     |
 * | (r, Cheetah)` | (u, Cheetah)`~  | (x, Cheetah)~  |
 * |---------------|-----------------|----------------| 
 * 
 * select tablec.d
 * from tableA
 * inner join on tableB on tableA.b = tableB.b
 * inner join on tableC on tableB.c = tableC.c
 * 
 * Highlight common elements between A and B 										-> Tiger, Cheetah
 * Highlight common elements between highlighted B (ie. previous result set) and C 	-> Cheetah
 * Result is the highlighted element in table C
 * Common element from 3 circles
 */

-- self join
/*
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  first_name VARCHAR (255) NOT NULL,
  last_name VARCHAR (255) NOT NULL,
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES employee (employee_id) ON DELETE CASCADE
);

INSERT INTO employee (employee_id, first_name, last_name, manager_id)
VALUES
  (1, 'Windy', 'Hays', NULL),
  (2, 'Ava', 'Christensen', 1),
  (3, 'Hassan', 'Conner', 1),
  (4, 'Anna', 'Reeves', 2),
  (5, 'Sau', 'Norman', 2),
  (6, 'Kelsie', 'Hays', 3),
  (7, 'Tory', 'Goff', 3),
  (8, 'Salley', 'Lester', 3);
  
  
*/

SELECT * FROM employee;

SELECT
  e.first_name || ' ' || e.last_name employee,
  m.first_name || ' ' || m.last_name manager
FROM
  employee e
  INNER JOIN employee m ON m.employee_id = e.manager_id
ORDER BY
  manager;

SELECT
  e.first_name || ' ' || e.last_name employee,
  m.first_name || ' ' || m.last_name manager
FROM
  employee e
  LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY
  manager;
/*
This query references the employees table twice, one as the employee and the other as the manager. It uses table aliases e for the employee and m for the manager.
The join predicate finds the employee/manager pair by matching values in the employee_id and manager_id columns.
Notice that the top manager does not appear on the output.
To include the top manager in the result set, you use the LEFT JOIN instead of INNER JOIN clause as shown in the following query:
*/

-- cross join
/*
DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;
CREATE TABLE
  T1 (LABEL CHAR(1) PRIMARY KEY);
CREATE TABLE
  T2 (score INT PRIMARY KEY);
INSERT into T1 (LABEL) VALUES ('A'), ('B');
INSERT into T2 (score) values (1), (2), (3);
*/

SELECT *
FROM T1
CROSS JOIN T2
order by t1.label asc;

-- natural join


-- Section 4. Grouping Data
-- group by
-- The following query uses the GROUP BY clause to retrieve the total payment paid by each customer:
SELECT
  customer_id,
  SUM (amount)
FROM
  payment
GROUP BY
  customer_id
ORDER BY
  customer_id
limit 5;

-- The following statement uses the ORDER BY clause with GROUP BY clause to sort the groups by total payments:
SELECT
  customer_id,
  SUM (amount)
FROM
  payment
GROUP BY
  customer_id
ORDER BY
  SUM (amount) DESC;

-- In this example, we join the payment table with the customer table using an inner join to get the customer names and group customers by their names.
SELECT
  first_name || ' ' || last_name full_name,
  SUM (amount) amount
FROM
  payment
  INNER JOIN customer USING (customer_id)
GROUP BY
  full_name
ORDER BY
  amount DESC;

-- In this example, the GROUP BY clause divides the rows in the payment table into groups and groups them by value in the staff_id column. 
-- For each group, it counts the number of rows using the COUNT() function.
SELECT
	staff_id,
	COUNT (payment_id)
FROM
	payment
GROUP BY
	staff_id;

-- In this example, the GROUP BY clause divides the rows in the payment table by the values in the customer_id and staff_id columns. 
-- For each group of (customer_id, staff_id), the SUM() calculates the total amount.
SELECT
  customer_id,
  staff_id,
  SUM(amount)
FROM
  payment
GROUP BY
  staff_id,
  customer_id
ORDER BY
  customer_id;

-- Since the values in the payment_date column are timestamps, we cast them to date values using the cast operator ::
SELECT
  payment_date::date payment_date,
  SUM(amount) sum
FROM
  payment
GROUP BY
  payment_date::date
ORDER BY
  payment_date DESC;

-- having operator
-- The following query uses the GROUP BY clause with the SUM() function to find the total payment of each customer:
SELECT
  customer_id,
  SUM (amount) amount
FROM
  payment
GROUP BY
  customer_id
ORDER BY
  amount DESC;

-- The following statement adds the HAVINGclause to select the only customers who have been spending more than 200
SELECT
  customer_id,
  SUM (amount) amount
FROM
  payment
GROUP BY
  customer_id
HAVING
  SUM (amount) > 200
ORDER BY
  amount DESC;

-- The following query uses the GROUP BY clause to find the number of customers per store:
SELECT
  store_id,
  COUNT (customer_id)
FROM
  customer
GROUP BY
  store_id;

-- The following statement adds the HAVING clause to select a store that has more than 300 customers
SELECT
  store_id,
  COUNT (customer_id)
FROM
  customer
GROUP BY
  store_id
HAVING
  COUNT (customer_id) > 300;










-- TODO:
-- Section 5. Set Operations
-- union
-- union all
-- The UNION operator removes all duplicate rows from the combined data set. To retain the duplicate rows, you use the UNION ALL instead.
/*
CREATE TABLE top_rated_films(
  title VARCHAR NOT NULL,
  release_year SMALLINT
);
CREATE TABLE most_popular_films(
  title VARCHAR NOT NULL,
  release_year SMALLINT
);
INSERT INTO top_rated_films(title, release_year)
VALUES
   ('The Shawshank Redemption', 1994),
   ('The Godfather', 1972),
   ('The Dark Knight', 2008),
   ('12 Angry Men', 1957);
INSERT INTO most_popular_films(title, release_year)
VALUES
  ('An American Pickle', 2020),
  ('The Godfather', 1972),
  ('The Dark Knight', 2008),
  ('Greyhound', 2020);
*/

SELECT * FROM top_rated_films;
SELECT * FROM most_popular_films;

-- union: Use the UNION to combine result sets of two queries and return distinct rows
-- get all elements from tableA and tableB without duplicates
SELECT * FROM top_rated_films
UNION
SELECT * FROM most_popular_films;

-- union all: Use the UNION ALL to combine the result sets of two queries but retain the duplicate rows
-- get all elements from tableA and tableB with duplicates
SELECT * FROM top_rated_films
UNION ALL
SELECT * FROM most_popular_films;

SELECT * FROM top_rated_films
UNION ALL
SELECT * FROM most_popular_films
ORDER BY title;


-- intersect: retuns common elements
-- The following example uses the INTERSECT operator to retrieve the popular films that are also top-rated:
-- get common elements from tableA and tableB
SELECT *
FROM most_popular_films
INTERSECT
SELECT *
FROM top_rated_films;

SELECT *
FROM most_popular_films
INTERSECT
SELECT *
FROM top_rated_films
ORDER BY release_year;

-- except: The EXCEPT operator returns distinct rows from the first (left) query that are not in the second (right) query.
-- The following statement uses the EXCEPT operator to find the top-rated films that are not popular:
-- get elements from tableA that are not in tableB
SELECT * FROM top_rated_films
EXCEPT
SELECT * FROM most_popular_films;

SELECT * FROM top_rated_films
EXCEPT
SELECT * FROM most_popular_films
ORDER BY title;

-- Section 7. Subquery
-- PostgreSQL executes the subquery first to get the country id and uses it for the WHERE clause to retrieve the cities.
-- subquery returns single result
-- this is the subquery
select country_id from country where country = 'United States';
-- use qubquery in main query
select city from city
where country_id = (select country_id from country where country = 'United States') 
ORDER by city;

-- subquery returns multiple results
-- this is the subquery
select film_id
from film_category
inner join category USING(category_id)
where name='Action';

-- Second, use the query above as a subquery to retrieve the film title from the film table
select film_id, title from film
WHERE
  film_id IN (
    select film_id
    from film_category
    INNER JOIN category USING(category_id)
    where name = 'Action')
ORDER by film_id;

-- correlated subquery
-- It is used to perform a query that depends on the values of the current row being processed.
-- this is the subquery
SELECT AVG(length)
FROM film f
WHERE rating = f.rating;
-- use the subquery in main query
SELECT film_id, title, length, rating
FROM film f
WHERE length > (
    SELECT AVG(length)
    FROM film
    WHERE rating = f.rating
);

-- any operator
-- ANY operator compares a value with a set of values returned by a subquery
/*
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);
CREATE TABLE managers(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);
INSERT INTO employees (first_name, last_name, salary)
VALUES
('Bob', 'Williams', 45000.00),
('Charlie', 'Davis', 55000.00),
('David', 'Jones', 50000.00),
('Emma', 'Brown', 48000.00),
('Frank', 'Miller', 52000.00),
('Grace', 'Wilson', 49000.00),
('Harry', 'Taylor', 53000.00),
('Ivy', 'Moore', 47000.00),
('Jack', 'Anderson', 56000.00),
('Kate', 'Hill',  44000.00),
('Liam', 'Clark', 59000.00),
('Mia', 'Parker', 42000.00);
INSERT INTO managers(first_name, last_name, salary)
VALUES
('John', 'Doe',  60000.00),
('Jane', 'Smith', 55000.00),
('Alice', 'Johnson',  58000.00);
*/

SELECT * FROM employees;
SELECT * FROM managers;

-- The following statement uses the ANY operator to find employees who have the salary the same as manager:
-- First, execute the subquery in the ANY operator that returns the salary of managers:
select salary from managers;
-- Second, compare the salary of each row in the employees table with the values returned by the subquery and include the row that has a salary equal to the one in the set (60K, 55K, and 58K).
select * from employees
where salary = ANY (select salary from managers);

-- find manager salary ie 55k (from above query) and get records with salary > 55k
select * from employees
where salary > ANY (select salary from managers);

-- find manager salary ie 55k (from above query) and get records with salary <= 55k
select * from employees 
where salary < ANY (select salary from managers);

-- all operator
-- ALL operator allows you to compare a value with all values in a set returned by a subquery
/*
CREATE TABLE factory_employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE factory_managers(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

INSERT INTO factory_employees (first_name, last_name, salary)
VALUES
('Bob', 'Williams', 75000.00),
('Charlie', 'Davis', 55000.00),
('David', 'Jones', 50000.00),
('Emma', 'Brown', 48000.00),
('Frank', 'Miller', 52000.00),
('Grace', 'Wilson', 49000.00),
('Harry', 'Taylor', 53000.00),
('Ivy', 'Moore', 47000.00),
('Jack', 'Anderson', 56000.00),
('Kate', 'Hill',  44000.00),
('Liam', 'Clark', 59000.00),
('Mia', 'Parker', 42000.00);

INSERT INTO factory_managers(first_name, last_name, salary)
VALUES
('John', 'Doe',  60000.00),
('Jane', 'Smith', 55000.00),
('Alice', 'Johnson',  58000.00);
*/
-- The following example uses the ALL operator for employees who have salaries greater than all managers
-- select salary from factory_managers;
select * from factory_employees 
where salary > ALL (select salary from factory_managers);

-- The following example uses the ALL operator for employees who have salaries lesser than all managers
select * from factory_employees 
where salary < ALL (select salary from factory_managers);

-- exists: EXISTS operator to test for the existence of rows in a subquery.
-- The following example uses the EXISTS operator to check if the payment value is zero exists in the payment table:
-- The EXISTS operator is a boolean operator that checks the existence of rows in a subquery
select 1 from payment where amount = 0;
select exists (select 1 from payment where amount = 0);

-- The following example uses the EXISTS operator to find customers who have paid at least one rental with an amount greater than 11:
select first_name, last_name
from customer c
where exists (select 1 from payment p where p.customer_id = c.customer_id and amount > 11)
order by first_name, last_name;

-- The following example uses the NOT EXISTS operator to find customers who have not made any payment more than 11.
select first_name, last_name
from customer c
where not exists (select 1 from payment p where p.customer_id = c.customer_id and amount > 11)
order by first_name, last_name;

-- The following example returns all rows from the customers table because the subquery in the EXISTS operator returns NULL:
select first_name, last_name
from customer c
where exists (select null)
order by first_name, last_name;

-- Section 8. Common Table Expressions
-- The following example uses a common table expression (CTE) to select the title and length of films in the 'Action' category and returns all the columns of the CTE:
WITH action_films AS (
  SELECT
    f.title,
    f.length
  FROM
    film f
    INNER JOIN film_category fc USING (film_id)
    INNER JOIN category c USING(category_id)
  WHERE
    c.name = 'Action'
)
SELECT * FROM action_films;

-- The following example join a CTE with a table to find the staff and rental count for each:
WITH cte_rental AS (
  SELECT
    staff_id,
    COUNT(rental_id) rental_count
  FROM
    rental
  GROUP BY
    staff_id
)
SELECT
  s.staff_id,
  first_name,
  last_name,
  rental_count
FROM
  staff s
  INNER JOIN cte_rental USING (staff_id);
/*
In this example:
 - First, the CTE returns a result set that includes the staff id and the rental counts.
 - Then, the main query joins the staff table with the CTE using the staff_id column.
 */

-- The following example uses multiple CTEs to calculate various statistics related to films and customers:
WITH film_stats AS (
    -- CTE 1: Calculate film statistics
    SELECT
        AVG(rental_rate) AS avg_rental_rate,
        MAX(length) AS max_length,
        MIN(length) AS min_length
    FROM film
),
customer_stats AS (
    -- CTE 2: Calculate customer statistics
    SELECT
        COUNT(DISTINCT customer_id) AS total_customers,
        SUM(amount) AS total_payments
    FROM payment
)
-- Main query using the CTEs
SELECT
    ROUND((SELECT avg_rental_rate FROM film_stats), 2) AS avg_film_rental_rate,
    (SELECT max_length FROM film_stats) AS max_film_length,
    (SELECT min_length FROM film_stats) AS min_film_length,
    (SELECT total_customers FROM customer_stats) AS total_customers,
    (SELECT total_payments FROM customer_stats) AS total_payments;
/*
In this example, we create two CTEs:
 - film_stats: Calculates statistics related to films including the average rental rate, maximum length, and minimum length.
 - customer_stats: Calculates statistics related to customers including the total number of distinct customers and the overall payments made.
 - The main query retrieves specific values from each CTE to create a summary report.
 */

-- Recursive Query
/*
CREATE TABLE corporate_employees (
  employee_id SERIAL PRIMARY KEY,
  full_name VARCHAR NOT NULL,
  manager_id INT
);
INSERT INTO corporate_employees (employee_id, full_name, manager_id)
VALUES
  (1, 'Michael North', NULL),
  (2, 'Megan Berry', 1),
  (3, 'Sarah Berry', 1),
  (4, 'Zoe Black', 1),
  (5, 'Tim James', 1),
  (6, 'Bella Tucker', 2),
  (7, 'Ryan Metcalfe', 2),
  (8, 'Max Mills', 2),
  (9, 'Benjamin Glover', 2),
  (10, 'Carolyn Henderson', 3),
  (11, 'Nicola Kelly', 3),
  (12, 'Alexandra Climo', 3),
  (13, 'Dominic King', 3),
  (14, 'Leonard Gray', 4),
  (15, 'Eric Rampling', 4),
  (16, 'Piers Paige', 7),
  (17, 'Ryan Henderson', 7),
  (18, 'Frank Tucker', 8),
  (19, 'Nathan Ferguson', 8),
  (20, 'Kevin Rampling', 8);
*/
WITH RECURSIVE subordinates AS (
  SELECT
    employee_id,
    manager_id,
    full_name
  FROM
    corporate_employees
  WHERE
    employee_id = 2
  UNION
  SELECT
    e.employee_id,
    e.manager_id,
    e.full_name
  FROM
    corporate_employees e
    INNER JOIN subordinates s ON s.employee_id = e.manager_id
)
SELECT * FROM subordinates;

-- Section 9. Modifying Data (CRUD operation)
/*
CREATE TABLE links (
  id SERIAL PRIMARY KEY,
  url VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description VARCHAR (255),
  last_update DATE
);
*/
INSERT INTO links (url, name)
VALUES('https://neon.tech/postgresql','PostgreSQL Tutorial');

INSERT INTO links (url, name)
VALUES('http://www.oreilly.com','O''Reilly Media');

INSERT INTO links (url, name, last_update)
VALUES('https://www.google.com','Google','2013-06-01');

--  the following statement inserts a new row into the links table and returns the last inserted id
INSERT INTO links (url, name)
VALUES('https://www.postgresql.org','PostgreSQL')
RETURNING id;

-- insert multiple rows
/*
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(384) NOT NULL UNIQUE
);
*/
INSERT INTO contacts (first_name, last_name, email)
VALUES
    ('John', 'Doe', 'johndoe@gmail.com'),
    ('Sachin', 'tendulkar', 'srtendulkar@gmail.com'),
    ('Bob', 'Johnson', 'bjohnson@gmail.com');

INSERT INTO contacts (first_name, last_name, email)
VALUES
    ('Alice', 'Johnson', 'alice@gmail.com'),
    ('Charlie', 'Brown', 'charlie@gmail.com')
RETURNING *; -- returns all columns from newly inserted records

INSERT INTO contacts (first_name, last_name, email)
VALUES
    ('Eva', 'Williams', 'eva@gmail.com'),
    ('Michael', 'Miller', 'miller@gmail.com'),
    ('Sophie', 'Davis', 'sophie@gmail.com')
RETURNING id; -- returns id column from newly inserted records

-- update
/*
CREATE TABLE courses(
  course_id serial PRIMARY KEY,
  course_name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description VARCHAR(500),
  published_date date
);
INSERT INTO courses( course_name, price, description, published_date)
VALUES
('PostgreSQL for Developers', 299.99, 'A complete PostgreSQL for Developers', '2020-07-13'),
('PostgreSQL Admininstration', 349.99, 'A PostgreSQL Guide for DBA', NULL),
('PostgreSQL High Performance', 549.99, NULL, NULL),
('PostgreSQL Bootcamp', 777.99, 'Learn PostgreSQL via Bootcamp', '2013-07-11'),
('Mastering PostgreSQL', 999.98, 'Mastering PostgreSQL in 21 Days', '2012-06-30');
*/
SELECT * FROM courses;
UPDATE courses
SET published_date = '2020-08-01'
WHERE course_id = 3;

UPDATE courses
SET published_date = '2020-07-01'
WHERE course_id = 2
RETURNING *;

-- UPDATE courses SET price = price * 1.05;

-- uodate-join: update data in a table based on values in another table
/*
UPDATE table1
SET table1.c1 = new_value
FROM table2
WHERE table1.c2 = table2.c2;
*/

/*
CREATE TABLE product_segment (
    id SERIAL PRIMARY KEY,
    segment VARCHAR NOT NULL,
    discount NUMERIC (4, 2)
);
INSERT INTO
    product_segment (segment, discount)
VALUES
    ('Grand Luxury', 0.05),
    ('Luxury', 0.06),
    ('Mass', 0.1);

CREATE TABLE product(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    price NUMERIC(10,2),
    net_price NUMERIC(10,2),
    segment_id INT NOT NULL,
    FOREIGN KEY(segment_id) REFERENCES product_segment(id)
);
INSERT INTO
    product (name, price, segment_id)
VALUES
    ('diam', 804.89, 1),
    ('vestibulum aliquet', 228.55, 3),
    ('lacinia erat', 366.45, 2),
    ('scelerisque quam turpis', 145.33, 3),
    ('justo lacinia', 551.77, 2),
    ('ultrices mattis odio', 261.58, 3),
    ('hendrerit', 519.62, 2),
    ('in hac habitasse', 843.31, 1),
    ('orci eget orci', 254.18, 3),
    ('pellentesque', 427.78, 2),
    ('sit amet nunc', 936.29, 1),
    ('sed vestibulum', 910.34, 1),
    ('turpis eget', 208.33, 3),
    ('cursus vestibulum', 985.45, 1),
    ('orci nullam', 841.26, 1),
    ('est quam pharetra', 896.38, 1),
    ('posuere', 575.74, 2),
    ('ligula', 530.64, 2),
    ('convallis', 892.43, 1),
    ('nulla elit ac', 161.71, 3);
*/
UPDATE product
SET net_price = price - price * discount
FROM product_segment
WHERE product.segment_id = product_segment.id;

-- delete
/*CREATE TABLE todos (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT false
);
INSERT INTO todos (title, completed) VALUES
    ('Learn basic SQL syntax', true),
    ('Practice writing SELECT queries', false),
    ('Study PostgreSQL data types', true),
    ('Create and modify tables', false),
    ('Explore advanced SQL concepts', true),
    ('Understand indexes and optimization', false),
    ('Backup and restore databases', true),
    ('Implement transactions', false),
    ('Master PostgreSQL security features', true),
    ('Build a sample application with PostgreSQL', false);
*/
SELECT * FROM todos;

DELETE FROM todos WHERE id = 1;

DELETE FROM todos WHERE id = 2
RETURNING *;

DELETE FROM todos
WHERE completed = true
RETURNING *;

-- DELETE FROM todos; -- delete all records

-- delete join
-- PostgreSQL does not support the DELETE JOIN statement like MySQL. Instead, it offers the USING clause in the DELETE statement that provides similar functionality to the DELETE JOIN.
/*
DELETE FROM t1
USING t2
WHERE t1.id = t2.id
RETURNING *;
*/

/*
CREATE TABLE member(
   id SERIAL PRIMARY KEY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   phone VARCHAR(15) NOT NULL
);
CREATE TABLE denylist(
    phone VARCHAR(15) PRIMARY KEY
);
INSERT INTO member(first_name, last_name, phone)
VALUES ('John','Doe','(408)-523-9874'),
       ('Jane','Doe','(408)-511-9876'),
       ('Lily','Bush','(408)-124-9221');
INSERT INTO denylist(phone)
VALUES ('(408)-523-9874'),
       ('(408)-511-9876');
*/
SELECT * FROM member;
SELECT * FROM denylist;

DELETE FROM member
USING denylist
WHERE member.phone = denylist.phone;

-- First, the subquery returns a list of phones from the denylist table
-- Second, the DELETE statement deletes rows in the member table whose values in the phone column are in the list of phones returned by the subquery.
DELETE FROM member
WHERE phone IN (select phone from denylist);

-- upsert
/*
CREATE TABLE product_inventory(
   id INT PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   price DECIMAL(10,2) NOT NULL,
   quantity INT NOT NULL
);
INSERT INTO product_inventory(id, name, price, quantity)
VALUES
	(1, 'A', 15.99, 100),
	(2, 'B', 25.49, 50),
	(3, 'C', 19.95, 75)
RETURNING *;
*/

-- do nothing as product already exists
INSERT INTO product_inventory (id, name, price, quantity)
VALUES (1, 'A', 16.99, 120)
ON CONFLICT(id)
DO nothing;

-- insert new element
INSERT INTO inventory (id, name, price, quantity)
VALUES (4, 'D', 29.99, 20)
ON CONFLICT(id)
DO UPDATE SET
  price = EXCLUDED.price,
  quantity = EXCLUDED.quantity;

-- update existing element
INSERT INTO inventory (id, name, price, quantity)
VALUES (4, 'D', 100, 100)
ON CONFLICT(id)
DO UPDATE SET
  price = EXCLUDED.price,
  quantity = EXCLUDED.quantity;

-- merge
-- https://neon.tech/postgresql/postgresql-tutorial/postgresql-merge

-- Section 10. Transactions



-- Section 11. Import & Export Data
-- Section 12. Managing Tables
-- Section 13. PostgreSQL Constraints
-- Section 14. PostgreSQL Data Types in Depth

-- Views
-- Indexes
-- Functions