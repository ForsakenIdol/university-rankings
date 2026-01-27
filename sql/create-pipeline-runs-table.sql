-- We'll scope this down to each individual processed year at the wrapper pipeline level.
DROP TABLE IF EXISTS pipeline_runs;
CREATE TABLE pipeline_runs (
    run_id NVARCHAR(36) PRIMARY KEY,
    processed_year NVARCHAR(5),  -- 2011 / 2012 / 2013 / etc.
    run_start_utc DATETIME2,
    run_end_utc DATETIME2,
    status NVARCHAR(20),  -- 'SUCCESS', 'FAILED', 'PARTIAL'
    total_rows_loaded INT,
    duration_minutes AS DATEDIFF(MINUTE, run_start_utc, run_end_utc)
);
-- Procedure that populates the pipeline_runs table
DROP PROCEDURE IF EXISTS LogPipelineRun;


-- Run this separately, after above
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




-- Sample Queries

SELECT * FROM pipeline_runs;
