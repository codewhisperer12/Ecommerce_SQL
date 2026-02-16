CREATE TABLE ecommerce_data (
    User_ID VARCHAR(20),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Discount INT,
    Final_Price DECIMAL(10,2),
    Payment_Method VARCHAR(50),
    Purchase_Date VARCHAR(20)
);

Select * from ecommerce_data;

--a) SELECT, WHERE, ORDER BY, GROUP BY--
SELECT User_ID,
       Category,
       Final_Price
FROM ecommerce_data
WHERE Category = 'Sports'
ORDER BY Final_Price DESC;

--Revenue by category--
SELECT Category,
       COUNT(*) AS total_orders,
       SUM (Final_Price) AS total_revenue
FROM ecommerce_data
GROUP BY Category
ORDER BY total_revenue DESC;

--b) JOINS (INNER, LEFT, RIGHT)--
--Creating Users table--
CREATE TABLE users (
    User_ID VARCHAR(20) PRIMARY KEY,
    user_name VARCHAR(100)
);

SELECT e.User_ID,
       u.user_name,
       e.Category,
       e.Final_Price
FROM ecommerce_data e
INNER JOIN users u
ON e.User_ID = u.User_ID;

SELECT e.User_ID,
       u.user_name,
       e.Category
FROM ecommerce_data e
LEFT JOIN users u
ON e.User_ID = u.User_ID;

SELECT e.User_ID,
       u.user_name
FROM ecommerce_data e
RIGHT JOIN users u
ON e.User_ID = u.User_ID;

--c) Subqueries--
--Orders above average value--
SELECT *
FROM ecommerce_data
WHERE Final_Price>
      (SELECT AVG(Final_Price)
       FROM ecommerce_data);

--High-value customers--
SELECT User_ID,
       SUM(Final_Price) AS total_spent
FROM ecommerce_data
GROUP BY User_ID
HAVING SUM(Final_Price) >
       (SELECT AVG(user_total)
        FROM (
            SELECT SUM(Final_Price) AS user_total
            FROM ecommerce_data
            GROUP BY User_ID
        ) AS t);

--d) Aggregate functions (SUM, AVG)--
--Average discount per category--
SELECT Category,
       AVG(Discount) AS avg_discount
FROM ecommerce_data
GROUP BY Category;

--Payment method performance--
SELECT Payment_Method,
       SUM(Final_Price) AS total_revenue,
       AVG(Final_Price) AS avg_order_value
FROM ecommerce_data
GROUP BY Payment_Method;

--e) Create VIEW for analysis--
--Create analytical view--
CREATE VIEW category_sales_summary AS
SELECT Category,
       COUNT(*) AS total_orders,
       SUM(Final_Price) AS total_revenue,
       AVG(Final_Price) AS avg_order_value
FROM ecommerce_data
GROUP BY Category;

SELECT *
FROM category_sales_summary
ORDER BY total_revenue DESC;

--f) Optimize queries with indexes--
--Single-column indexes--
CREATE INDEX idx_category
ON ecommerce_data(Category);

CREATE INDEX idx_payment
ON ecommerce_data(Payment_Method);

--Composite index--
CREATE INDEX idx_user_date
ON ecommerce_data(User_ID, Purchase_Date);

--Monthly revenue analysis--
SELECT TO_CHAR(
           TO_DATE(Purchase_Date, 'DD-MM-YYYY'),
           'YYYY-MM'
       ) AS month,
       SUM(Final_Price) AS monthly_revenue
FROM ecommerce_data
GROUP BY month
ORDER BY month;



