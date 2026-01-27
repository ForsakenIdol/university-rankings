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
DROP PROCEDURE IF EXISTS LogPipelineRun;
