create database belajar_lomba

use belajar_lomba

select *
from customer

-- Membuat tabel customers
CREATE TABLE customers
(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Membuat tabel orders
CREATE TABLE orders
(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Menambahkan beberapa data ke dalam tabel customers
INSERT INTO customers
    (customer_id, customer_name)
VALUES
    (1, 'John Doe'),
    (2, 'Jane Smith'),
    (3, 'Bob Johnson');

-- Menambahkan beberapa data ke dalam tabel orders
INSERT INTO orders
    (order_id, customer_id, order_date, total_amount)
VALUES
    (101, 1, '2024-02-25', 150.00),
    (102, 2, '2024-02-26', 200.00),
    (103, 1, '2024-02-27', 100.00),
    (104, 3, '2024-02-28', 300.00),
    (105, NULL, '2024-02-28', 50.00);
-- Menambahkan satu pesanan dengan customer_id NULL

SELECT *
FROM customers

SELECT *
FROM orders

--1. Basic SQL Query
--1.1 SELECT Syntax
SELECT *
FROM customers
--1.2 COUNT() Syntax
SELECT COUNT(customer_id) as Jumlah_Account
from customers
--1.3 WHERE Syntax
SELECT *
FROM orders
WHERE total_amount > 100
--1.4 AND Syntax
SELECT *
FROM orders
WHERE total_amount > 100 AND total_amount < 200
--1.5 OR Syntax
SELECT *
FROM orders
where total_amount < 50 OR total_amount > 200
--1.6 Having
select customer_id, count(customer_id)as total_orders
from orders
group by customer_id
having COUNT(customer_id) > 1
--1.7 LIMIT
SELECT *
FROM orders
ORDER BY total_amount DESC OFFSET 3 ROWS FETCH FIRST 1 ROWS ONLY;
--1.8 UNION
    SELECT customer_id, customer_name, NULL AS order_date, NULL AS total_amount
    FROM customers
UNION
    SELECT customer_id, NULL AS customer_name, order_date, total_amount
    FROM orders;
--1.9 UNION ALL
    SELECT customer_id, customer_name, NULL AS order_date, NULL AS total_amount
    FROM customers
UNION ALL
    SELECT customer_id, NULL AS customer_name, order_date, total_amount
    FROM orders;
-- DISTINCT
SELECT DISTINCT customer_id, customer_name
FROM (
            SELECT customer_id, customer_name
        FROM customers
    UNION ALL
        SELECT customer_id, NULL AS customer_name
        FROM orders
) AS combined_data;

SELECT *
FROM orders
WHERE total_amount > 100
LIMIT 1;

SELECT customers.customer_id, customers.customer_name, COUNT(orders.order_id) AS total_orders
FROM customers
    LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.customer_name
HAVING COUNT(orders.order_id) > 1;

-- Menambahkan satu pelanggan tanpa pesanan
INSERT INTO customers
    (customer_id, customer_name)
VALUES
    (4, 'Alice Johnson');

-- INNER JOIN: Akan memunculkan semua baris yang memiliki pasangan yang sesuai di kedua tabel
SELECT customers.*, orders.*
FROM customers
    INNER JOIN orders ON customers.customer_id = orders.customer_id;

-- LEFT JOIN: Akan memunculkan semua baris dari tabel kiri (customers) dan baris yang memiliki pasangan yang sesuai di tabel kanan (orders)
SELECT customers.*, orders.*
FROM customers
    LEFT JOIN orders ON customers.customer_id = orders.customer_id;

-- RIGHT JOIN: Akan memunculkan semua baris dari tabel kanan (orders) dan baris yang memiliki pasangan yang sesuai di tabel kiri (customers)
SELECT customers.*, orders.*
FROM customers
    RIGHT JOIN orders ON customers.customer_id = orders.customer_id;

-- FULL OUTER JOIN: Akan memunculkan semua baris dari kedua tabel, mencocokkan baris dari kedua tabel di mana memungkinkan
SELECT customers.*, orders.*
FROM customers
    FULL OUTER JOIN orders ON customers.customer_id = orders.customer_id;


SELECT *
FROM (
    SELECT customer_id, customer_name
    FROM customers
    WHERE customer_name LIKE 'A%'
) AS derived_table;


SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
FROM orders
WHERE total_amount > 100
);


select *
from orders
where total_amount > (select avg(total_amount)
from orders)

select avg(total_amount)
from orders