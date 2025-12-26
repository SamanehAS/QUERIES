CREATE FUNCTION FF7 (@student_id INT)
RETURNS INT
AS
BEGIN
    RETURN
    (
        SELECT
            (
                (SELECT COUNT(*) * 10
                 FROM Loans l
                 JOIN LoanRequests lr ON l.RequestId = lr.RequestId
                 WHERE lr.StudentId = s.StudentId
                   AND l.DelayDays = 0)
                -
                (SELECT COUNT(*) * 5
                 FROM Loans l
                 JOIN LoanRequests lr ON l.RequestId = lr.RequestId
                 WHERE lr.StudentId = s.StudentId
                   AND l.DelayDays > 0)
                +
                (DATEDIFF(YEAR, s.CreatedAt, GETDATE()) * 5)
            )
        FROM Students s
        WHERE s.StudentId = @student_id
    );
END;

