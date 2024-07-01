create database exam_db
use exam_db

CREATE TABLE artists
(
    artist_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL
);

CREATE TABLE artworks
(
    artwork_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    artist_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

CREATE TABLE sales
(
    sale_id INT PRIMARY KEY,
    artwork_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

INSERT INTO artists
    (artist_id, name, country, birth_year)
VALUES
    (1, 'Vincent van Gogh', 'Netherlands', 1853),
    (2, 'Pablo Picasso', 'Spain', 1881),
    (3, 'Leonardo da Vinci', 'Italy', 1452),
    (4, 'Claude Monet', 'France', 1840),
    (5, 'Salvador Dalí', 'Spain', 1904);

INSERT INTO artworks
    (artwork_id, title, artist_id, genre, price)
VALUES
    (1, 'Starry Night', 1, 'Post-Impressionism', 1000000.00),
    (2, 'Guernica', 2, 'Cubism', 2000000.00),
    (3, 'Mona Lisa', 3, 'Renaissance', 3000000.00),
    (4, 'Water Lilies', 4, 'Impressionism', 500000.00),
    (5, 'The Persistence of Memory', 5, 'Surrealism', 1500000.00);

INSERT INTO sales
    (sale_id, artwork_id, sale_date, quantity, total_amount)
VALUES
    (1, 1, '2024-01-15', 1, 1000000.00),
    (2, 2, '2024-02-10', 1, 2000000.00),
    (3, 3, '2024-03-05', 1, 3000000.00),
    (4, 4, '2024-04-20', 2, 1000000.00);


select *
from artists
select *
from artworks
select *
from sales
--Section 1: 1 mark each

--1. Write a query to display the artist names in uppercase.
select upper(name)
from artists
--2. Write a query to find the top 2 highest-priced artworks 
--and the total quantity sold for each.
with cte
as
(
select price, quantity,
    rank() over ( order by price desc) as rk
from artworks as a
    join sales as s
    on a.artwork_id=s.artwork_id
)
select *
from cte
where rk<=2


--3. Write a query to find the total amount of sales for the 
--artwork 'Mona Lisa'.
select title, total_amount
from artworks as a
    join sales as s
    on a.artwork_id=s.artwork_id
where title LIKE 'Mona Lisa'

-- 4. Write a query to extract the year from the sale date of 'Guernica'.
select title, year(sale_date) as yr
from sales as s
    join artworks as a
    on a.artwork_id=s.artwork_id
where title like 'Guernica'
-- Section 2: 2 marks each

-- 5. Write a query to find the artworks that have the highest sale total for each genre.
select *
from artists
select *
from artworks
select *
from sales

select genre, price
from artworks as a
order by price desc

-- 6. Write a query to rank artists by their total sales amount 
--and display the top 3 artists.
select *
from artists
select *
from sales

with ctk
as
(
select ar.name, total_amount,
    dense_rank() over (order by total_amount desc) as rk
from artists as ar
    join artworks as a
    on a.artist_id=ar.artist_id
    join sales as s
    on a.artwork_id=s.artwork_id
)
SELECT *
from ctk
where rk<=3
-- 7. Write a query to display artists who have artworks in multiple genres.
select ar.name, genre
from artists as ar
    join artworks as a
    on a.artist_id=ar.artist_id
-- 8. Write a query to find the average price of artworks for each artist.
select name, avg(price)
from artworks as ar
    join artists as a
    on ar.artist_id=a.artist_id
group by name
-- 9. Write a query to create a non-clustered index on the `sales` table to improve query performance for queries filtering by `artwork_id`.
create NONCLUSTERED INDEX nci on sales [artwork_id]
exec sp_helpindex nci
-- 10. Write a query to find the artists who have sold more artworks than the 
--average number of artworks sold per artist.

select 
-- 11. Write a query to find the artists who have created artworks 
--in both 'Cubism' and 'Surrealism' genres.
    select ar.name, genre
    from artists as ar
        join artworks  as a
        on a.artist_id=ar.artist_id
    where genre like 'Surrealism'
union
    select ar.name, genre
    from artists as ar
        join artworks  as a
        on a.artist_id=ar.artist_id
    where genre like 'Cubism'
-- 12. Write a query to display artists whose birth year is earlier than the
-- average birth year of artists from their country.
with
    ct
    as
    (
        select avg(birth_year) as byear, country
        from artists
        group by country
    )
select *
from artists as a
where birth_year<
(select byear
from ct
where ct.country=a.country)

-- 13. Write a query to find the artworks that have been sold in 
--both January and February 2024.
select *
from artists
select *
from sales
select *
from artworks

select *
from sales
WHERE  Format(sale_date,'yyyy-MM') = '2024-01'
    or
    Format(sale_date,'yyyy-MM') = '2024-02'
-- 14. Write a query to calculate the price of 'Starry Night' plus 10% tax.
update artworks 
set price=price*0.1
where 
title like 'Starry Night' 

-- 15. Write a query to display the artists whose average artwork price is higher 
--than every artwork price in the 'Renaissance' genre.
with
    ct
    as
    (
        select a.name, avg(price) as avgprice, genre
        from artists as a
            join artworks as ar on ar.artist_id=a.artist_id
        group by a.name,genre
    )
select *
from ct
where avgprice
> all(select price
from artworks
where genre 
like 'Renaissance')

--  Section 3: 3 Marks Questions

-- 16. Write a query to find artworks that have a higher price than the
-- average price of artworks by the same artist.
with
    bk
    as
    (
        select price as sumquantity
       from artists as a
            join artworks as ar on ar.artist_id=a.artist_id
             join sales as s 
             on s.artwork_id=ar.artwork_id
       
    )

select *
from bk
where sumquantity >( select avg(total_amount)as no_of_books
from sales )
-- 17. Write a query to find the average price of artworks for
-- each artist and only include artists whose average artwork price is 
--higher than the overall average artwork price.

-- 18. Write a query to create a view that shows artists who have created
-- artworks in multiple genres.
select count(distinct genre) as ct, a.name
    from artists as a
            join artworks as ar on ar.artist_id=a.artist_id
    group by a.name
    having count(distinct genre)>1

--  Section 4: 4 Marks Questions

-- 19. Write a query to convert the artists and their artworks into JSON format.
select ar.name, title
from artists as ar
    join artworks  as a
    on a.artist_id=ar.artist_id
for json path,root('art')
-- 20. Write a query to export the artists and their artworks into XML format.
    select ar.name, title
    from artists as ar
        join artworks  as a
        on a.artist_id=ar.artist_id
    for xml path('a'),root('art')
--  Section 5: 5 Marks Questions

-- 21. Create a trigger to log changes to the `artworks` table 
--into an `artworks_log` table, capturing the `artwork_id`, `title`, and a change description.
go
create artworks_log
ADD artwork_id int ,
title varchar(40),desc VARCHAR(40);
go
create TRIGGER trg_revInsert
 on artworks 
 after INSERT
 AS
BEGIN
    insert into artworks_log
    select 'artworks', 'Insert', artwork_id,title,description
    from inserted
end
go
insert into artworks
VALUES
    (6,'totssd','good')
    select * from artworks
go
-- 22. Create a scalar function to calculate the average sales amount for artworks 
--in a given genre and write a query to use this function for 'Impressionism'.
go
alter function dbo.avgsale(@gen varchar(50))
returns decimal(10,2)
AS
begin
return (
select avg(price)
            from artworks
            where genre =@gen
            group by title
)
end
go
select * from dbo.avgsale('Impressionism')
-- 23. Create a stored procedure to add a new sale and
-- update the total sales for the artwork. 
--Ensure the quantity is positive, and use transactions to maintain data integrity.
        select *
        from artists
        select *
        from artworks
        select *
        from sales
go
create procedure sp_AddNewSale
@sale_id int,
@artwork_id int,
@sale_date date,
@quan int,
@tot decimal(10,2)
AS
begin
begin TRANSACTION
begin TRY
if @quan<=0
throw 60000,'quantity must be positive',1
if not exists(select * from artworks where artwork_id=@artwork_id)
throw 60000,'artwork is not present',2

insert into sales
(
@sale_id,
@artwork_id,
@sale_date,
@quan,
@tot
)
update sales
set
total_amount=@tot
where
artwork_id=@artwork_id
commit TRANSACTION
end TRY
begin CATCH
 ROLLBACK TRANSACTION
    print CONCAT('error number is: ',error_number());
    print CONCAT('error message is: ',error_message());
    print CONCAT('error state is:',error_state());
  End Catch
end
-- 24. Create a multi-statement table-valued function (MTVF) to return the
-- total quantity sold for each genre and use it in a query to 
--display the results.
go
alter function TotQuanty(@genr varchar(50))
returns @newtab table (genre varchar(50),quantity int)
as
BEGIN
insert into @newtab
select genre,quantity from sales as s
join artworks as a
on s.artwork_id=a.artwork_id
where genre=@genr
RETURN
end
go
select * from TotQuanty('cubism')
-- 25. Write a query to create an NTILE distribution of artists
-- based on their total sales, divided into 4 tiles.

select a.name,ar.title,s.total_amount,
    NTILE(4) OVER (order by total_amount desc) as tot
    from artists as a
    join artworks as ar
    on a.artist_id=ar.artist_id
    join sales as s
    on s.artwork_id=ar.artwork_id


-- -- Normalization (5 Marks)

-- 26. **Question:**
--     Given the denormalized table `ecommerce_data` with sample data:

-- | id  | customer_name | customer_email      | product_name | product_category | product_price | order_date | order_quantity | order_total_amount |
-- | --- | ------------- | ------------------- | ------------ | ---------------- | ------------- | ---------- | -------------- | ------------------ |
-- | 1   | Alice Johnson | alice@example.com   | Laptop       | Electronics      | 1200.00       | 2023-01-10 | 1              | 1200.00            |
-- | 2   | Bob Smith     | bob@example.com     | Smartphone   | Electronics      | 800.00        | 2023-01-15 | 2              | 1600.00            |
-- | 3   | Alice Johnson | alice@example.com   | Headphones   | Accessories      | 150.00        | 2023-01-20 | 2              | 300.00             |
-- | 4   | Charlie Brown | charlie@example.com | Desk Chair   | Furniture        | 200.00        | 2023-02-10 | 1              | 200.00             |

-- Normalize this table into 3NF (Third Normal Form). Specify all primary keys, foreign key constraints, unique constraints, not null constraints, and check constraints.
create table customers
(c_id int,
    customer_name varchar(40) not null,
customer_email varchar(100)unique not null)

create table products
(pr_id int,
    product_name varchar(50) not null unique,
product_category VARCHAR(60) not null unique,
product_price decimal(10,2) not null 
)
alter table products add constraint chk check ([product_price]>=0);

alter table orders add constraint chk1 check ([order_quantity]>=0)
alter table orders add constraint chk2 check ([order_total_amount]>=0)
create table orders
(ord_id int,
    order_date date not null,
order_quantity int not null,
order_total_amount decimal(10,2) not null 
)

create table interjunction
(id int,c_id int,pr_id int,ord_id int)







