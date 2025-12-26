CREATE FUNCTION FF2 (@book_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @copies INT;

    SELECT @copies = TotalCopies
    FROM Books
    WHERE BookId = @book_id;

    RETURN ISNULL(@copies, -1);
END;

