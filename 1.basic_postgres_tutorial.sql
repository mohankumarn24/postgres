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
-- Section 7. Subquery
-- Section 9. Modifying Data
-- Section 10. Transactions
-- Section 11. Import & Export Data
-- Section 12. Managing Tables
-- Section 13. PostgreSQL Constraints
-- Section 14. PostgreSQL Data Types in Depth

-- Views
-- Indexes
-- Functions