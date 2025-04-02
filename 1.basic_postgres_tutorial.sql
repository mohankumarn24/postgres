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
select film_id, title, rental_rate from film order by rental_rate desc limit 10; -- bottom N rows