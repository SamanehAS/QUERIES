CREATE VIEW FV5_1
AS
SELECT
    Employees.FullName,
    COUNT(Loans.LoanId) AS TotalApprovedLoans,
    SUM(
        CASE 
            WHEN Loans.ReturnedAt IS NULL THEN 1 
            ELSE 0 
        END
    ) AS ActiveLoans
FROM Employees 
LEFT JOIN Loans 
    ON Loans.ApprovedByEmployeeId = Employees.EmployeeId
GROUP BY Employees.FullName;
