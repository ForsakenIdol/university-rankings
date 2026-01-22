/*
 * This is only confirmed to capture the fields in the 2011 CSV file.
 * It should also work for all years 2011 - 2016 since these years share the same fields.
 * 2017 onwards introduces a small handful of new fields that this table won't capture.
 * The command below generates a newline-separated list of all the fields.
 * echo "rank_order,rank,name,scores_overall,scores_overall_rank,scores_teaching,scores_teaching_rank,scores_international_outlook,scores_international_outlook_rank,scores_industry_income,scores_industry_income_rank,scores_research,scores_research_rank,scores_citations,scores_citations_rank,location,aliases,subjects_offered,closed,unaccredited" | tr ',' '\n'
 */

-- MSSQL-compatible CREATE TABLE statement
DROP TABLE IF EXISTS rankings;
CREATE TABLE rankings(
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
    aliases VARCHAR(512) NULL,
    subjects_offered NVARCHAR(MAX) NULL,
    closed BIT NULL,
    unaccredited BIT NULL,
    PRIMARY KEY (name)
);

-- Other useful commands
SELECT TOP 10 * FROM [dbo].[rankings] ORDER BY rank ASC;
SELECT name FROM [dbo].[rankings] WHERE rank = 6;
