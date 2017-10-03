-- P32: High-value customers
Select C.CustomerId, CompanyName, O.OrderId, SUM(Quantity*UnitPrice) As TotalAmount
From Customers C, Orders O, OrderDetails Od
Where C.CustomerId=O.CustomerId
And O.OrderId=Od.OrderId
And extract(year from OrderDate)=2016
Group By C.CustomerId, O.OrderId
Having SUM(Quantity*UnitPrice)>=10000
Order By TotalAmount DESC;


-- P33: High-value customers - total orders
Select C.CustomerId, CompanyName, SUM(Quantity*UnitPrice) As TotalAmount
From Customers C
JOIN Orders O
  ON C.CustomerId=O.CustomerId
JOIN OrderDetails Od
  ON O.OrderId=Od.OrderId
Where extract(year from OrderDate)=2016
Group By C.CustomerId
Having SUM(Quantity*UnitPrice) >= 15000
Order By TotalAmount DESC;


-- P34: High-value customers - with discount
Select C.CustomerId, CompanyName, SUM(Quantity*UnitPrice*(1-Discount)) As TotalAmount
From Customers C
JOIN Orders O
  ON C.CustomerId=O.CustomerId
JOIN OrderDetails Od
  ON O.OrderId=Od.OrderId
Where extract(year from OrderDate)=2016
Group By C.CustomerId
Having SUM(Quantity*UnitPrice*(1-Discount)) >= 15000
Order By TotalAmount DESC;


-- P35: Month-end orders
Select EmployeeID, OrderId, OrderDate
From Orders
Where (extract(day from OrderDate)=31 AND extract(month from OrderDate) in (1,3,5,7,8,10,12)) 
OR (extract(day from OrderDate)=30 AND extract(month from OrderDate) in (4,6,9,11))
OR (extract(day from OrderDate) in (28,29) AND extract(month from OrderDate)=2)
Order By EmployeeID, OrderId;


-- P36: Orders with many line items
Select OrderId, Count(ProductId) As TotalOrderDetails
From OrderDetails
Group By OrderId
Order By TotalOrderDetails DESC
Limit 10;


-- P37: Orders - random assortment
Select OrderId
From Orders
Order By RANDOM()
Limit ((Select count(*) From Orders) * 0.02);


-- P38: Orders - accidental double-entry
Select OrderId
From OrderDetails
Where quantity>=60
Group By OrderId, Quantity
Having Count(*) >= 2;


-- P39: Orders - accidental double-entry details
Select OrderId, ProductId, UnitPrice, Quantity, Discount
From OrderDetails
Where OrderId IN (
	Select OrderId
	From OrderDetails
	Where quantity>=60
	Group By OrderId, Quantity
	Having Count(*) >= 2
);

--- Another Approach
WITH DoubleEntryOrders as (
	Select OrderId
	From OrderDetails
	Where quantity>=60
	Group By OrderId, Quantity
	Having Count(*) >= 2
)
Select OrderId, ProductId, UnitPrice, Quantity, Discount
From OrderDetails
Where OrderId IN (Select OrderId From DoubleEntryOrders);

 
-- P40: Orders - accidental double-entry details (corrected query)
Select O.OrderID
	,ProductID
	,UnitPrice
	,Quantity
	,Discount
From OrderDetails O
JOIN (
	Select DISTINCT OrderID
	From OrderDetails
	Where Quantity >= 60
	Group By OrderID, Quantity
	Having Count(*) >= 2
)  P
ON P.OrderID = O.OrderID
Order by OrderID, ProductID;


-- P41: Late orders
Select OrderId, OrderDate, RequiredDate, ShippedDate
From Orders
Where RequiredDate::date<ShippedDate::date;


-- P42: Late orders - which employees?
Select E.EmployeeId, CONCAT(FirstName, ' ', LastName), count(L.OrderId) as TotalLateOrders
From Employees E
JOIN (
        Select OrderId, EmployeeId
        From Orders
        Where RequiredDate::date<ShippedDate::date
) L
ON E.EmployeeId=L.EmployeeId
Group By E.EmployeeId
Order By TotalLateOrders DESC;


-- P43: Late orders vs. total orders
WITH LateOrders AS (
        Select E.EmployeeId, LastName, count(L.OrderId) as TotalLateOrders
        From Employees E
        JOIN (
                Select OrderId, EmployeeId
                From Orders
                Where RequiredDate::date<=ShippedDate::date
        ) L
        ON E.EmployeeId=L.EmployeeId
        Group By E.EmployeeId
),
AllOrders AS (
        Select E.EmployeeId, count(OrderId) as TotalOrders
        From Employees E
        JOIN Orders O
        ON E.EmployeeID=O.EmployeeId
        Group By E.EmployeeID
)
Select A.EmployeeID, TotalOrders, TotalLateOrders
From LateOrders L
JOIN AllOrders A
ON A.EmployeeId=L.EmployeeId
Order By A. EmployeeId;


-- P44: Late orders vs. total orders - missing employee
WITH LateOrders AS (
        Select EmployeeId, count(OrderId) as TotalLateOrders
        From Orders
        Where RequiredDate::date<=ShippedDate::date
        Group By EmployeeId
),
AllOrders AS (
        Select EmployeeId, count(OrderId) as TotalOrders
        From Orders
        Group By EmployeeID
)
Select A.EmployeeID, TotalOrders, TotalLateOrders
From LateOrders L
RIGHT OUTER JOIN AllOrders A
ON A.EmployeeId=L.EmployeeId
Order By A. EmployeeId;


-- P45: Late orders vs. total orders - fix null
WITH LateOrders AS (
        Select EmployeeId, count(OrderId) as TotalLateOrders
        From Orders
        Where RequiredDate::date<=ShippedDate::date
        Group By EmployeeId
),
AllOrders AS (
        Select EmployeeId, count(OrderId) as TotalOrders
        From Orders
        Group By EmployeeID
)
Select A.EmployeeID, TotalOrders, 
        CASE
          When TotalLateOrders IS NULL THEN 0
          ELSE TotalLateOrders
        END
From LateOrders L
RIGHT OUTER JOIN AllOrders A
ON A.EmployeeId=L.EmployeeId
Order By A. EmployeeId;


-- P46: Late orders vs. total orders - percentage
WITH LateOrders AS (
        Select EmployeeId, count(OrderId) as TotalLateOrders
        From Orders
        Where RequiredDate::date<=ShippedDate::date
        Group By EmployeeId
),
AllOrders AS (
        Select EmployeeId, count(OrderId) as TotalOrders
        From Orders
        Group By EmployeeID
)
Select A.EmployeeID, TotalOrders, COALESCE(TotalLateOrders, NULL, 0),
        (COALESCE(TotalLateOrders, NULL, 0) * 1.0 /TotalOrders) As PercentLateOrders
From LateOrders L
RIGHT OUTER JOIN AllOrders A
ON A.EmployeeId=L.EmployeeId
Order By A. EmployeeId;


-- P47: Late orders vs. total orders - fix decimal
WITH LateOrders AS (
        Select EmployeeId, count(OrderId) as TotalLateOrders
        From Orders
        Where RequiredDate::date<=ShippedDate::date
        Group By EmployeeId
),
AllOrders AS (
        Select EmployeeId, count(OrderId) as TotalOrders
        From Orders
        Group By EmployeeID
)
Select A.EmployeeID, TotalOrders, COALESCE(TotalLateOrders, NULL, 0),
        CAST((COALESCE(TotalLateOrders, NULL, 0) * 1.0 /TotalOrders) As Decimal(10,2)) As PercentLateOrders
From LateOrders L
RIGHT OUTER JOIN AllOrders A
ON A.EmployeeId=L.EmployeeId
Order By A. EmployeeId;


-- P48: Customer grouping
Select C.CustomerId, CompanyName, SUM(Quantity*UnitPrice*(1-Discount)) As TotalOrderAmount,
      CASE 
        WHEN SUM(Quantity*UnitPrice*(1-Discount)) BETWEEN 0 AND 1000 THEN 'LOW'
        WHEN SUM(Quantity*UnitPrice*(1-Discount)) BETWEEN 1000 AND 5000 THEN 'MEDIUM'
        WHEN SUM(Quantity*UnitPrice*(1-Discount)) BETWEEN 5000 AND 10000 THEN 'HIGH'
        WHEN SUM(Quantity*UnitPrice*(1-Discount)) >= 10000 THEN 'VERY HIGH'
        ELSE 'HIGH'
      END AS CustomerGroup  
From Orders O
JOIN Customers C
ON C.CustomerId=O.CustomerId
JOIN OrderDetails Od
ON Od.OrderId=O.OrderId
Where extract(year from O.OrderDate)=2016
Group By C.CustomerId
Order By C.CustomerId;


-- P50: Customer grouping with percentage
WITH CustomerGroups AS (
        Select CASE 
                 WHEN SUM(Quantity*UnitPrice*(1-Discount)) BETWEEN 0 AND 1000 THEN 'LOW'
                 WHEN SUM(Quantity*UnitPrice*(1-Discount)) BETWEEN 1000 AND 5000 THEN 'MEDIUM'
                 WHEN SUM(Quantity*UnitPrice*(1-Discount)) BETWEEN 5000 AND 10000 THEN 'HIGH'
                 WHEN SUM(Quantity*UnitPrice*(1-Discount)) >= 10000 THEN 'VERY HIGH'
               END AS CustomerGroup,
        CustomerId
        From Orders O
        JOIN OrderDetails Od
        ON Od.OrderId=O.OrderId
        Where extract(year from O.OrderDate)=2016
        Group By CustomerId
)
Select CustomerGroup, Count(CustomerId) As TotalInGroup, 
        (1.0 * Count(CustomerId) / (Select count(CustomerId) From CustomerGroups)) As PercentageInGroup
From CustomerGroups
Group By CustomerGroup
Order By TotalInGroup DESC;


-- P51: Customer grouping - flexible
WITH CustomerGrouping AS (
	Select C.CustomerId, CompanyName, SUM(Quantity*UnitPrice*(1-Discount)) As TotalOrderAmount
	From Orders O
	JOIN Customers C
	ON C.CustomerId=O.CustomerId
	JOIN OrderDetails Od
	ON Od.OrderId=O.OrderId
	Where extract (Year from O.OrderDate)=2016
	Group By C.CustomerId, C.CompanyName
)
Select CustomerId, CompanyName, TotalOrderAmount, Ct.CustomerGroupName
From CustomerGrouping Cg, CustomerGroupThresholds Ct
Where Cg.TotalOrderAmount BETWEEN Ct.RangeBottom AND Ct.RangeTop;


-- P52: Countries with suppliers or customers
Select Country From Customers
UNION
Select Country From Suppliers
Order By Country;


-- P53: Countries with suppliers or customers, version 2
Select DISTINCT S.Country AS SupplierCountry, C.Country AS CustomerCountry
From Suppliers S
FULL JOIN Customers C
ON S.Country=C.Country
Order By SupplierCountry, CustomerCountry;


-- P54: Countries with suppliers or customers - version 3
With CustomersPerCountry AS (
        Select Country, Count(CustomerId) As TotalCustomers
        From Customers
        Group By Country
),
SuppliersPerCountry AS (
        Select Country, Count(*) AS TotalSuppliers
        From Suppliers
        Group By Country
)
Select Coalesce(Cc.Country, NULL, Sc.Country) AS Country,
    Coalesce(TotalSuppliers, NULL, 0),
    Coalesce(TotalCustomers, NULL, 0)
From CustomersPerCountry Cc
FULL JOIN SuppliersPerCountry Sc
ON Cc.Country=Sc.Country
Order By Country;      


-- P55: First order in each country
WITH FirstOrderInCountry AS (
        Select ShipCountry,MIN(OrderDate) AS OrderDate
        From Orders
        Group By ShipCountry
)
Select O.ShipCountry, CustomerId, OrderId, O.OrderDate
From Orders O
JOIN FirstOrderInCountry F
ON O.ShipCountry=F.ShipCountry AND O.OrderDate=F.OrderDate
Order By ShipCountry, OrderId;


-- P56: Customers with multiple orders in 5 day period
Select O1.CustomerId, O1.OrderId As InitialOrder, O1.OrderDate::date As InitialOrderDate, 
        O2.OrderId AS NextOrder, O2.OrderDate::date As NextOrderDate, Date(O2.OrderDate)-Date(O1.OrderDate) As DaysInBetween
From Orders O1
JOIN Orders O2
ON O1.CustomerId=O2.CustomerId
Where O1.OrderId<O2.OrderId
And Date(O2.OrderDate)-Date(O1.OrderDate)<=5
Order By O1.CustomerId, O1.OrderId;