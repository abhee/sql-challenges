/*
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+
*/

/* Using self join */
Select E1.Name as Employee
From Employee E1
         JOIN Employee E2
              ON E2.Id = E1.ManagerId
Where E1.Salary > E2.Salary;

/* Using sub-query */
Select Name As Employee
From Employee E
Where Salary > (Select Salary From Employee Where Id = E.ManagerId);
