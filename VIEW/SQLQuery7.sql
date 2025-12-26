CREATE VIEW FV7
AS
SELECT
    b.Title,
    COUNT(CASE
        WHEN lr.StartDate >= DATEADD(DAY, -30, GETDATE())
        THEN 1
    END) AS RecentLoans,
    COUNT(CASE
        WHEN lr.StartDate BETWEEN DATEADD(DAY, -60, GETDATE())
             AND DATEADD(DAY, -31, GETDATE())
        THEN 1
    END) AS PreviousLoans,
    (
        COUNT(CASE
            WHEN lr.StartDate >= DATEADD(DAY, -30, GETDATE())
            THEN 1
        END)
        -
        COUNT(CASE
            WHEN lr.StartDate BETWEEN DATEADD(DAY, -60, GETDATE())
                 AND DATEADD(DAY, -31, GETDATE())
            THEN 1
        END)
    ) AS LoanGrowth
FROM Books b
JOIN LoanRequests lr ON lr.BookId = b.BookId
WHERE lr.Status = 1   -- فقط درخواست‌های تأییدشده
GROUP BY b.Title
HAVING
    COUNT(CASE
        WHEN lr.StartDate >= DATEADD(DAY, -30, GETDATE())
        THEN 1
    END) >= 5
    AND
    COUNT(CASE
        WHEN lr.StartDate >= DATEADD(DAY, -30, GETDATE())
        THEN 1
    END)
    >
    COUNT(CASE
        WHEN lr.StartDate BETWEEN DATEADD(DAY, -60, GETDATE())
             AND DATEADD(DAY, -31, GETDATE())
        THEN 1
    END);
