create view FV3
as
select top 10  Books.Title , COUNT(LoanRequests.BookId) as TotalLoans
from Books
JOIN LoanRequests on Books.BookId = LoanRequests.BookId
JOIN Loans  on LoanRequests.RequestId = Loans.RequestId
group by Books.Title
order by TotalLoans desc 


