CREATE PROCEDURE FSP7
    @requestid INT,
    @employeeid INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM LoanRequests
        WHERE RequestId = @requestid
          AND CAST(StartDate AS DATE) >= DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
    )
    BEGIN
        SELECT 'Request is not for today or yesterday' AS Message;
        RETURN;
    END
    UPDATE LoanRequests
    SET
        Status = 1,
        EndDate = DATEADD(DAY, 14, StartDate)
    WHERE RequestId = @requestid;

    INSERT INTO Loans
    (RequestId, ApprovedByEmployeeId)
    VALUES
    (@requestid, @employeeid);

    SELECT 'Loan request approved successfully' AS Message;
END;
