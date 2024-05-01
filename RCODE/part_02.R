library(DBI)
library(RPostgres)
library(dplyr)
library(dbplyr)


con <- dbConnect(RPostgres::Postgres(), 
                 host = "localhost",
                 port = "5432", 
                 user = "postgres", 
                 password = "8952021005",
                 dbname = "Northwind")
tbl_orders <- tbl(con, "orders")
tbl_orderdetails <- tbl(con, "orderdetails")
tbl_products <- tbl(con, "products")
tbl_customers <- tbl(con, "customers")

result <- tbl_orders %>%
  inner_join(tbl_orderdetails, by = c("orderid")) %>%
  inner_join(tbl_products, by = c("productid")) %>%
  inner_join(tbl_customers, by = c("customerid")) %>%
  group_by(orderid, customerid, customername) %>%
  summarise(totalsales = sum(quantity * price),
            avg_sales_per_customer = mean(quantity * price)) %>%
  filter(totalsales > avg_sales_per_customer) %>%
  arrange(desc(totalsales))

result %>% collect() %>% head(5)
show_query(result)
