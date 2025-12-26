CREATE FUNCTION FF8
(
    @employee_id INT,
    @start_date DATE,
    @end_date DATE
)
RETURNS INT
AS
BEGIN
    RETURN
    (
        SELECT
            CAST(
                CASE
                    WHEN score > 100 THEN 100
                    ELSE score
                END
            AS INT)
        FROM
        (
            SELECT
                (
                    (COUNT(l.LoanId) * 0.3) +
                    (SUM(CASE WHEN l.DelayDays = 0 THEN 1 ELSE 0 END) * 0.3)
                ) AS score
            FROM Loans l
            WHERE l.ApprovedByEmployeeId = @employee_id
        ) t
    );
END;
