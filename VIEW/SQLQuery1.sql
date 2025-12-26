create view FV1
as
select Books.Title , Books.PublicationYear , Books.TotalCopies
from Books
where Books.TotalCopies > 0 
