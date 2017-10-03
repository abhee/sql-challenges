CREATE SEQUENCE Categories_seq;

CREATE TABLE Categories(
CategoryID INT NOT NULL DEFAULT NEXTVAL ('Categories_seq'),
CategoryName VARCHAR(15) UNIQUE NOT NULL,
Description TEXT,
PRIMARY KEY (CategoryID));

CREATE TABLE Customers(
CustomerID CHAR(5) NOT NULL,
CompanyName VARCHAR(40) NOT NULL,
ContactName VARCHAR(30),
ContactTitle VARCHAR(30),
Address VARCHAR(60),
City VARCHAR(15),
Region VARCHAR(15),
PostalCode VARCHAR(10),
Country VARCHAR(15),
Phone VARCHAR(24),
Fax VARCHAR(24),
PRIMARY KEY (CustomerID)
);

CREATE INDEX City ON Customers (City);
CREATE INDEX CompanyName ON Customers (CompanyName);
CREATE INDEX PostalCode ON Customers (PostalCode);
CREATE INDEX Region ON Customers (Region);

CREATE SEQUENCE Employees_seq;

CREATE TABLE Employees(
EmployeeID INT NOT NULL DEFAULT NEXTVAL ('Employees_seq'),
LastName VARCHAR(20) NOT NULL,
FirstName VARCHAR(10) NOT NULL,
Title VARCHAR(30),
TitleOfCourtesy VARCHAR(25),
BirthDate TIMESTAMP(0),
HireDate TIMESTAMP(0),
Address VARCHAR(60),
City VARCHAR(15),
Region VARCHAR(15),
PostalCode VARCHAR(10),
Country VARCHAR(15),
HomePhone VARCHAR(24),
Extension VARCHAR(4),
Photo VARCHAR(255),
Notes TEXT,
ReportsTo INT,
PhotoPath VARCHAR(255),
PRIMARY KEY (EmployeeID)
);

CREATE INDEX LastName ON Employees (LastName);

CREATE SEQUENCE Shippers_seq;

CREATE TABLE Shippers(
ShipperID INT NOT NULL DEFAULT NEXTVAL ('Shippers_seq'),
CompanyName VARCHAR(40) NOT NULL,
Phone VARCHAR(24),
PRIMARY KEY (ShipperID));

CREATE SEQUENCE Orders_seq;

CREATE TABLE Orders(
OrderID INT NOT NULL DEFAULT NEXTVAL ('Orders_seq'),
CustomerID VARCHAR(5),
EmployeeID INT NOT NULL,
OrderDate TIMESTAMP(0),
RequiredDate TIMESTAMP(0),
ShippedDate TIMESTAMP(0),
ShipVia INT NOT NULL,
Freight DOUBLE PRECISION DEFAULT 0,
ShipName VARCHAR(40),
ShipAddress VARCHAR(60),
ShipCity VARCHAR(15),
ShipRegion VARCHAR(15),
ShipPostalCode VARCHAR(10),
ShipCountry VARCHAR(15),
FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
FOREIGN KEY (ShipVia) REFERENCES Shippers (ShipperID),
PRIMARY KEY (OrderID)
);

CREATE INDEX OrderDate ON Orders (OrderDate);
CREATE INDEX ShippedDate ON Orders (ShippedDate);
CREATE INDEX ShipPostalCode ON Orders (ShipPostalCode);

CREATE SEQUENCE Suppliers_seq;

CREATE TABLE Suppliers(
SupplierID INT NOT NULL DEFAULT NEXTVAL ('Suppliers_seq'),
CompanyName VARCHAR(50) NOT NULL,
ContactName VARCHAR(50),
ContactTitle VARCHAR(50),
Address VARCHAR(60),
City VARCHAR(15),
Region VARCHAR(15),
PostalCode VARCHAR(10),
Country VARCHAR(15),
Phone VARCHAR(24),
Fax VARCHAR(24),
HomePage VARCHAR(100),
PRIMARY KEY (SupplierID));

CREATE SEQUENCE Products_seq;

CREATE TABLE Products(
ProductID INT NOT NULL DEFAULT NEXTVAL ('Products_seq'),
ProductName VARCHAR(40) NOT NULL,
SupplierID INT NOT NULL,
CategoryID INT NOT NULL,
QuantityPerUnit VARCHAR(20),
UnitPrice DOUBLE PRECISION DEFAULT 0,
UnitsInStock SMALLINT DEFAULT 0,
UnitsOnOrder SMALLINT DEFAULT 0,
ReorderLevel SMALLINT DEFAULT 0,
Discontinued SMALLINT DEFAULT 0 NOT NULL,
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID),
FOREIGN KEY (SupplierID) REFERENCES Suppliers (SupplierID),
PRIMARY KEY (ProductID)
);

CREATE INDEX ProductName ON Products (ProductName);

CREATE TABLE OrderDetails(
OrderID INT NOT NULL,
ProductID INT NOT NULL,
UnitPrice DOUBLE PRECISION DEFAULT 0 NOT NULL,
Quantity SMALLINT DEFAULT 1 NOT NULL,
Discount DOUBLE PRECISION DEFAULT 0 NOT NULL,
FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
PRIMARY KEY (OrderID,ProductID)
);

CREATE TABLE CustomerGroupThresholds(
CustomerGroupName VARCHAR(20) DEFAULT NULL,
RangeBottom DECIMAL(16,5) DEFAULT NULL,
RangeTop DECIMAL(20,5) DEFAULT NULL
);
