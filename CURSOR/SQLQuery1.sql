DECLARE 
    @StudentId INT,
    @LastLoanDate DATE,
    @InactiveDays INT,
    @Score INT,
    @HasActiveLoan INT;

DECLARE FC1_1 CURSOR FOR
SELECT StudentId
FROM Students;

OPEN FC1_1;
FETCH NEXT FROM FC1_1 INTO @StudentId;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @LastLoanDate = MAX(CreatedAt)
    FROM LoanRequests
    WHERE StudentId = @StudentId;

    IF @LastLoanDate IS NULL
        SET @InactiveDays = 999;
    ELSE
        SET @InactiveDays = DATEDIFF(DAY, @LastLoanDate, GETDATE());

    SELECT @HasActiveLoan = COUNT(*)
    FROM Loans l
    JOIN LoanRequests lr ON lr.RequestId = l.RequestId
    WHERE lr.StudentId = @StudentId
      AND l.ReturnedAt IS NULL;

    SET @Score = 0;

    IF @InactiveDays < 30
        SET @Score = @Score + 20;
    ELSE IF @InactiveDays BETWEEN 30 AND 90
        SET @Score = @Score + 10;

    IF @HasActiveLoan > 0
        SET @Score = @Score + 5;

    UPDATE Students
    SET credit_score = @Score
    WHERE StudentId = @StudentId;

    FETCH NEXT FROM FC1_1 INTO @StudentId;
END;

CLOSE FC1_1;
DEALLOCATE FC1_1;

