CREATE PROCEDURE FSP6
    @studentid INT,
    @bookid INT,
    @startdate DATE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Students
        WHERE StudentId = @studentid AND IsActive = 1
    )
    BEGIN
        SELECT 'Student is not active' AS Message;
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1 FROM Books
        WHERE BookId = @bookid AND TotalCopies > 0
    )
    BEGIN
        SELECT 'Book not available' AS Message;
        RETURN;
    END

    INSERT INTO LoanRequests
    (StudentId, BookId, StartDate, Status, CreatedAt)
    VALUES
    (@studentid, @bookid, @startdate, 0, GETDATE());

    SELECT 'Loan request registered' AS Message;
END;
