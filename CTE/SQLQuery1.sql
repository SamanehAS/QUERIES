WITH FCTE AS
(
    SELECT StudentId,BookId,CreatedAt,1 AS Step
    FROM LoanRequests
    WHERE CreatedAt = (
        SELECT MIN(CreatedAt)
        FROM LoanRequests lr
        WHERE lr.StudentId = LoanRequests.StudentId
    )

    UNION ALL

    SELECT lr2.StudentId,lr2.BookId,lr2.CreatedAt,f.Step + 1
    FROM LoanRequests lr2
    JOIN FCTE f
        ON lr2.StudentId = f.StudentId
       AND lr2.CreatedAt > f.CreatedAt
)
SELECT
    s.FullName,
    b.Title AS BookTitle,
    f.Step,
    f.CreatedAt
FROM FCTE f
JOIN Students s ON s.StudentId = f.StudentId
JOIN Books b ON b.BookId = f.BookId
ORDER BY s.FullName, f.Step;
