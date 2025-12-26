CREATE FUNCTION FF1 (@loan_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @delay INT;

    SELECT @delay =
        CASE
            WHEN lr.EndDate IS NULL
                 AND GETDATE() > lr.EndDate THEN
                DATEDIFF(DAY, lr.EndDate, GETDATE())
            WHEN lr.EndDate < lr.EndDate THEN
                DATEDIFF(DAY, lr.EndDate, lr.EndDate)
            ELSE 0
        END
    FROM Loans l
    JOIN LoanRequests lr ON l.RequestId = lr.RequestId
    WHERE l.LoanId = @loan_id;

    RETURN ISNULL(@delay, 0);
END;
