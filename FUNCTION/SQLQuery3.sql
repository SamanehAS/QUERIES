CREATE FUNCTION FF3 (@book_id INT, @copy_number INT)
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN 'BOOK-' + CAST(@book_id AS VARCHAR)
           + '-COPY-' + CAST(@copy_number AS VARCHAR);
END;
