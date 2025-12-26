CREATE PROCEDURE FSP2
    @username NVARCHAR(100),
    @oldpass NVARCHAR(200),
    @newpass NVARCHAR(200)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Students
        WHERE Username = @username
          AND PasswordHash = @oldpass
    )
    BEGIN
        UPDATE Students
        SET PasswordHash = @newpass
        WHERE Username = @username;

        SELECT 'Password updated successfully' AS Message;
    END
    ELSE
        SELECT 'Invalid username or password' AS Message;
END;
