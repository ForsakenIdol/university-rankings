/*
 * The commands contained within this file should create the general table for ALL years.
 * If a row is inserted without a value for a nullable column, that column is automatically null for that row.
 * Non-nullable columns must have a value for each inserted row.
 */

-- MSSQL-compatible CREATE TABLE statement
DROP TABLE IF EXISTS rankings;
CREATE TABLE rankings(
    ranking_year INT,                   -- This column needs to be populated using the "PipelineProcessingYear" parameter.
    rank_order INT,
    rank VARCHAR(10),
    name VARCHAR(128),
    scores_overall FLOAT NULL,
    scores_overall_rank INT NULL,
    scores_teaching FLOAT NULL,
    scores_teaching_rank INT NULL,
    scores_international_outlook FLOAT NULL,
    scores_international_outlook_rank INT NULL,
    scores_industry_income FLOAT NULL,
    scores_industry_income_rank INT NULL,
    scores_research FLOAT NULL,
    scores_research_rank INT NULL,
    scores_citations FLOAT NULL,
    scores_citations_rank INT NULL,
    location VARCHAR(128) NULL,
    -- Some of the following columns may require transformation from the input dataset before being stored.
    stats_number_students INT NULL,        -- This column is expressed as a string representing a comma-separated number.
    stats_student_staff_ratio FLOAT NULL,  -- This column is expressed as a standard float.
    stats_pc_intl_students FLOAT NULL,     -- This column is expressed with the percentage '%' sign.
    stats_female_male_ratio FLOAT NULL,    -- This column is expressed as a colon-separated ratio, e.g. `61 : 39`.

    aliases VARCHAR(512) NULL,
    subjects_offered NVARCHAR(MAX) NULL,
    closed BIT NULL,
    unaccredited BIT NULL,
    PRIMARY KEY (name, ranking_year)
);

-- Useful commands
SELECT COUNT(*) FROM [dbo].[rankings];
SELECT TOP 10 * FROM [dbo].[rankings] ORDER BY rank ASC;
SELECT name FROM [dbo].[rankings] WHERE rank = 6;
SELECT ranking_year, COUNT(*) AS total_record_count FROM [dbo].[rankings] GROUP BY ranking_year;

