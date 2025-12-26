CREATE VIEW FV5
AS
SELECT
    e.FullName,
    COUNT(l.LoanId) AS TotalApprovedLoans,
    SUM(CASE 
            WHEN l.ReturnedAt IS NULL THEN 1 
            ELSE 0 
        END) AS ActiveLoans
FROM Employees e
LEFT JOIN Loans l
    ON l.ApprovedByEmployeeId = e.EmployeeId
GROUP BY e.FullName;





