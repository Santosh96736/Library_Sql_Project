-- RETRIEVE GENRE TYPE

SELECT DISTINCT
    Genre
FROM
    Book_Details; 

-- TOP 3 HIGH COST BOOKS

SELECT 
    Title, Sale_Price
FROM
    Book_Details
ORDER BY Sale_Price DESC
LIMIT 3; 

-- TOP 3 HIGH REVIEW BOOKS

SELECT 
    Title, Reviews
FROM
    Book_Details
ORDER BY Reviews DESC
LIMIT 3; 

-- TOP 3 HIGH REVIEW BOOK IN EACH GENRE

SELECT Title,Genre,Reviews
FROM (SELECT Title, Genre, Reviews,
	 DENSE_RANK() OVER(PARTITION BY Genre ORDER BY Genre, Reviews DESC) AS Rn
FROM Book_Details) AS Rank_Data
WHERE Rn <= 3;

-- TOP 3 LOW STOCK BOOKS

SELECT 
    Title, Stock
FROM
    Book_Details
ORDER BY Stock
LIMIT 3; 

-- TOTAL BOOKS SOLD

SELECT 
    SUM(Quantity) AS Total_Quantity_Sold
FROM
    Order_Details;