
select *
from production.brands

select *
from production.categories

select *
from production.products

select *
from production.stocks

select *
from production.products

select *
from sales.customers

select *
from sales.order_items

select *
from sales.orders

SELECT *
FROM sales.staffs

SELECT *
FROM sales.stores

-- Data Retrieval
--mencari huruf belakang en yang depan nya hanya satu huruf
SELECT *
FROM sales.customers
WHERE first_name LIKE '_en';

--nama yang terdapat huruf ola di tengah
SELECT *
FROM sales.customers
WHERE first_name LIKE '%ola%';

--nama yang terdapat huruf en dibelakangnya
select *
from sales.customers
where first_name LIKE '%en';

SELECT product_name, list_price
FROM production.products;

--nama product yang terdapat huruf h didepan
SELECT *
FROM production.brands
WHERE brand_name LIKE 'h%';

--category yang sama dengan 6
SELECT *
FROM production.products
WHERE category_id LIKE '6';

--nomor tlpn yang dibelakangnya angka 33
select *
from sales.customers
where phone LIKE '%33';

--tahun sama dengan 2016
SELECT *
FROM production.products
WHERE model_year LIKE '2016';

--panggil first name yang state nya NY
SELECT first_name
FROM sales.customers
WHERE state='NY'

--panggik data yang memiliki staff id 2
SELECT staff_id, customer_id, order_id
FROM sales.orders
WHERE staff_id=2


-- Data Filtering and Sorting

--mencari data dimana list_price antara 999 dan 1500
select *
from sales.order_items
where list_price BETWEEN 999 AND 1500

--mencari data dengan id 10,11,12
select *
from sales.customers
where customer_id in (10,11,12)

--mencari data yang diatas tahun 2017
select *
from sales.orders
where year(order_date) > '2017'

--menghitung jumlah banyak belanja customer yang memiliki id = 1
select COUNT(customer_id) as banyak_belanja
from sales.orders
where customer_id = 1

SELECT *
FROM sales.customers
WHERE zip_code BETWEEN 10000 and 10500

--menampilkan data sales.orders yang memiliki id = 1
SELECT *
from sales.orders
where customer_id = 1


-- sorting 

--mengurutkan dari yg terkecil
select *
from sales.customers
order by first_name asc

--mengurutkan dari yang terbesar
select *
from sales.customers
order by last_name desc;

--data manipulation secara langsung 
select payment_id, customer_id, rental_id, amount as 'Old Price', amount+5.5 as 'New Price'
from payment a
order by amount+5.5 desc;


select *
from sales.orders so join sales.order_items si on so.order_id = si.order_id
where so.customer_id =259

--mencari data tertinggi 
select order_id, sum((quantity*list_price)-(quantity*list_price*discount)) as harga_total_discount
from sales.order_items
group by order_id, quantity, list_price, discount
ORDER BY max((quantity*list_price)-(quantity*list_price*discount))

--mencari harga total diskon
select order_id, sum((quantity*list_price)-(quantity*list_price*discount)) as harga_total_discount
from sales.order_items
group by order_id, quantity, list_price, discount

select order_id, sum((quantity*list_price)-(quantity*list_price*discount)) as harga_total_discount
from sales.order_items
WHERE order_id=1
group by order_id, quantity, list_price, discount;

--mengambil data 10 teratas, dengan concat tahun, bulan = 2017,12
select top 10
    *
from sales.orders
where CONCAT(YEAR(order_date),'-',MONTH(order_date)) = '2017-12'

--mencari 3 teratas, dengan menjumlah total diskon diurutkan dari yang tertinggi
select top 3
    *
from sales.order_items
order by ((quantity*list_price)-(quantity*list_price*discount)) desc

--mencari mana yang memiliki huruf belakang en, diurutkan sesuai order_date tertinggi
SELECT top 5
    *
from sales.customers so join sales.orders si on so.customer_id = si.customer_id
WHERE last_name like '%en'
ORDER by order_date DESC

SELECT *
from sales.order_items so join sales.orders si on so.order_id = si.order_id
ORDER by  customer_id DESC

select customer_id, SUM((si.quantity*si.list_price)-(si.quantity*si.list_price*si.discount)) as total_belanja
from sales.orders so join sales.order_items si on so.order_id = si.order_id
group by customer_id
order by customer_id asc

--mengambil data tertinggi yang terjual, dan mencari jumlah yg terjual tertinggi dalam satu tersaksi
select
    product_name, max(quantity) as Terjual
from sales.order_items so join production.products pp on pp.product_id = so.product_id
group by so.product_id, product_name
order by sum(quantity) desc

--mencari rata" data umur per manager
select manager_id, avg(DATEDIFF(year,tanggal_lahir, GETDATE())) as usia
from sales.staffs
WHERE manager_id = 1
GROUP by manager_id

--mencari data umur per staff
SELECT DATEDIFF(year,tanggal_lahir, GETDATE()) as usia
from sales.staffs
WHERE staff_id =1

--mencari data total penjualan pertahun
SELECT year(so.order_date) as tahun, sum(quantity) as total_penjualan
FROM sales.orders so join sales.order_items si on so.order_id = si.order_id
GROUP by YEAR(so.order_date)

--mencari jumlah banyak orders per customer
SELECT so.customer_id, COUNT(si.order_id) as jumlah_orders
FROM sales.orders so join sales.order_items si on so.order_id = si.order_id
GROUP by si.order_id, so.customer_id

select customer_id, count(si.order_id)as jumlah_pesanan
from sales.orders so join sales.order_items si on so.order_id = si.order_id
group by customer_id, si.order_id
order by jumlah_pesanan desc

SELECT *
FROM sales.orders so join sales.order_items si on so.order_id = si.order_id
WHERE CONCAT(YEAR(order_date),'-',MONTH(order_date)) = '2017-12'

--mencari jumlah penjualan terkecil perproduct
SELECT product_id, MIN(total_quantity) AS min_quantity
FROM (
    SELECT product_id, SUM(quantity) AS total_quantity
    FROM production.stocks
    GROUP BY product_id
) AS subquery
GROUP BY product_id
order by min_quantity asc;

--mencari penjualan tertinggi pada pemesanan 2016-01-03
select order_date , max((si.quantity*si.list_price)-(si.quantity*si.list_price*si.discount)) as nilai_penjualan_tertinggi
from sales.orders so join sales.order_items si on so.order_id = si.order_id
where order_date = '2016-01-03'
group by order_date

--mencari rata" berapa hari pengiriman
select customer_id, avg(DATEDIFF(day, order_date, shipped_date)) as rata2_pengiriman
from sales.orders
group by customer_id

select customer_id, count(customer_id) as jumlah_beli
from sales.orders
group by customer_id

-- inner join

select top 5
    so.item_id, si.customer_id, si.staff_id
FROM sales.order_items so LEFT JOIN sales.orders si on so.order_id = si.order_id

use BikeStores

SELECT SUM(gaji_karyawan) as total_gaji
FROM sales.staffs

SELECT si.product_id, si.product_name, MAX(discount) as diskon_tertinggi
from sales.order_items so JOIN production.products si on so.product_id = si.product_id
GROUP BY si.product_id, si.product_name, so.discount

SELECT si.product_name, si.list_price, so.category_name
FROM production.products si INNER JOIN production.categories so on si.category_id = so.category_id

SELECT si.product_name, si.list_price, so.category_name
FROM production.products si LEFT JOIN production.categories so on si.category_id = so.category_id

--window functions    
--menetukan rank, memberikan rank yang sama pada nilai yang sama
SELECT order_id, dense_RANK() OVER (ORDER BY total_harga.total_harga_diskon DESC) AS [RANK]
FROM (
    SELECT order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga_diskon
    FROM sales.order_items
    GROUP BY order_id
) AS total_harga;

--memberikan rank berbeda pada nilai yang sama
SELECT order_id, total_harga, RANK() OVER (ORDER BY total_harga DESC) AS [RANK]
FROM (
    SELECT order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    FROM sales.order_items
    GROUP BY order_id
) AS total_harga;

--mengurutkan berdasarkan partition city
SELECT total_harga.order_id, CONCAT(sc.first_name,' ', sc.last_name) as full_name, sc.city, total_harga, ROW_NUMBER() OVER(PARTITION BY sc.city ORDER BY total_harga DESC)  [ROW_NUMBER]
FROM (
    SELECT order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    FROM sales.order_items
    GROUP BY order_id
) AS total_harga
    join sales.orders so on so.order_id = total_harga.order_id
    JOIN sales.customers sc on sc.customer_id = so.customer_id
ORDER by sc.city DESC

--membagi menjadi 4 bagian nilai
SELECT total_harga.order_id, CONCAT(sc.first_name,' ', sc.last_name) as full_name, sc.city, total_harga, ntile(4) OVER(ORDER BY total_harga DESC)  [ROW_NUMBER]
FROM (
    SELECT order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    FROM sales.order_items
    GROUP BY order_id
) AS total_harga
    join sales.orders so on so.order_id = total_harga.order_id
    JOIN sales.customers sc on sc.customer_id = so.customer_id;

--Aggregate Window Functions
SELECT total_harga.order_id, CONCAT(sc.first_name,' ', sc.last_name) as full_name, sc.city, total_harga, sum(total_harga) OVER(PARTITION BY city) as grand_total
FROM (select order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    from sales.order_items
    group by order_id
    ) as total_harga
    join sales.orders so on so.order_id = total_harga.order_id
    JOIN sales.customers sc on sc.customer_id = so.customer_id

SELECT total_harga.order_id, CONCAT(sc.first_name,' ', sc.last_name) as full_name, so.order_date, sc.city, total_harga, avg(total_harga) OVER(PARTITION BY so.order_id ORDER by MONTH(so.order_date) desc) as average_order_amount
FROM (select order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    from sales.order_items
    group by order_id
    ) as total_harga
    join sales.orders so on so.order_id = total_harga.order_id
    JOIN sales.customers sc on sc.customer_id = so.customer_id

SELECT total_harga.order_id, CONCAT(sc.first_name,' ', sc.last_name) as full_name, so.order_date, sc.city, total_harga, max(total_harga) OVER(PARTITION BY city) as minimum_order_amount
FROM (select order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    from sales.order_items
    group by order_id
    ) as total_harga
    join sales.orders so on so.order_id = total_harga.order_id
    JOIN sales.customers sc on sc.customer_id = so.customer_id

SELECT total_harga.order_id, CONCAT(sc.first_name,' ', sc.last_name) as full_name, YEAR(so.order_date), sc.city, total_harga.total_harga_diskon, ROW_NUMBER() OVER(PARTITION by YEAR(so.order_date) order by total_harga.total_harga_diskon desc) as [row number],
    SUM(total_harga.total_harga_diskon) OVER(PARTITION BY YEAR(so.order_date) ORDER BY total_harga.total_harga_diskon DESC ROWS UNBOUNDED PRECEDING) AS CumulativeSUM
FROM (select order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga_diskon
    from sales.order_items
    group by order_id
    ) as total_harga
    join sales.orders so on so.order_id = total_harga.order_id
    JOIN sales.customers sc on sc.customer_id = so.customer_id
GROUP BY YEAR(so.order_date)

--
SELECT
    total_harga.order_id,
    CONCAT(sc.first_name,' ', sc.last_name) as full_name,
    YEAR(so.order_date) as order_year,
    sc.city,
    total_harga.total_harga_diskon,
    ROW_NUMBER() OVER(PARTITION by YEAR(so.order_date) ORDER BY total_harga.total_harga_diskon desc) as [row number],
    SUM(total_harga.total_harga_diskon) OVER(PARTITION BY YEAR(so.order_date) ORDER BY total_harga.total_harga_diskon DESC ROWS UNBOUNDED PRECEDING) AS CumulativeSUM
FROM (
    SELECT
        order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga_diskon
    FROM
        sales.order_items
    GROUP BY 
        order_id
) as total_harga
    JOIN
    sales.orders so on so.order_id = total_harga.order_id
    JOIN
    sales.customers sc on sc.customer_id = so.customer_id
GROUP BY 
    total_harga.order_id, 
    CONCAT(sc.first_name,' ', sc.last_name), 
    YEAR(so.order_date),
    sc.city,
    total_harga.total_harga_diskon;

--kumulatif sum
SELECT
    YEAR(so.order_date) AS tahun,
    SUM(total_harga.total_harga_diskon) AS total_hargasa,
    SUM(SUM(total_harga.total_harga_diskon)) OVER (ORDER BY YEAR(so.order_date) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS kumulatif_total_harga
FROM
    (SELECT
        order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga_diskon
    FROM
        sales.order_items
    GROUP BY 
         order_id) AS total_harga
    JOIN
    sales.orders so ON so.order_id = total_harga.order_id
GROUP BY 
    YEAR(so.order_date);


SELECT order_id, customer_id, order_date,
    LAG(order_date,1) OVER(ORDER BY order_date) prev_order_date
FROM sales.orders

SELECT *
from (
select si.product_id, so.store_id, sum(quantity) as total_penjualan
    from sales.order_items si join sales.orders so on si.order_id = so.order_id
    GROUP by si.product_id, so.store_id) as total_penjualan


--mencari total penjualan perstore
select st.store_name , so.store_id, sum(quantity) as total_penjualan
from sales.order_items si join sales.orders so on si.order_id = so.order_id JOIN sales.stores st on st.store_id = so.store_id
GROUP by  so.store_id, st.store_name

SELECT*
FROM sales.orders
ORDER BY order_id DESC

SELECT *
FROM sales.order_items
ORDER BY order_id DESC

use BikeStores

--mencari total rata" harga yang lebih dari rata" harga
SELECT order_id as ID, total_harga as Harga
FROM (select order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    from sales.order_items
    group by order_id
    ) as total_harga
where total_harga > 
    (SELECT avg(asu.total_harga) as rata_rata
FROM (select order_id,
        SUM((quantity * list_price) - (quantity * list_price * discount)) AS total_harga
    from sales.order_items
    group by order_id) asu)
order by total_harga asc



















