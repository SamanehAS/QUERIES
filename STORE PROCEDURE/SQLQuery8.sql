CREATE PROCEDURE FSP8
    @loanid INT,
    @employeeid INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Loans
        WHERE LoanId = @loanid AND ReturnedAt IS NULL)
    BEGIN
        SELECT 'Loan not found or already returned' AS Message;
        RETURN;
    END

    UPDATE Loans
    SET
        ReturnedAt = GETDATE(),
        DelayDays =
            CASE
                WHEN GETDATE() >
                     DATEADD(DAY, 14,
                        (SELECT StartDate
                         FROM LoanRequests
                         WHERE RequestId = Loans.RequestId))
                THEN
                    DATEDIFF(
                        DAY,
                        DATEADD(DAY, 14,
                            (SELECT StartDate
                             FROM LoanRequests
                             WHERE RequestId = Loans.RequestId)),
                        GETDATE()
                    )
                ELSE 0
            END
    WHERE LoanId = @loanid;
    UPDATE Books
    SET TotalCopies = TotalCopies + 1
    WHERE BookId = (
        SELECT BookId
        FROM LoanRequests
        WHERE RequestId = (
            SELECT RequestId
            FROM Loans
            WHERE LoanId = @loanid)
    );

    SELECT 'Book returned successfully' AS Message;
END;
