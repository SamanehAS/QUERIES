
	CREATE PROCEDURE FSP1_2
    @Username NVARCHAR(100),
    @PasswordHash NVARCHAR(200),
    @FullName NVARCHAR(200),
    @Email NVARCHAR(200),
    @BirthDate DATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Students
        (
		    FullName,
            Username,
            PasswordHash,
            IsActive,
            CreatedAt,
            Email,
            BirthDate
            
        )
        VALUES
        (@Username,@PasswordHash,@FullName,@Email,@BirthDate,1,GETDATE());

        SELECT 'Student registered successfully' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while registering student' AS Message;
    END CATCH
END;
