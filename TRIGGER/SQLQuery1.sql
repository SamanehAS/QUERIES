CREATE TRIGGER FT1
ON Loans
INSTEAD OF INSERT
AS
BEGIN
    DECLARE
        @StudentId INT,
        @BookId INT,
        @StartDate DATE,
        @ActiveLoans INT,
        @TotalCopies INT,
        @ActiveBookLoans INT;

    SELECT
        @StudentId = lr.StudentId,
        @BookId = lr.BookId,
        @StartDate = lr.StartDate
    FROM inserted i
    JOIN LoanRequests lr ON lr.RequestId = i.RequestId;

    IF NOT EXISTS (
        SELECT 1
        FROM Students
        WHERE StudentId = @StudentId
          AND IsActive = 1
    )
    BEGIN
        RAISERROR (N'دانشجو غیرفعال است', 16, 1);
        RETURN;
    END

    SELECT @ActiveLoans = COUNT(*)
    FROM Loans l
    JOIN LoanRequests lr ON lr.RequestId = l.RequestId
    WHERE lr.StudentId = @StudentId
      AND l.ReturnedAt IS NULL;

    IF @ActiveLoans >= 3
    BEGIN
        RAISERROR (N'سهمیه امانت دانشجو تکمیل شده است', 16, 1);
        RETURN;
    END

    SELECT @TotalCopies = TotalCopies
    FROM Books
    WHERE BookId = @BookId;

    SELECT @ActiveBookLoans = COUNT(*)
    FROM Loans l
    JOIN LoanRequests lr ON lr.RequestId = l.RequestId
    WHERE lr.BookId = @BookId
      AND l.ReturnedAt IS NULL;

    IF @ActiveBookLoans >= @TotalCopies
    BEGIN
        RAISERROR (N'نسخه‌ای از این کتاب موجود نیست', 16, 1);
        RETURN;
    END

    IF @StartDate < CAST(GETDATE() AS DATE)
    BEGIN
        RAISERROR (N'تاریخ شروع امانت نامعتبر است', 16, 1);
        RETURN;
    END

    INSERT INTO Loans (RequestId, BorrowedAt)
    SELECT
        RequestId,
        GETDATE()
    FROM inserted;

    UPDATE LoanRequests
    SET EndDate = DATEADD(DAY, 14, StartDate),
        Status = 'Approved'
    WHERE RequestId IN (SELECT RequestId FROM inserted);
END;
