CREATE PROCEDURE FSP1
    @Username NVARCHAR(100),
    @PasswordHash NVARCHAR(200),
    @FullName NVARCHAR(200)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Students
        (Username,PasswordHash,FullName,IsActive,CreatedAt)
        VALUES
        (@Username,@PasswordHash,@FullName,1,GETDATE());
        SELECT 'Student registered successfully' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while registering student' AS Message;
    END CATCH
END;

