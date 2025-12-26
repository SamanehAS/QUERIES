CREATE TRIGGER FT2_2
ON Loans
AFTER UPDATE
AS
BEGIN
    DECLARE 
        @BookId INT,
        @StudentId INT,
        @BorrowedAt DATE,
        @ReturnedAt DATE,
        @Delay INT;

    SELECT
        @BookId = lr.BookId,
        @StudentId = lr.StudentId,
        @BorrowedAt = d.BorrowedAt,
        @ReturnedAt = i.ReturnedAt
    FROM inserted i
    JOIN deleted d ON i.LoanId = d.LoanId
    JOIN LoanRequests lr ON lr.RequestId = i.RequestId
    WHERE d.ReturnedAt IS NULL
      AND i.ReturnedAt IS NOT NULL;

    UPDATE Books
    SET TotalCopies = TotalCopies + 1
    WHERE BookId = @BookId;

    SET @Delay =
        CASE
            WHEN DATEDIFF(DAY, @BorrowedAt, @ReturnedAt) > 14
            THEN DATEDIFF(DAY, @BorrowedAt, @ReturnedAt) - 14
            ELSE 0
        END;

    UPDATE Loans
    SET DelayDays = @Delay
    WHERE LoanId IN (SELECT LoanId FROM inserted);

    UPDATE Students
    SET credit_score =
        CASE
            WHEN @Delay = 0 THEN credit_score + 5
            ELSE credit_score - (@Delay * 2)
        END
    WHERE StudentId = @StudentId;

    INSERT INTO LoanHistory (LoanId, Action, ActionDate)
    SELECT LoanId, N'Loan Returned', GETDATE()
    FROM inserted;
END;
