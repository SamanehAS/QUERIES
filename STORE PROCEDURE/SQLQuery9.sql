CREATE PROCEDURE FSP9
    @employeeid INT,
    @startdate DATE,
    @enddate DATE
AS
BEGIN
    SELECT
        e.FullName AS EmployeeName,
        COUNT(DISTINCT b.BookId) AS RegisteredBooks,
        COUNT(DISTINCT l.LoanId) AS ApprovedLoans,
        COUNT(DISTINCT CASE 
            WHEN l.ReturnedAt IS NOT NULL THEN l.LoanId 
        END) AS ReturnedBooks,
        AVG(
            DATEDIFF(
                DAY,
                lr.CreatedAt,
                lr.StartDate)) AS AvgApprovalDays

    FROM Employees e
    LEFT JOIN Books b
        ON b.CreatedByEmployeeId = e.EmployeeId
       AND b.CreatedAt BETWEEN @startdate AND @enddate

    LEFT JOIN Loans l
        ON l.ApprovedByEmployeeId = e.EmployeeId

    LEFT JOIN LoanRequests lr
        ON lr.RequestId = l.RequestId
       AND lr.CreatedAt BETWEEN @startdate AND @enddate

    WHERE e.EmployeeId = @employeeid

    GROUP BY e.FullName;
END;
