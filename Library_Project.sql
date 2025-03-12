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

### TOP 3 HIGH REVIEW BOOKS

```sql
SELECT 
    Title, Reviews
FROM
    Book_Details
ORDER BY Reviews DESC
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

### TOP 3 LOW STOCK BOOKS

```sql
SELECT 
    Title, Stock
FROM
    Book_Details
ORDER BY Stock
LIMIT 3; 
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

### TOP 3 HIGH BOOKS PUBLISHED YEAR

```sql
SELECT 
    YEAR(Published_Year) AS Year, COUNT(*) AS Total_Books
FROM
    Book_Details
GROUP BY Year
ORDER BY Total_Books DESC
LIMIT 3;
```

### TOP 3 LOWEST BOOKS SOLD YEAR

```sql
SELECT 
    YEAR(Order_Date) AS Year,
    SUM(Quantity) AS Total_Quantity_Sold
FROM
    Order_Details
GROUP BY Year
ORDER BY Total_Quantity_Sold
LIMIT 3; 
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

### TOP 3 HIGH REVENUE MONTHS IN EACH YEAR

```sql
SELECT Year, Month, Revenue
FROM (SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Total_Amount) AS Revenue,
     DENSE_RANK() OVER(PARTITION BY YEAR(Order_Date) ORDER BY SUM(Total_Amount) DESC) AS Rn
FROM Order_Details
GROUP BY Year, Month) AS Month_Wise_Revenue
WHERE Rn <= 3;
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

### RANK PUBLISHER BASED ON REVENUE EARN

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

### LEAST SPEND CITY

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

### RANK COUNTRY BASED ON QUANTITY PURCHASED

```sql
WITH Customer_Data AS (SELECT 
    Customer_ID, SUM(Quantity) AS Total_Quantity
FROM
    Order_Details
GROUP BY Customer_ID),

 Country_Data AS (SELECT 
    Country, SUM(Total_Quantity) AS Total_Quantity
FROM
    Customer_Data AS cud
        JOIN
    Customer_Details AS cd ON cud.Customer_ID = cd.Customer_ID
GROUP BY Country) 

SELECT Country, Total_Quantity,
      DENSE_RANK() OVER(ORDER BY Total_Quantity DESC) AS rn
FROM Country_Data;
````
