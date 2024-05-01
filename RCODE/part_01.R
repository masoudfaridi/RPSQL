library(DBI)
library(RPostgres)
library(dplyr)
library(dbplyr)
#setwd("C:/Masoud/SQL/")
con <- dbConnect(RPostgres::Postgres(), 
                 host = "localhost",port="5432", 
                 user = "postgres", dbname ="Northwind",
                 password = "8952021005")
#tables<-dbListTables(con)
#dbDisconnect(con)
rental_tbl <- tbl(con, "rental")
customer_tbl <- tbl(con, "customer")

#################################################
#################################################
#01
# SELECT DISTINCT Country FROM Customers LIMIT 5;
tbl(con,"customers") %>%
  distinct(country) %>% head(5) 

tbl(con,"customers") %>%
  distinct(country) %>% show_query()


#################################################
#################################################
#011
# SELECT customername, contactname FROM customers LIMIT 5;
tbl(con,"customers") %>%
  select(customerid, customername) %>% head(5)

# SELECT customername, contactname, address, city, postalcode, country
# FROM customers LIMIT 5;
tbl(con,"customers") %>%
  select(-customerid)
tbl(con,"customers") %>%
  select(-customerid) %>% show_query()

#################################################
#################################################
#02
#SELECT DISTINCT country, city FROM customers LIMIT 5;
tbl(con,"customers") %>%
  distinct(country,city) %>% head(5) 
tbl(con,"customers") %>%
  distinct(country,city) %>% show_query()
#################################################
#################################################
#03
# SELECT customername FROM Customers WHERE Country='Mexico';
tbl(con,"customers") %>%
  filter(country=="Mexico") %>%  select(customername)  

tbl(con,"customers") %>%
  filter(country=="Mexico") %>%  select(customername) %>% show_query()
#################################################
#################################################
#04
# SELECT * FROM Customers WHERE (Country = 'Germany') AND (city = 'Berlin');
tbl(con,"customers") %>%
  select(country,city, address) %>%
  filter(country=="Germany",city=="Berlin") 

tbl(con,"customers") %>%
  select(country,city, address) %>%
  filter(country=="Germany",city=="Berlin")  %>% show_query()
#################################################
#################################################
#05
tbl(con,"products") %>%
  select(productname,price) %>%
  filter(price> 80)  

tbl(con,"products") %>%
  select(productname,price) %>%
  filter(price> 80)  %>% show_query()
#################################################
#################################################
#06
tbl(con,"products") %>%
  select(productname,price) %>%
  filter(price> 3*mean(price))

tbl(con,"products") %>%
  select(productname,price) %>%
  filter(price> 3*mean(price)) %>% show_query()
# SELECT productname, price
# FROM products 
# WHERE price > 3 * (SELECT AVG(price) FROM products)


#################################################
#################################################
#07
# SELECT COUNT(*) AS "count_1" FROM Products;
tbl(con,"products") %>% count(name="count_1")
tbl(con,"products") %>% count(name="count_1") %>% show_query()
#################################################
#################################################
#08
# SELECT COUNT(ProductID) FROM Products
# WHERE Price > 20;
tbl(con,"products") %>%filter(price > 20) %>% count()

#################################################
#################################################
#09
#SELECT COUNT(*) FROM products WHERE price > (SELECT AVG(price) FROM products);
tbl(con,"products") %>%filter(price > mean(price)) %>% count()



#################################################
#################################################
#10
# SELECT ProductID, ProductName, CategoryName
# FROM Products
# INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID LIMIT 5;
tbl(con, "products") %>% 
  inner_join(tbl(con, "categories"), by = c("categoryid" = "categoryid")) %>% 
  select(productid, productname, categoryname) %>% head(5)

#################################################
#################################################
#11



#################################################
#################################################
#12


#################################################
#################################################
#13
# SELECT oo.customerid, AVG(od.quantity * p.price) as avgsales
# FROM orders as oo
# INNER JOIN orderdetails as od ON oo.orderid = od.orderid
# INNER JOIN products as p ON od.productid = p.productid
# GROUP BY oo.customerid


tbl(con,"orders") %>% 
  inner_join(tbl(con, "orderdetails"), by = c("orderid" = "orderid")) %>% 
  inner_join(tbl(con, "products"), by = c("productid" = "productid")) %>%
  group_by(customerid) %>%
  summarise(avgsales=mean(quantity * price)) %>%
  select(customerid,avgsales) %>% head(5) 


#################################################
#################################################
#12



#################################################
#################################################
#



#################################################
# SELECT first_name FROM customer LIMIT 3
tbl(con, "customer") %>%
  select("first_name") %>%
  head(3) %>%
  collect()
#################################################
#################################################
# SELECT
# first_name,
# last_name,
# email
# FROM
# customer
# LIMIT 3;

tbl(con, "customer") %>%
  select("first_name","last_name","email") %>%
  head(3) %>%
  collect()
#################################################   
#################################################
# SELECT * FROM customer LIMIT 3;

tbl(con, "customer") %>%
  head(3) %>%
  collect()
#################################################
#################################################



# SELECT
# "customer_id",
# "store_id",
# "last_name",
# "email",
# "address_id",
# "activebool",
# "create_date",
# "last_update",
# "active"
# FROM "customer"
# LIMIT 3

tbl(con, "customer") %>%
  select(-first_name) %>%
  head(3) %>%
  collect()


tbl(con, "customer") %>%
  select(-first_name) %>%
  head(3) %>% show_query()

#################################################
#################################################

# SELECT 
# first_name || ' ' || last_name AS full_name,
# email
# FROM 
# customer;
# or
# SELECT "email", CONCAT_WS(' ', "first_name", "last_name") AS "full_name"
# FROM "customer"
# LIMIT 3

tbl(con,"customer") %>% select(first_name,last_name,email) %>%
  mutate(full_name=paste(first_name,last_name)) %>% 
  select(-c(first_name,last_name)) %>%
  head(3) %>%
  collect()


#################################################
#################################################

result <- rental_tbl %>%
  left_join(customer_tbl, by = c("customer_id" = "customer_id")) %>%
  select(rental_id, first_name, last_name) %>%
  head(4) %>%
  collect()

# SELECT r.rental_id, c.first_name, c.last_name
# FROM rental r
# LEFT JOIN customer c ON r.customer_id = c.customer_id
# LIMIT 4

#################################################
#################################################





#######################################
film_tbl <- tbl(con, "film")
actor_tbl <- tbl(con, "actor")
film_actor_tbl <- tbl(con, "film_actor")
film_category_tbl <- tbl(con, "film_category")
category_tbl <- tbl(con, "category")

result <- film_tbl %>%
  left_join(film_actor_tbl, by = c("film_id" = "film_id")) %>%
  left_join(actor_tbl, by = c("actor_id" = "actor_id")) %>%
  left_join(film_category_tbl, by = c("film_id" = "film_id")) %>%
  left_join(category_tbl, by = c("category_id" = "category_id")) %>%
  filter(category.name == "Action") %>%
  select(film_id, title, first_name, last_name, category_name) %>%
  arrange(film_id) %>%
  head(10) %>%
  collect()


# SELECT film.film_id, film.title, actor.first_name, actor.last_name, category.name
# FROM film
# LEFT JOIN film_actor ON film.film_id = film_actor.film_id
# LEFT JOIN actor ON film_actor.actor_id = actor.actor_id
# LEFT JOIN film_category ON film.film_id = film_category.film_id
# LEFT JOIN category ON film_category.category_id = category.category_id
# WHERE category.name = 'Action'
# ORDER BY film.film_id
# LIMIT 10


#############################################


# SELECT film.film_id, film.title, actor.first_name, actor.last_name
# FROM film
# LEFT JOIN film_actor ON film.film_id = film_actor.film_id
# LEFT JOIN actor ON film_actor.actor_id = actor.actor_id
# WHERE actor.last_name = 'Neeson' AND film.release_year > 2000
# ORDER BY film.film_id
# LIMIT 10



film_tbl <- tbl(con, "film")
actor_tbl <- tbl(con, "actor")
film_actor_tbl <- tbl(con, "film_actor")

result <- film_tbl %>%
  left_join(film_actor_tbl, by = c("film_id" = "film_id")) %>%
  left_join(actor_tbl, by = c("actor_id" = "actor_id")) %>%
  filter(last_name == "Neeson", release_year > 2000) %>%
  select(film_id, title, first_name, last_name) %>%
  arrange(film_id) %>%
  head(10) %>%
  collect()
#################################################
#################################################


#################################################
#################################################



#################################################
#################################################