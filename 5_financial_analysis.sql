-- TOP 3 HIGH BOOKS PUBLISHED YEAR

SELECT 
    YEAR(Published_Year) AS Year, COUNT(*) AS Total_Books
FROM
    Book_Details
GROUP BY Year
ORDER BY Total_Books DESC
LIMIT 3;

-- TOP 3 LOWEST BOOKS SOLD YEAR

SELECT 
    YEAR(Order_Date) AS Year,
    SUM(Quantity) AS Total_Quantity_Sold
FROM
    Order_Details
GROUP BY Year
ORDER BY Total_Quantity_Sold
LIMIT 3; 

-- TOTAL REVENUE GENERATED 

SELECT 
    SUM(Total_Amount) AS Revenue
FROM
    Order_Details; 

-- TOTAL COST AND TOTAL PROFIT

SELECT 
    Cost_Of_Goods, (Revenue - Cost_Of_Goods) AS Profit
FROM
    (SELECT 
        SUM(Cost_Price * Quantity) AS Cost_Of_Goods,
            SUM(Total_Amount) AS Revenue
    FROM
        Book_Details AS bd
    JOIN Order_Details AS od ON bd.Book_ID = od.Book_ID) AS Financials;

-- TOP 3 HIGH REVENUE MONTHS IN EACH YEAR

SELECT Year, Month, Revenue
FROM (SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Total_Amount) AS Revenue,
     DENSE_RANK() OVER(PARTITION BY YEAR(Order_Date) ORDER BY SUM(Total_Amount) DESC) AS Rn
FROM Order_Details
GROUP BY Year, Month) AS Month_Wise_Revenue
WHERE Rn <= 3;

-- HOW MUCH EACH FORMAT EARNS

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
 
-- RANK PUBLISHER BASED ON REVENUE EARN

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

-- HIGHEST ORDER CUSTOMER NAME

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

-- LEAST SPEND CITY

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

-- RANK COUNTRY BASED ON QUANTITY PURCHASED

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