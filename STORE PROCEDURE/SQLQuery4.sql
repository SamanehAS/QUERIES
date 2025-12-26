CREATE PROCEDURE FSP4
    @Title NVARCHAR(200) = NULL,
    @AuthorId INT = NULL,
    @Year INT = NULL
AS
BEGIN
    SELECT
        b.Title,
        b.PublicationYear,
        b.Publisher,
        b.TotalCopies
    FROM Books b
    WHERE
        (@Title IS NULL OR b.Title LIKE '%' + @Title + '%')
        AND (@AuthorId IS NULL OR b.AuthorId = @AuthorId)
        AND (@Year IS NULL OR b.PublicationYear = @Year);
END;
