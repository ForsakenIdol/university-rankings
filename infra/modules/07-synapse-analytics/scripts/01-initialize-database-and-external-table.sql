IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'rankings_database')
BEGIN
    CREATE DATABASE rankings_database;
END;

USE rankings_database;
GO


IF OBJECT_ID('rankings_curated_external', 'U') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE rankings_curated_external;
END;
GO

IF EXISTS (SELECT 1 FROM sys.external_file_formats WHERE name = 'CsvWithHeader')
BEGIN
    DROP EXTERNAL FILE FORMAT CsvWithHeader;
END;
GO

IF EXISTS (SELECT 1 FROM sys.external_data_sources WHERE name = 'CuratedRankings')
BEGIN
    DROP EXTERNAL DATA SOURCE CuratedRankings;
END;
GO


CREATE EXTERNAL DATA SOURCE CuratedRankings
WITH (
    LOCATION = 'https://${storage_account_name}.dfs.core.windows.net/curated'
);
CREATE EXTERNAL FILE FORMAT CsvWithHeader
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',', STRING_DELIMITER = '"', FIRST_ROW = 2)
);
GO

CREATE EXTERNAL TABLE rankings_curated_external
(
    rank_order INT,
    rank VARCHAR(10),
    name VARCHAR(128),

    scores_overall FLOAT NULL,
    scores_overall_rank INT NULL,
    scores_teaching FLOAT NULL,
    scores_teaching_rank INT NULL,

    scores_research FLOAT NULL,
    scores_research_rank INT NULL,
    scores_citations FLOAT NULL,
    scores_citations_rank INT NULL,

    scores_industry_income FLOAT NULL,
    scores_industry_income_rank INT NULL,
    scores_international_outlook FLOAT NULL,
    scores_international_outlook_rank INT NULL,

    location VARCHAR(128) NULL,
    stats_number_students INT NULL,
    stats_student_staff_ratio FLOAT NULL,
    stats_pc_intl_students FLOAT NULL,
    stats_female_male_ratio FLOAT NULL,
    stats_proportion_of_isr FLOAT NULL,

    aliases VARCHAR(512) NULL,
    subjects_offered NVARCHAR(MAX) NULL,
    closed BIT NULL,
    unaccredited BIT NULL,
    ranking_year INT
)
WITH (
    LOCATION = '/',
    DATA_SOURCE = CuratedRankings,
    FILE_FORMAT = CsvWithHeader
);

