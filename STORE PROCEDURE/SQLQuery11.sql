CREATE PROCEDURE FSP11
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SELECT
        COUNT(*) AS TotalLoans
    FROM LoanRequests
    WHERE Status = 1
      AND StartDate BETWEEN @FromDate AND @ToDate;

    SELECT
        COUNT(*) AS ActiveStudents
    FROM Students
    WHERE IsActive = 1;

    SELECT
        b.Title,
        COUNT(lr.RequestId) AS LoanCount
    FROM Books b
    JOIN LoanRequests lr ON lr.BookId = b.BookId
    WHERE lr.Status = 1
      AND lr.StartDate BETWEEN @FromDate AND @ToDate
    GROUP BY b.Title
    ORDER BY LoanCount DESC;

    SELECT
        e.FullName,
        COUNT(l.LoanId) AS ApprovedLoans
    FROM Employees e
    LEFT JOIN Loans l ON l.ApprovedByEmployeeId = e.EmployeeId
    LEFT JOIN LoanRequests lr ON lr.RequestId = l.RequestId
    WHERE lr.StartDate BETWEEN @FromDate AND @ToDate
    GROUP BY e.FullName
    ORDER BY ApprovedLoans DESC;

    SELECT
        AVG(
            DATEDIFF(
                DAY,
                lr.StartDate,
                ISNULL(lr.EndDate, GETDATE())
            ) * 1.0
        ) AS AvgLoanDays
    FROM LoanRequests lr
    WHERE lr.Status = 1
      AND lr.StartDate BETWEEN @FromDate AND @ToDate;

    SELECT
        CAST(
            COUNT(CASE WHEN l.DelayDays > 0 THEN 1 END) * 100.0
            /
            NULLIF(COUNT(l.LoanId), 0)
        AS DECIMAL(5,2)) AS DelayRatePercent
    FROM Loans l
    JOIN LoanRequests lr ON lr.RequestId = l.RequestId
    WHERE lr.StartDate BETWEEN @FromDate AND @ToDate;
END;

EXEC FSP11
    @FromDate = '2024-01-01',
    @ToDate   = '2024-12-31';

