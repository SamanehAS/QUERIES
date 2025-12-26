CREATE FUNCTION FF6 (@student_id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN
    (
        SELECT
            'student: ' + s.FullName + CHAR(10) +
            'count of loans: ' +
                CAST(COUNT(lr.RequestId) AS VARCHAR) + CHAR(10) +
            'count of delays: ' +
                CAST(SUM(CASE WHEN l.DelayDays > 0 THEN 1 ELSE 0 END) AS VARCHAR) + CHAR(10) +
            'credit score: ' +
                CAST(
                    COUNT(CASE WHEN l.DelayDays = 0 THEN 1 END) * 10
                    -
                    COUNT(CASE WHEN l.DelayDays > 0 THEN 1 END) * 5
                AS VARCHAR
                ) + CHAR(10) +
            'status: ' +
                CASE WHEN s.IsActive = 1 THEN 'active' ELSE 'not active' END
        FROM Students s
        LEFT JOIN LoanRequests lr ON lr.StudentId = s.StudentId
        LEFT JOIN Loans l ON l.RequestId = lr.RequestId
        WHERE s.StudentId = @student_id
        GROUP BY s.FullName, s.IsActive
    );
END;
