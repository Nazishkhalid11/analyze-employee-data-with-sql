/*
# \# SQL Project: Analyse Employee Data
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">This project uses the <code>zingo</code> database to explore employee data.&nbsp;&nbsp;</span>    
We'll answer real-world questions using SQL queries, such as:
\- Listing employees in the Engineering department  
\- Finding the highest paid employees  
\- Counting employees per department  
\- And more...
Let's begin!
*/

/*
### Connect to the Zingo Database and display tables
*/

USE zingo;
GO

SELECT * FROM sys.tables;


/*
**1\. List all employees** who work in the Engineering department.
*/

SELECT E.*,D.DeptName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DeptName = 'Engineering';


/*
**2\. Find all employees** hired after January 1, 2020.
*/

SELECT *
FROM Employees
where HireDate > '2020-01-01';

/*
**3\. Show employees** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">whose salary is between 50,000 and 90,000.</span>
*/

SELECT *
FROM Employees
WHERE Salary BETWEEN 50000 AND 90000;

/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">4. List all employees ordered by </span> **hire date (oldest first)**<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">.</span>
*/

SELECT *
FROM Employees
Order by HireDate ASC;

/*
Show top 10 employees with the **highest salaries**.
*/

SELECT Distinct FirstName, Salary
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


/*
But here I can See the dupliacte records,  lets remove dupliacte records
*/

SELECT FirstName, LastName, Salary, DepartmentID, COUNT(*) AS DuplicateCount
FROM Employees
GROUP BY FirstName, LastName, Salary, DepartmentID
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;

/*
So we have these employess record duplicate. Lets Delete the duplicate records.
*/

DELETE e
FROM Employees e
JOIN (
    SELECT FirstName, LastName, Salary, DepartmentID
    FROM Employees
    GROUP BY FirstName, LastName, Salary, DepartmentID
    HAVING COUNT(*) > 1
) dup
ON e.FirstName = dup.FirstName
AND e.LastName = dup.LastName
AND e.Salary = dup.Salary
AND e.DepartmentID = dup.DepartmentID;


/*
Lets check if the duplicate records are deleted or still here.
*/

SELECT FirstName, LastName, Salary, DepartmentID, COUNT(*) AS DuplicateCount
FROM Employees
GROUP BY FirstName, LastName, Salary, DepartmentID
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;

/*
We have remove the duplicate records lets find <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">top 10 employees with the</span> **highest salaries**<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">.</span>
*/

SELECT Distinct FirstName, Salary
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">6. List employees in the&nbsp;</span> **Marketing department**<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">, sorted by</span> **salary descending**<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">.</span>
*/

SELECT E.*,D.DeptName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DeptName = 'Marketing'
ORDER BY Salary DESC;


/*
7\. Lets find the  **unique department IDs** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">from the Employees table with Department name from Department table using join.</span>
*/

SELECT 
    E.FirstName,
    E.LastName,
    E.Salary,
    D.DeptName,
    AVG(E.Salary) OVER (PARTITION BY E.DepartmentID) AS AvgDeptSalary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DeptName = 'Sales'
ORDER BY E.Salary DESC;


/*
8\. Let's <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">Find the </span> **average salary** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">of employees in the Sales department.</span>
*/

SELECT 
    E.FirstName,
    E.LastName,
    E.Salary,
    D.DeptName,
    AVG(E.Salary) OVER (PARTITION BY E.DepartmentID) AS AvgDeptSalary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DeptName = 'Sales'
ORDER BY E.Salary DESC;


/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">9. Let's Count how many employees each </span> **department** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">has.</span>
*/

 SELECT D.DeptName, COUNT(*) AS EmployeeCount
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
GROUP BY D.DeptName
ORDER BY EmployeeCount DESC; -- optional: sorts by largest department


/*
10. Show each department with the **total salary payout** (group by DepartmentID)
*/

SELECT DepartmentID, SUM(Salary) AS TotalSalaryPayout
FROM Employees
GROUP BY DepartmentID;


/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">11. List departments where the&nbsp;</span> **average salary is over 80,000**<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">.</span>
*/

SELECT DepartmentID, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 80000;

/*
12. <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">Count departments with&nbsp;</span> **more than 5 employees**<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">.</span>
*/

SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 5;

/*
13. <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">Show&nbsp;</span> **Employee Name, DeptName, and Salary** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">using a JOIN.</span>
*/

SELECT E.FirstName, E.LastName, D.DeptName, E.Salary
FROM Employees E
JOIN Departments D
  ON E.DepartmentID = D.DepartmentID;

/*
14. <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">Show all departments&nbsp;</span> **even if they have no employees** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">(LEFT JOIN).</span>
*/

SELECT D.DeptName, E.FirstName, E.LastName, E.Salary
FROM Departments D
LEFT JOIN Employees E
  ON D.DepartmentID = E.DepartmentID;

/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">15. Show employee details for those in the&nbsp;</span> **IT** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">department.</span>
*/

SELECT E.*, D.DeptName
FROM Employees E
JOIN Departments D
  ON E.DepartmentID = D.DepartmentID
  Where DeptName = 'IT';

/*
16.  <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">Add a column showing&nbsp;</span> **Max salary** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">across all employees next to each row.</span>
*/

SELECT FirstName, LastName, DepartmentID, Salary,
       MAX(Salary) OVER () AS Max_Salary
FROM Employees;

/*
Let's join the `Departments` table to the `Employees` table to add and display the department name (`DeptName`) for each employee.
*/

select E.FirstName, E.LastName,E.DepartmentID,E.Salary,D.DeptName,Max(E.Salary) Over() AS Max_Salary
FROM Employees E
Join Departments D
ON E.DepartmentID = D.DepartmentID;

/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">17. Add a column showing&nbsp;</span> **Max salary** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">across all employees next to each row.</span>
*/

SELECT FirstName, LastName, DepartmentID, Salary, MAX(Salary) OVER (PARTITION by (DepartmentID)) AS Max_Department_Salary
From Employees;

/*
18. <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">Add a column to show&nbsp;</span>  **employee rank by salary** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">within each department. also show thw dept name from departmant table.&nbsp;</span>
*/

SELECT 
    E.*,
    D.DeptName,
    rank() OVER (
    Partition by (E.DepartmentID)
     oRDER BY E.Salary DESC
    ) AS SALARY_RANK
FROM Employees E 
Join Departments D
ON E.DepartmentID=D.DepartmentID;

/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">19. Show the&nbsp;</span> **top 2 highest paid employees** <span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">in each department.</span>
*/

SELECT *
FROM 
(
    SELECT 
    E.FirstName,
    E.LastName,
    E.Salary,
    D.DeptName,
    rank() OVER (
    Partition by (E.DepartmentID)
     oRDER BY E.Salary DESC
    ) AS SALARY_RANK
FROM Employees E 
Join Departments D
ON E.DepartmentID=D.DepartmentID
) AS RANKED_EMPLOYEES
WHERE Salary_Rank<=2;


/*
<span style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: var(--vscode-foreground);">20. Write a query that finds employees with&nbsp;</span> **duplicate first name.**
*/

/*
If we want just the Name count we can simply use group by and having with count function.
*/

SELECT FirstName, COUNT(*) AS NameCount
FROM Employees
GROUP BY FirstName
HAVING COUNT(*) > 1;

/*
But if we want to display all the details of the employees with dupliacte FirstName we can use the following query.
*/

SELECT *,COUNT(*) OVER (PARTITION BY FirstName) AS NameCount
FROM Employees
WHERE FirstName IN (
    SELECT FirstName
    FROM Employees
    GROUP BY FirstName
    HAVING COUNT(*) > 1
);



/*
<span style="background-color: transparent; color: rgb(26, 28, 30); font-family: &quot;Helvetica Neue&quot;, sans-serif; font-size: 10.5pt; white-space-collapse: preserve;">21. Create a new column that shows the year only from the HireDate.</span>
*/


 SELECT *, YEAR(HireDate) AS Year_Hired
 FROM Employees;
