DECLARE
    @StudentId INT,
    @FullName NVARCHAR(100),
    @RegisterDate DATE,
    @LastActivity DATE,
    @TotalLoans INT,
    @ActiveLoans INT,
    @TotalDelays INT,
    @CreditScore INT,
    @Category NVARCHAR(50),
    @Summary NVARCHAR(500),
    @Priority INT;

DECLARE FC2 CURSOR FOR
SELECT StudentId, FullName, CreatedAt, credit_score
FROM Students;

OPEN FC2;
FETCH NEXT FROM FC2
INTO @StudentId, @FullName, @RegisterDate, @CreditScore;

WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT @TotalLoans = COUNT(*)
    FROM LoanRequests
    WHERE StudentId = @StudentId;

    SELECT @LastActivity = MAX(CreatedAt)
    FROM LoanRequests
    WHERE StudentId = @StudentId;

    SELECT
        @ActiveLoans = COUNT(*),
        @TotalDelays = SUM(ISNULL(DelayDays,0))
    FROM Loans l
    JOIN LoanRequests lr ON lr.RequestId = l.RequestId
    WHERE lr.StudentId = @StudentId
      AND l.ReturnedAt IS NULL;


    IF @RegisterDate >= DATEADD(MONTH, -3, GETDATE())
    BEGIN
        SET @Category = N'دانشجوی جدید';
        SET @Summary = N'دانشجوی تازه ثبت‌نام شده';
        SET @Priority = 3;
    END
    ELSE IF @TotalDelays >= 3
    BEGIN
        SET @Category = N'دانشجوی مشکل‌ساز';
        SET @Summary = N'دارای تأخیرهای مکرر در بازگرداندن کتاب';
        SET @Priority = 1;
    END
    ELSE IF @TotalLoans < 3
    BEGIN
        SET @Category = N'دانشجوی غیرفعال';
        SET @Summary = N'فعالیت کم در استفاده از خدمات کتابخانه';
        SET @Priority = 2;
    END
    ELSE IF @TotalLoans BETWEEN 3 AND 10
    BEGIN
        SET @Category = N'دانشجوی معمولی';
        SET @Summary = N'استفاده متعادل از خدمات کتابخانه';
        SET @Priority = 2;
    END
    ELSE
    BEGIN
        SET @Category = N'دانشجوی فعال ممتاز';
        SET @Summary = N'دانشجوی فعال با سابقه امانت عالی';
        SET @Priority = 3;
    END


    INSERT INTO student_status_report (
        student_id,
        full_name,
        student_category,
        registration_date,
        last_activity_date,
        total_loans,
        current_active_loans,
        total_delays,
        credit_score,
        status_summary,
        priority_level,
        report_generation_date
    )
    VALUES (
        @StudentId,
        @FullName,
        @Category,
        @RegisterDate,
        @LastActivity,
        @TotalLoans,
        @ActiveLoans,
        @TotalDelays,
        @CreditScore,
        @Summary,
        @Priority,
        GETDATE()
    );

    FETCH NEXT FROM FC2
    INTO @StudentId, @FullName, @RegisterDate, @CreditScore;
END;

CLOSE FC2;
DEALLOCATE FC2;
