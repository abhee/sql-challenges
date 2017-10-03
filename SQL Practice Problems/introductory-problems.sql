-- P1: Which shippers do we have?
Select * From Shippers;

-- P2: Certain fields from Categories
Select CategoryName, Description From Categories;


-- P3: Sales Representatives
Select FirstName, LastName, HireDate
From Employees
Where Title='Sales Representative';


-- P4: Sales Representatives in the United States
Select FirstName, LastName, HireDate
From Employees
Where Title='Sales Representative'
And Country='USA';


-- P5: Orders placed by specific EmployeeID
Select * 
From Orders
Where EmployeeId=5;


-- P6: Suppliers and ContactTitles
Select SupplierID, ContactName, ContactTitle
From Suppliers
Where ContactTitle!='Marketing Manager';


-- P7: Products with “Queso” in ProductName
Select ProductId, ProductName
From Products
Where ProductName like 'Queso%';


-- P8: Orders shipping to France or Belgium
Select OrderId, CustomerId, ShipCountry
From Orders
Where ShipCountry='France' OR ShipCountry='Belgium';


-- P9: Orders shipping to any country in Latin America
Select OrderId, CustomerId, ShipCountry
From Orders
Where ShipCountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela');


-- P10: Employees, in order of age
Select FirstName, LastName, Title, BirthDate
From Employees
Order By Birthdate;


-- P11: Showing only the Date with a DateTime field
Select FirstName, LastName, Title, BirthDate::timestamp::date
From Employees;

Select FirstName, LastName, Title, Date(BirthDate) as BirthDate
From Employees;


-- P12: Employees full name
Select FirstName || ' ' || LastName
From Employees;


-- P13: OrderDetails amount per line item
Select OrderID, ProductID, UnitPrice, Quantity, Quantity*UnitPrice as Total_Price
From OrderDetails;


-- P14: How many customers?
Select Count(*) From Customers;


-- P15: When was the first order?
Select Min(OrderDate)::timestamp::date as Order_Date From Orders;


-- P16: Countries where there are customers
Select Distinct Country
From Customers
Order By Country;


-- P17: Contact titles for customers
Select ContactTitle, Count(*) as TotalContactTitle
From Customers
Group By ContactTitle;


-- P18: Products with their associated supplier names
Select ProductId, ProductName, CompanyName
From Products P
JOIN Suppliers S
ON P.SupplierId=S.SupplierId
Order By ProductId;


-- P19: Orders and the Shipper that was used
Select OrderId, Date(OrderDate) as OrderDate, CompanyName
From Orders O
JOIN Shippers S
ON O.ShipVia=S.ShipperId
Order By OrderId;