-- CREATE LIBRARY DATABASE

CREATE DATABASE Library;

USE Library;

-- CREATE TABLE BOOK DETAILS

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

-- CREATE TABLE CUSTOMER DETAILS

CREATE TABLE Customer_Details (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(30),
    Email VARCHAR(40),
    Phone VARCHAR(30),
    City VARCHAR(30),
    Country VARCHAR(55)
);

-- CREATE TABLE ORDER DETAILS

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