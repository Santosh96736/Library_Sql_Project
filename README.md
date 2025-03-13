# Library Data Analysis Using MySql

![Library Logo](https://github.com/Santosh96736/Library_Sql_Project/blob/main/Library_logo.jpg)

## 📖 Table of Contents  
1. [Overview](#overview)  
2. [Objective](#objective)  
3. [Database Schema](#database-schema)  
4. [Data Loading](#data-loading)  
5. [SQL Queries](#sql-queries)  
6. [Business Insights](#business-insights)  
7. [Findings & Conclusion](#findings--conclusion)  


## 🏆 Overview  
📚 **Library Data Analysis** is a **data-driven project** that analyzes a library’s book sales, customer behavior, and financial performance using **MySQL**. 


## 🎯 Project Objectives  
✔ **Efficient Data Storage:** Structured **relational database** for books, customers, and orders.  
✔ **Fast Data Retrieval:** Use **optimized SQL queries**.  
✔ **Business Insights:** Identify **bestselling books, revenue trends, and top customers**.  



## 🏛️ Database Schema  

   **The database consists of three tables:**

📚 **Book_Details :** Stores Book information.
👤 **Customer_Details :** Stores Customer information.
🛒 **Order_Details :** Stores Order information.
   
## SQL Queries
```sql
CREATE DATABASE Library;
```

```sql
USE Library;
```

```sql
CREATE TABLE Book_Details (
    Book_ID VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(50),
    Author VARCHAR(25),
    Genre VARCHAR(15),
    Published_Year DATE,
    Cost_Price DECIMAL(10 , 2 ),
    Sale_Price DECIMAL(10 , 2 ),
    Stock INT,
    Rating DECIMAL(10 , 2 ),
    Reviews INT,
    Format VARCHAR(10),
    Publisher VARCHAR(20)
);
```

```sql
CREATE TABLE Customer_Details (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(30),
    Email VARCHAR(40),
    Phone VARCHAR(30),
    City VARCHAR(30),
    Country VARCHAR(55)
);
```

```sql
CREATE TABLE Order_Details(
Order_ID VARCHAR(10) PRIMARY KEY,
Customer_ID VARCHAR(10),	
Book_ID	VARCHAR(10),
Order_Date DATE,
Quantity INT,
Total_Amount DECIMAL(10,4),
FOREIGN KEY (Customer_ID) REFERENCES Customer_Details(Customer_ID),
FOREIGN KEY (Book_ID) REFERENCES Book_Details(Book_ID)
);
```

```sql
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Library Project\\Book_Details.csv"
INTO TABLE Book_Details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

```sql
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Library Project\\Customer_Details.csv"
INTO TABLE Customer_Details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

```sql
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Library Project\\Order_Details.csv"
INTO TABLE Order_Details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```


### SELECT TOP 10 ROWS FROM TABLE Book_Details 

```sql	
SELECT 
    *
FROM
    Book_Details
LIMIT 10; 
```

### SELECT TOP 10 ROWS FROM TABLE Customer_Details

```sql	
SELECT 
    *
FROM
    Customer_Details
LIMIT 10;
```

### SELECT TOP 10 ROWS FROM TABLE Order_Details 

```sql	
SELECT 
    *
FROM
    Order_Details
LIMIT 10;
```

### RETRIEVE GENRE TYPE

```sql
SELECT DISTINCT
    Genre
FROM
    Book_Details; 
```

### TOP 3 HIGH COST BOOKS

```sql
SELECT 
    Title, Sale_Price
FROM
    Book_Details
ORDER BY Sale_Price DESC
LIMIT 3; 
```

### TOP 3 HIGH REVIEW BOOK IN EACH GENRE

```sql
SELECT Title,Genre,Reviews
FROM (SELECT Title, Genre, Reviews,
	 DENSE_RANK() OVER(PARTITION BY Genre ORDER BY Genre, Reviews DESC) AS Rn
FROM Book_Details) AS Rank_Data
WHERE Rn <= 3;
```

### TOTAL CUSTOMERS

```sql
SELECT 
    COUNT(*) AS Total_Customer_Count
FROM
    Customer_Details; 
```

### TOTAL BOOKS SOLD

```sql
SELECT 
    SUM(Quantity) AS Total_Quantity_Sold
FROM
    Order_Details;
```

### TOTAL REVENUE GENERATED 

```sql
SELECT 
    SUM(Total_Amount) AS Revenue
FROM
    Order_Details; 
```

### TOTAL COST AND TOTAL PROFIT

```sql
SELECT 
    Cost_Of_Goods, (Revenue - Cost_Of_Goods) AS Profit
FROM
    (SELECT 
        SUM(Cost_Price * Quantity) AS Cost_Of_Goods,
            SUM(Total_Amount) AS Revenue
    FROM
        Book_Details AS bd
    JOIN Order_Details AS od ON bd.Book_ID = od.Book_ID) AS Financials;
```

### HOW MUCH EACH FORMAT EARNS

```sql
WITH Revenue_Data AS (SELECT 
    Book_ID, SUM(Total_Amount) AS Total_Revenue
FROM
    Order_Details
GROUP BY Book_ID) 
	
SELECT 
    Format, SUM(Total_Revenue) AS Revenue
FROM
    Revenue_Data AS rd
        JOIN
    Book_Details AS bd ON rd.Book_ID = bd.Book_ID
GROUP BY Format;
 ```

### RANKING PUBLISHER BASED ON REVENUE EARN

```sql
 WITH Revenue_Data AS (SELECT 
    Book_ID, SUM(Total_Amount) AS Total_Revenue
FROM
    Order_Details
GROUP BY Book_ID),

Publisher_Data AS (SELECT 
    Publisher, SUM(Total_Revenue) AS Revenue
FROM
    Book_Details AS bd
        JOIN
    Revenue_Data AS rd ON bd.Book_ID = rd.Book_ID
GROUP BY Publisher)

SELECT Publisher, Revenue,
	   RANK() OVER(ORDER BY Revenue DESC) AS rn
FROM Publisher_Data;
```

### HIGHEST ORDER CUSTOMER NAME

```sql
WITH Customer_Data AS (SELECT 
    Customer_ID, SUM(Quantity) AS Total_Quantity
FROM
    Order_Details
GROUP BY Customer_ID)

SELECT 
    cd.Name, (cud.Total_Quantity) AS Total_Quantity
FROM
    Customer_Data AS cud
        JOIN
    Customer_Details AS cd ON cud.Customer_ID = cd.Customer_ID
ORDER BY Total_Quantity DESC
LIMIT 1;
```

### LEAST SPENDING CITY

```sql
WITH Customer_Data AS (SELECT 
    Customer_ID, SUM(Total_Amount) AS Total_SpeNding
FROM
    Order_Details
GROUP BY Customer_ID)

SELECT 
    cd.City, SUM(cud.Total_Spending) AS Total_Spending
FROM
    Customer_Data AS cud
        JOIN
    Customer_Details AS cd ON cud.Customer_ID = cd.Customer_ID
GROUP BY cd.City
ORDER BY Total_Spending
LIMIT 1;
```

📊 Business Insights
This analysis helps answer key business questions such as:

✔ What are the best-selling books? 📖
✔ Which publisher generates the most revenue? 🏆
✔ What formats (eBook, audiobook, hardcover) earn the most? 🎧
✔ Which city or country buys the most books? 🌍
✔ Who are the highest-spending customers? 🛍️


📊 Key Findings & Insights

1. The most profitable publisher is Pearson.
2. Customers from county - Congo purchase the most books.
3. Customers from city - East Alison spend the least amount .
4. The best-earning format is Audiobook.
