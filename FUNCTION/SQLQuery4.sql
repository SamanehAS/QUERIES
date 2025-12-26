CREATE FUNCTION FF4 (@loan_id INT)
RETURNS INT
AS
BEGIN
    RETURN
    (
        SELECT
            CASE
                WHEN l.LoanId IS NULL THEN -1
                WHEN l.DelayDays * 1000 > 50000 THEN 50000
                ELSE l.DelayDays * 1000
            END
        FROM Loans l
        WHERE l.LoanId = @loan_id
    );
END;
