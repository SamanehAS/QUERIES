CREATE FUNCTION FF5 (@student_id INT)
RETURNS BIT
AS
BEGIN
    RETURN
    (
        SELECT
            CASE
                WHEN s.IsActive = 1
                     AND
                     (
                        SELECT COUNT(*)
                        FROM LoanRequests
                        WHERE StudentId = s.StudentId
                          AND EndDate IS NULL
                          AND Status = 1
                     ) < 3
                     AND
                     ISNULL(
                        (
                            SELECT SUM(l.DelayDays * 1000)
                            FROM Loans l
                            JOIN LoanRequests lr ON l.RequestId = lr.RequestId
                            WHERE lr.StudentId = s.StudentId
                        ), 0
                     ) <= 20000
                THEN 1
                ELSE 0
            END
        FROM Students s
        WHERE s.StudentId = @student_id
    );
END;
