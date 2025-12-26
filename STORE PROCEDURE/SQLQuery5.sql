CREATE PROCEDURE FSP5
    @studentId INT,
    @isactive BIT
AS
BEGIN
    IF @isactive = 0 AND EXISTS (
        SELECT 1
        FROM Loans l
        JOIN LoanRequests lr ON l.RequestId = lr.RequestId
        WHERE lr.StudentId = @studentId
          AND l.ReturnedAt IS NULL
    )
    BEGIN
        SELECT 'Student has active loans' AS Message;
        RETURN;
    END

    UPDATE Students
    SET IsActive = @isactive
    WHERE StudentId = @studentId;

    SELECT 'Status updated successfully' AS Message;
END;

