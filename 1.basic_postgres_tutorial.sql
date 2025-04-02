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
-- In the pattern %10$%%, the first and last % are the wildcard characters whereas the % appears after the escape character $ is a regular character.

-- null operator
select null = null as result; -- The comparison of NULL with a value will always result in null
select address, address2 from address where address2 is null;
select address, address2 from address where address2 is not null;
/*
Notice that the address2 is empty, not NULL. This is a good example of bad practice when it comes to storing empty strings and NULL in the same column.
To fix it, you can use the UPDATE statement to change the empty strings to NULL in the address2 column, which you will learn in the UPDATE tutorial.
 */
