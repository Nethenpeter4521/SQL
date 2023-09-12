USE CLASSICMODELS;
-- DAY 3
## 1) Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

-- ● State should not contain null values
-- ● credit limit should be between 50000 and 100000

SELECT customerNumber, customerName, state, creditLimit
FROM customers
WHERE state IS NOT NULL AND creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;

## 2) Show the unique productline values containing the word cars at the end from products table. Expected output:
SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';

-- DAY 4

## 1) Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.
SELECT orderNumber, 
       status, 
       COALESCE(comments, '-') AS comments
FROM orders
WHERE status = 'Shipped';

##  2) Select employee number, first name, job title and job title abbreviation from employees table based on following conditions. If job title is one among the below conditions, then job title abbreviation column should show below forms. ● President then “P” ● Sales Manager / Sale Manager then “SM” ● Sales Rep then “SR” ● Containing VP word then “VP”
SELECT employeeNumber, 
       firstName, 
       jobTitle,
       CASE
           WHEN jobTitle = 'President' THEN 'P'
           WHEN jobTitle LIKE '%Manager%' THEN 'SM'
           WHEN jobTitle = 'Sales Rep' THEN 'SR'
           WHEN jobTitle LIKE '%VP%' THEN 'VP'
           ELSE jobTitle
       END AS jobTitleAbbreviation
FROM employees;

-- DAY 5
## 1) For every year, find the minimum amount value from payments table
SELECT YEAR(paymentDate) AS paymentYear, 
       MIN(amount) AS minimumAmount
FROM payments
GROUP BY paymentYear;

## 2) For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.
SELECT YEAR(orderDate) AS orderYear,
    CONCAT('Q', QUARTER(orderDate)) AS quarter,
    COUNT(DISTINCT customerNumber) AS uniqueCustomers,
    COUNT(orderNumber) AS totalOrders
FROM orders
GROUP BY orderYear, quarter
ORDER BY orderYear, quarter;

## 3) Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]
SELECT
    DATE_FORMAT(paymentDate, '%b') AS month,
    CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS formattedAmount
FROM payments
GROUP BY month
HAVING SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY SUM(amount) DESC;

-- DAY 6
## 1) Create a journey table with following fields and constraints.
-- ● Bus_ID (No null values)
-- ● Bus_Name (No null values)
-- ● Source_Station (No null values)
-- ● Destination (No null values)
-- ● Email (must not contain any duplicates)

CREATE TABLE journey (
    Bus_ID INT NOT NULL,
    Bus_Name VARCHAR(255) NOT NULL,
    Source_Station VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (Bus_ID)
);

## 2) Create vendor table with following fields and constraints.
-- ● Vendor_ID (Should not contain any duplicates and should not be null)
-- ● Name (No null values)
-- ● Email (must not contain any duplicates)
-- ● Country (If no data is available then it should be shown as “N/A”)

CREATE TABLE vendor (
    Vendor_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Country VARCHAR(255) DEFAULT 'N/A'
);

## 3) Create movies table with following fields and constraints.
-- ● Movie_ID (Should not contain any duplicates and should not be null)
-- ● Name (No null values)
-- ● Release_Year (If no data is available then it should be shown as “-”)
-- ● Cast (No null values)
-- ● Gender (Either Male/Female)
-- ● No_of_shows (Must be a positive number)

CREATE TABLE movies (
    Movie_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Release_Year INT,
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    No_of_shows INT CHECK (No_of_shows > 0)
);

## 4) Create the following tables. Use auto increment wherever applicable
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- DAY 7
## 1) Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
-- Tables: Employees, Customer
SELECT
    e.employeeNumber AS employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS SalesPerson,
    COUNT(DISTINCT c.customerNumber) AS uniqueCustomers
FROM
    Employees e
LEFT JOIN
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY
    e.employeeNumber, SalesPerson
ORDER BY
    uniqueCustomers DESC;

CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

## 2) Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products
select * from products;

SELECT
    c.customerNumber AS CustomerNumber,
    c.customerName AS CustomerName,
    p.productCode AS ProductCode,
    p.productName AS ProductName,
    SUM(od.quantityOrdered) AS Ordered_Qty,
    IFNULL(p.quantityInStock, 0) AS Total_inventory,
    IFNULL(p.quantityInStock - SUM(od.quantityOrdered), 0) AS Left_Qty
FROM
    Customers c
JOIN
    Orders o ON c.customerNumber = o.customerNumber
JOIN
    OrderDetails od ON o.orderNumber = od.orderNumber
JOIN
    Products p ON od.productCode = p.productCode
LEFT JOIN
    products s ON p.productCode = s.productCode
GROUP BY
    c.customerNumber, p.productCode
ORDER BY
    c.customerNumber;
    
## 3)Create below tables and fields. (You can add the data as per your wish)

-- ● Laptop: (Laptop_Name)

-- ● Colours: (Colour_Name)

-- Perform cross join between the two tables and find number of rows.

CREATE TABLE laptop (
laptop_name varchar(100) not null
);
CREATE TABLE colour (
colour_name varchar(100) not null
);

INSERT INTO laptop(laptop_name) VALUES ('DELL'),('HP'),('DELL'),('HP'),('DELL'),('HP');
INSERT INTO colour(colour_name) VALUES ('GREEN'),('WHITE'),('BLUE'),('WHITE'),('GREEN'),('BLUE');

select 
    l.laptop_name,
    c.colour_name
FROM
    laptop l
CROSS JOIN
     colour c;
     
## 4) Create table project with below fields.
-- ● EmployeeID
-- ● FullName
-- ● Gender
-- ● ManagerID
--  Find out the names of employees and their related managers.

CREATE TABLE project (
EmployeeID int ,
FullName varchar(100),
Gender varchar(10),
ManagerID int 
);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select * from project;
drop table project;
SELECT
    p1.FullName AS "Manager Name",
    p2.FullName AS "Emp Name"
FROM
    Project p1
JOIN
    Project p2 ON p1.EmployeeID = p2.ManagerID;
    

-- Day 8

## 1) Create table facility. Add the below fields into it.

-- ● Facility_ID

-- ● Name

-- ● State

-- ● Country
-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.
CREATE TABLE facility (
Facility_ID int not null,
Name varchar(100),
State varchar(100),
Country varchar(100)
);
ALTER TABLE facility MODIFY COLUMN Facility_ID int primary key auto_increment;

ALTER TABLE facility ADD COLUMN city varchar(100) not null after name;

describe facility;

-- DAY 9
## 1)Create table university with below fields.
-- ● ID
-- ● Name
-- Add the below data into it as it is.

CREATE TABLE university (
ID int primary key,
Name varchar(100)
);

INSERT INTO university VALUES (1, " Pune University "),
(2, " Mumbai University "),
(3, " Delhi University "),
(4, "Madras University"),
(5, "Nagpur University");

set sql_safe_updates=0;
UPDATE university SET Name = REPLACE(Name,' ','');

SELECT * FROM university;

-- DAY 10
## 1) Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.

CREATE VIEW products_status AS
SELECT
    YEAR(o.orderDate) AS Year,
    CONCAT(
        count(od.priceEach),
        ' (',
        ROUND((SUM(od.priceEach * od.quantityOrdered) / (SELECT SUM(od2.priceEach * od2.quantityOrdered) FROM OrderDetails od2)) * 100),
        '%)'
    ) AS Value
FROM
    Orders o
JOIN
    OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY
    Year
ORDER BY
  Value desc;

-- DAY 11
## 1) Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.
-- Table: Customers
-- Platinum: creditLimit > 100000
-- ● Gold: creditLimit is between 25000 to 100000
-- ● Silver: creditLimit < 25000

select * from customers;
CALL GetCustomerLevel(103,@level);

SELECT @level AS CustomerLevel;


DELIMITER //

CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT, OUT customerLevel VARCHAR(10))
BEGIN
    DECLARE credit DECIMAL(10, 2);

    SELECT creditLimit INTO credit FROM Customers WHERE customerNumber = customerNumber LIMIT 1;

    IF credit > 100000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF credit >= 25000 AND credit <= 100000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
END //

DELIMITER ;
CALL GetCustomerLevel(103,@level);
SELECT @level AS "Customer Level";

## 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)

DELIMITER //

CREATE PROCEDURE Get_country_payments(IN inputYear INT, IN inputCountry VARCHAR(255))
BEGIN
    SELECT
        YEAR(p.paymentDate) AS Year,
        c.country AS Country,
        CONCAT(FORMAT(SUM(p.amount)/1000, 0), 'K') AS 'Total Amount'
    FROM
        Payments p
    JOIN
        Customers c ON p.customerNumber = c.customerNumber
    WHERE
        YEAR(p.paymentDate) = inputYear AND c.country = inputCountry
    GROUP BY
        Year, Country;
END //

DELIMITER ;

drop procedure get_country_payments;
CALL Get_country_payments(2003, 'France');

-- DAY 12
## 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
-- Table: Orders
SHOW COLUMNS FROM Orders;
WITH YearMonthOrders AS (
  SELECT
    EXTRACT(YEAR FROM orderDate) AS order_year,
    DATE_FORMAT(orderDate, '%M') AS order_month,
    COUNT(*) AS order_count
  FROM
    Orders
  GROUP BY
    order_year, order_month
  ORDER BY
    order_year, order_month
),

YoYPercentageChange AS (
  SELECT
    a.order_year,
    a.order_month,
    a.order_count,
    b.order_count AS prev_year_order_count,
    CASE
      WHEN b.order_count IS NULL THEN 'N/A' -- Avoid division by zero
      ELSE
        CONCAT(
          ROUND(((a.order_count - b.order_count) / b.order_count) * 100),
          '%'
        )
    END AS yoy_percentage_change
  FROM
    YearMonthOrders a
  LEFT JOIN
    YearMonthOrders b
  ON
    a.order_year = b.order_year + 1
    AND a.order_month = b.order_month
)

SELECT
  order_year,
  order_month,
  order_count,
  yoy_percentage_change
FROM
  YoYPercentageChange;


## 2)	Create the table emp_udf with below fields.

CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    DOB DATE
);

INSERT INTO emp_udf (Name, DOB)
VALUES 
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");
    
DELIMITER //

CREATE FUNCTION calculate_age(date_of_birth DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);

    SET years = TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) % 12;

    IF years = 0 THEN
        SET age = CONCAT(months, ' months');
    ELSEIF months = 0 THEN
        SET age = CONCAT(years, ' years');
    ELSE
        SET age = CONCAT(years, ' years ', months, ' months');
    END IF;

    RETURN age;
END //

DELIMITER ;

SELECT Emp_ID,Name, DOB, calculate_age(DOB) AS Age FROM emp_udf;

-- Day 13

## 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
-- Table: Customers, Orders

SELECT CustomerNumber, CustomerName
FROM Customers
WHERE CustomerNumber NOT IN (SELECT CustomerNumber FROM Orders);
 
## 2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
-- Table: Customers, OrdersSELECT C.CustomerNumber, C.CustomerName, IFNULL(COUNT(O.OrderNumber), 0) AS OrderCount

SELECT C.CustomerNumber, C.CustomerName, IFNULL(COUNT(O.OrderNumber), 0) AS OrderCount
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerNumber = O.CustomerNumber
GROUP BY C.CustomerNumber, C.CustomerName
UNION
SELECT O.CustomerNumber, C.CustomerName, IFNULL(COUNT(O.OrderNumber), 0) AS OrderCount
FROM Customers AS C
RIGHT JOIN Orders AS O ON C.CustomerNumber = O.CustomerNumber
GROUP BY O.CustomerNumber, C.CustomerName;

## 3)	Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails
SELECT
    OrderNumber,
    MAX(QuantityOrdered) AS quantityOrdered
FROM
    Orderdetails AS od1
WHERE
    QuantityOrdered < (
        SELECT MAX(QuantityOrdered)
        FROM Orderdetails AS od2
        WHERE od1.OrderNumber = od2.OrderNumber
    )
GROUP BY OrderNumber;

## 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
-- Table: Orderdetails
    
    SELECT
    MAX(ProductCount) AS "MAX(Total)",
    MIN(ProductCount) AS "MIN(Total)"
FROM (
    SELECT
        OrderNumber,
        COUNT(*) AS ProductCount
    FROM
        Orderdetails
    GROUP BY
        OrderNumber
) AS Counts;

## 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

SELECT p.ProductLine,
    COUNT(*) AS Total
FROM
    Products AS p
JOIN (
    SELECT
        AVG(BuyPrice) AS AvgBuyPrice
    FROM
        Products
) AS avg_prices
ON p.BuyPrice > avg_prices.AvgBuyPrice
GROUP BY
    p.ProductLine
ORDER BY
    Total DESC;
    
-- Day 14) Create the table Emp_EH. Below are its fields.

-- Create the Emp_EH table
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255)
);

-- Create the stored procedure for inserting values with exception handling
DELIMITER //

CREATE PROCEDURE InsertEmp_EH(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occurred';
    END;

    START TRANSACTION;

    -- Insert the values into the Emp_EH table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    COMMIT;
END //

DELIMITER ;

-- DAY 15) Create the table Emp_BIT. Add below fields in it.

-- Create the Emp_BIT table
CREATE TABLE Emp_BIT (
    Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT
);

-- Insert data into the Emp_BIT table
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

-- Create a before-insert trigger
DELIMITER //
CREATE TRIGGER EnsurePositiveWorkingHours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //
DELIMITER ;
