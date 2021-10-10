-- P20: Categories, and the total products in each category
Select CategoryName, Count(C.CategoryId) as TotalProducts
From Products P,
     Categories C
Where P.CategoryId = C.CategoryId
Group By CategoryName
Order By TotalProducts DESC;


-- P21: Total customers per country/city
Select Country, City, Count(City) as TotalCustomers
From Customers
Group By Country, City
Order By TotalCustomers DESC;


-- P22: Products that need reordering
Select ProductID, ProductName, UnitsInStock, ReorderLEvel
From Products
Where UnitsInStock < ReorderLEvel
Order By ProductId;


-- P23: Products that need reordering, continued
Select ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLEvel, Discontinued
From Products
Where (UnitsInStock + UnitsOnOrder) < ReorderLEvel
  And Discontinued = 0
Order By ProductId;


-- P24: Customer list by region
Select CustomerID,
       CompanyName,
       Region,
       Case
           When Region IS NULL Then 0
           Else 1
           End AS SortOrder
From Customers
Order By SortOrder Desc, Region ASC;


-- P25: High freight charges
Select ShipCountry, AVG(Freight) as AverageFreight
From Orders
Group By ShipCountry
Order By AverageFreight DESC
Limit 3;


-- P26: High freight charges - 2015
Select ShipCountry, AVG(Freight) as AverageFreight
From Orders
Where Extract(Year From OrderDate) = 2015
Group By ShipCountry
Order By AverageFreight DESC
Limit 3;


-- P27: High freight charges with between
Select ShipCountry, AVG(Freight) As AverageFreight
From Orders
Where OrderDate Between '1/1/2015' And '1/1/2016'
Group By ShipCountry
Order By AverageFreight DESC
Limit 3;


-- P29: Inventory list
Select O.EmployeeID, LastName, O.OrderID, ProductName, Quantity
From Orders O,
     OrderDetails Od,
     Products P,
     Employees E
Where O.OrderID = OD.OrderID
  And OD.ProductID = P.ProductID
  And O.EmployeeID = E.EmployeeID
Order By O.OrderID, P.ProductID;


-- P30: Customers with no orders
Select C.CustomerID, O.OrderId
From Customers C
         LEFT OUTER JOIN Orders O
                         ON C.CustomerID = O.CustomerID
Where OrderId IS NULL;


-- P31: Customers with no orders for EmployeeID 4
Select C.CustomerID, OrderId
From Customers C
         LEFT OUTER JOIN Orders O
                         ON C.CustomerID = O.CustomerID And O.EmployeeID = 4
Where OrderID is NULL;

--- Another Solution
Select CustomerID
From Customers
Where CustomerID Not In (Select distinct CustomerId From Orders Where EmployeeId = 4);