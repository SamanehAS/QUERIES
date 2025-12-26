create view FV4
as
select
Students.FullName , AVG(Loans.DelayDays * 1.0) as AvgDelayDays , COUNT(Loans.LoanId) as TotalBorrowedBooks
from Students 
JOIN LoanRequests  on LoanRequests.StudentId = Students.StudentId
JOIN Loans  on Loans.RequestId = LoanRequests.RequestId
where Loans.DelayDays > 0    
group by Students.FullName
having AVG(Loans.DelayDays * 1.0) > 7;



