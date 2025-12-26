CREATE TRIGGER FT2_1
ON Loans
AFTER INSERT
AS
BEGIN
    DECLARE @BookId INT;

    SELECT @BookId = lr.BookId
    FROM inserted i
    JOIN LoanRequests lr ON lr.RequestId = i.RequestId;

    UPDATE Books
    SET TotalCopies = TotalCopies - 1
    WHERE BookId = @BookId;

    INSERT INTO LoanHistory (LoanId, Action, ActionDate)
    SELECT LoanId, N'Loan Created', GETDATE()
    FROM inserted;
END;
