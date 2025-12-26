CREATE TRIGGER FT3
ON Students
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @StudentId INT;

    SELECT @StudentId = i.StudentId
    FROM inserted i
    JOIN deleted d ON i.StudentId = d.StudentId
    WHERE d.IsActive = 1
      AND i.IsActive = 0;

    IF @StudentId IS NULL
    BEGIN
        UPDATE Students
        SET IsActive = i.IsActive,
            credit_score = i.credit_score
        FROM Students s
        JOIN inserted i ON s.StudentId = i.StudentId;
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM Loans l
        JOIN LoanRequests lr ON lr.RequestId = l.RequestId
        WHERE lr.StudentId = @StudentId
          AND l.ReturnedAt IS NULL
    )
    BEGIN
        RAISERROR (N'دانشجو کتاب برگشت‌نداده دارد و نمی‌توان او را غیرفعال کرد', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM Loans l
        JOIN LoanRequests lr ON lr.RequestId = l.RequestId
        WHERE lr.StudentId = @StudentId
          AND l.DelayDays > 0
    )
    BEGIN
        UPDATE Students
        SET IsActive = 0,
            credit_score = credit_score - 10
        WHERE StudentId = @StudentId;

        RAISERROR (N'دانشجو به دلیل تأخیر معوق به حالت معلق منتقل شد', 10, 1);
        RETURN;
    END

    UPDATE LoanRequests
    SET Status = 'Rejected'
    WHERE StudentId = @StudentId
      AND Status = 'Pending';

    UPDATE Students
    SET IsActive = 0
    WHERE StudentId = @StudentId;
END;
