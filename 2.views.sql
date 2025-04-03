-- views

-- Basic CREATE VIEW statement example
CREATE VIEW contact AS
SELECT
  first_name,
  last_name,
  email
FROM
  customer;

SELECT * FROM contact;

-- Using the CREATE VIEW statement to create a view based on a complex query
CREATE VIEW customer_info AS
SELECT
  first_name,
  last_name,
  email,
  phone,
  city,
  postal_code,
  country
FROM
  customer
  INNER JOIN address USING (address_id)
  INNER JOIN city USING (city_id)
  INNER JOIN country USING (country_id);

SELECT * FROM customer_info;

-- Creating a view based on another view
CREATE VIEW customer_usa
AS
SELECT
  *
FROM
  customer_info
WHERE
  country = 'United States';

SELECT * FROM customer_usa;

-- Replacing a view
CREATE OR REPLACE VIEW contact AS
SELECT
  first_name,
  last_name,
  email,
  phone
FROM
  customer
INNER JOIN address USING (address_id);

-- drop view
CREATE VIEW film_info AS
SELECT
  film_id,
  title,
  release_year,
  length,
  name category
FROM
  film
  INNER JOIN film_category USING (film_id)
  INNER JOIN category USING(category_id);

CREATE VIEW horror_film AS
SELECT
  film_id,
  title,
  release_year,
  length
FROM
  film_info
WHERE
  category = 'Horror';

CREATE VIEW comedy_film AS
SELECT
  film_id,
  title,
  release_year,
  length
FROM
  film_info
WHERE
  category = 'Comedy';

CREATE VIEW film_category_stat AS
SELECT
  name,
  COUNT(film_id)
FROM
  category
  INNER JOIN film_category USING (category_id)
  INNER JOIN film USING (film_id)
GROUP BY
  name;

CREATE VIEW film_length_stat AS
SELECT
  name,
  SUM(length) film_length
FROM
  category
  INNER JOIN film_category USING (category_id)
  INNER JOIN film USING (film_id)
GROUP BY
  name;

DROP VIEW comedy_film;
DROP VIEW film_info; -- error
DROP VIEW film_info CASCADE;

-- Using the DROP VIEW statement to drop multiple views
DROP VIEW film_length_stat, film_category_stat;



-- updatable views
CREATE TABLE cities (
    id SERIAL PRIMARY KEY ,
    name VARCHAR(255),
    population INT,
    country VARCHAR(50)
);

INSERT INTO cities (name, population, country)
VALUES
    ('New York', 8419600, 'US'),
    ('Los Angeles', 3999759, 'US'),
    ('Chicago', 2716000, 'US'),
    ('Houston', 2323000, 'US'),
    ('London', 8982000, 'UK'),
    ('Manchester', 547627, 'UK'),
    ('Birmingham', 1141816, 'UK'),
    ('Glasgow', 633120, 'UK'),
    ('San Francisco', 884363, 'US'),
    ('Seattle', 744955, 'US'),
    ('Liverpool', 498042, 'UK'),
    ('Leeds', 789194, 'UK'),
    ('Austin', 978908, 'US'),
    ('Boston', 694583, 'US'),
    ('Manchester', 547627, 'UK'),
    ('Sheffield', 584853, 'UK'),
    ('Philadelphia', 1584138, 'US'),
    ('Phoenix', 1680992, 'US'),
    ('Bristol', 463377, 'UK'),
    ('Detroit', 673104, 'US');

SELECT * FROM cities;

-- Creating an updatable view
CREATE VIEW city_us
AS
SELECT
  *
FROM
  cities
WHERE
  country = 'US';
-- Second, insert a new row into the cities table via the city_us view:
INSERT INTO city_us(name, population, country)
VALUES ('San Jose', 983459, 'US');
-- Third, retrieve data from cities table:
SELECT * FROM cities
WHERE name = 'San Jose';
-- Fourth, update the data in the cities table via the city_us view:
UPDATE city_us
SET population = 1000000
WHERE name = 'New York';
-- Fifth, verify the update:
SELECT * FROM cities
WHERE name = 'New York';
-- Sixth, delete a row from the cities table via the city_us view:
DELETE FROM city_us
WHERE id = 21;
-- Finally, verify the delete:
SELECT * FROM cities
WHERE id = 21;

-- add entry to table and verify if its present in views
INSERT INTO cities (name, population, country) values ('BLR', 200000, 'IN');
SELECT * FROM city_us WHERE id = 21; -- no result. why?


-- WITH CHECK OPTION
CREATE TABLE employees4 (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT,
    employee_type VARCHAR(20)
       CHECK (employee_type IN ('FTE', 'Contractor'))
);

INSERT INTO employees4 (first_name, last_name, department_id, employee_type)
VALUES
    ('John', 'Doe', 1, 'FTE'),
    ('Jane', 'Smith', 2, 'FTE'),
    ('Bob', 'Johnson', 1, 'Contractor'),
    ('Alice', 'Williams', 3, 'FTE'),
    ('Charlie', 'Brown', 2, 'Contractor'),
    ('Eva', 'Jones', 1, 'FTE'),
    ('Frank', 'Miller', 3, 'FTE'),
    ('Grace', 'Davis', 2, 'Contractor'),
    ('Henry', 'Clark', 1, 'FTE'),
    ('Ivy', 'Moore', 3, 'Contractor');

-- Basic PostgreSQL WITH CHECK OPTION example
CREATE OR REPLACE VIEW fte AS
SELECT
  id,
  first_name,
  last_name,
  department_id,
  employee_type
FROM
  employees4
WHERE
  employee_type = 'FTE';

SELECT * FROM fte;

--  insert a new row into the employees table via the fte view
INSERT INTO fte(first_name, last_name, department_id, employee_type)
VALUES ('John', 'Smith', 1, 'Contractor');

-- replace the fte view and add the WITH CHECK OPTION
CREATE OR REPLACE VIEW fte AS
SELECT
  id,
  first_name,
  last_name,
  department_id,
  employee_type
FROM
  employees4
WHERE
  employee_type = 'FTE'
WITH CHECK OPTION;

-- the following INSERT statement will fail with an error
INSERT INTO fte(first_name, last_name, department_id, employee_type)
VALUES ('John', 'Snow', 1, 'Contractor');

-- change the last name of the employee id 2 to 'Doe'
UPDATE fte
SET last_name = 'Doe'
WHERE id = 2;

-- Using WITH LOCAL CHECK OPTION example
CREATE OR REPLACE VIEW fte AS
SELECT
  id,
  first_name,
  last_name,
  department_id,
  employee_type
FROM
  employees4
WHERE
  employee_type = 'FTE';

-- create a new view fte_1 based on the fte view that returns the employees of department 1, with the WITH LOCAL CHECK OPTION
CREATE OR REPLACE VIEW fte_1
AS
SELECT
  id,
  first_name,
  last_name,
  department_id,
  employee_type
FROM
  fte
WHERE
  department_id = 1
WITH LOCAL CHECK OPTION;

SELECT * FROM fte_1;

--  insert a new row into the employees table via the fte_1 view
INSERT INTO fte_1(first_name, last_name, department_id, employee_type)
VALUES ('Miller', 'Jackson', 1, 'Contractor');

SELECT
  *
FROM
  employees4
WHERE
  first_name = 'Miller'
  and last_name = 'Jackson';

--  Using WITH CASCADED CHECK OPTION example
CREATE OR REPLACE VIEW fte_1
AS
SELECT
  id,
  first_name,
  last_name,
  department_id,
  employee_type
FROM
  fte
WHERE
  department_id = 1
WITH CASCADED CHECK OPTION;

INSERT INTO fte_1(first_name, last_name, department_id, employee_type)
VALUES ('Peter', 'Taylor', 1, 'Contractor');



-- ALTER VIEW
CREATE VIEW film_type
AS
SELECT title, rating
FROM film;

ALTER VIEW film_type RENAME TO film_rating;

ALTER VIEW film_rating
SET (check_option = local);

-- Changing the view column
ALTER VIEW film_rating
RENAME title TO film_title;

-- Setting the new schema
CREATE SCHEMA web;
ALTER VIEW film_rating
SET SCHEMA web;



-- materialized views
CREATE MATERIALIZED VIEW rental_by_category
AS
 SELECT c.name AS category,
    sum(p.amount) AS total_sales
   FROM (((((payment p
     JOIN rental r ON ((p.rental_id = r.rental_id)))
     JOIN inventory i ON ((r.inventory_id = i.inventory_id)))
     JOIN film f ON ((i.film_id = f.film_id)))
     JOIN film_category fc ON ((f.film_id = fc.film_id)))
     JOIN category c ON ((fc.category_id = c.category_id)))
  GROUP BY c.name
  ORDER BY sum(p.amount) DESC
WITH NO DATA;

SELECT * FROM rental_by_category; -- error

REFRESH MATERIALIZED VIEW rental_by_category;

SELECT * FROM rental_by_category;

-- to refresh it with CONCURRENTLY option, you need to create a UNIQUE index for the view first
CREATE UNIQUE INDEX rental_category
ON rental_by_category (category);

-- refresh data concurrently for the rental_by_category view
REFRESH MATERIALIZED VIEW CONCURRENTLY rental_by_category;

-- recursive view
-- https://neon.tech/postgresql/postgresql-views/postgresql-recursive-view

-- list view
-- https://neon.tech/postgresql/postgresql-views/postgresql-list-views