CREATE VIEW FV6
AS
SELECT
    YEAR(lr.StartDate) AS LoanYear,
    MONTH(lr.StartDate) AS LoanMonth,
    COUNT(lr.RequestId) AS TotalLoans,
    AVG(
        DATEDIFF(
            DAY,
            lr.StartDate,
            ISNULL(lr.EndDate, GETDATE())
        ) * 1.0
    ) AS AvgLoanDays
FROM LoanRequests lr
WHERE lr.Status = 1   
GROUP BY
    YEAR(lr.StartDate),
    MONTH(lr.StartDate);

