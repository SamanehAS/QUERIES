CREATE PROCEDURE FSP3
    @title NVARCHAR(200),
    @publicationyear INT,
    @ISBN NVARCHAR(50),
    @publisher NVARCHAR(100),
    @authorid INT,
    @employeeid INT
AS
BEGIN
    INSERT INTO Books
    (Title, PublicationYear, ISBN, Publisher, TotalCopies, AuthorId, CreatedByEmployeeId, CreatedAt)
    VALUES
    (@title, @publicationyear, @ISBN, @publisher, 1, @authorid, @employeeid, GETDATE());

    SELECT 'Book registered successfully' AS Message;
END;
