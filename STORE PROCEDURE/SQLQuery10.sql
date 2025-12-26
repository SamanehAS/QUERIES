CREATE PROCEDURE FSP10
    @LoanId INT,
    @ExtraDays INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Loans
        WHERE LoanId = @LoanId
          AND ReturnedAt IS NULL
    )
    BEGIN
        SELECT 'Loan not found or already returned' AS Message;
        RETURN;
    END
    IF EXISTS (
        SELECT 1
        FROM LoanRequests lr2
        WHERE lr2.BookId = (
            SELECT lr.BookId
            FROM LoanRequests lr
            JOIN Loans l ON l.RequestId = lr.RequestId
            WHERE l.LoanId = @LoanId
        )
        AND lr2.Status = 0
    )
    BEGIN
        SELECT 'Book is reserved by another student' AS Message;
        RETURN;
    END
    IF EXISTS (
        SELECT 1
        FROM Loans l
        JOIN LoanRequests lr ON lr.RequestId = l.RequestId
        WHERE l.LoanId = @LoanId
          AND l.DelayDays > 0
    )
    BEGIN
        SELECT 'Student has delay, extension not allowed' AS Message;
        RETURN;
    END
    UPDATE LoanRequests
    SET EndDate = DATEADD(DAY, @ExtraDays, EndDate)
    WHERE RequestId = (
        SELECT RequestId
        FROM Loans
        WHERE LoanId = @LoanId
    );

    SELECT 'Loan extended successfully' AS Message;
END;


EXEC FSP10
    @LoanId = 5,
    @ExtraDays = 7;
