-- Procedure that populates the pipeline_runs table
CREATE PROCEDURE LogPipelineRun
(
    @RunId NVARCHAR(64),
    @ProcessedYear INT,
    @RunStartUtc DATETIME2,
    @RunEndUtc DATETIME2,
    @Status NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON; -- Don't print the row count for this procedure; this saves space and bandwidth

    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM dbo.rankings
    WHERE ranking_year = @ProcessedYear;

    INSERT INTO pipeline_runs
    (
        run_id,
        processed_year,
        run_start_utc,
        run_end_utc,
        status,
        total_rows_loaded
    )
    VALUES
    (
        @RunId,
        @ProcessedYear,
        @RunStartUtc,
        @RunEndUtc,
        @Status,
        @RowCount
    );
END;
