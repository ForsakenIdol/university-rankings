/*
 * This is only confirmed to capture the fields in the 2011 CSV file.
 * The command below generates a newline-separated list of all the fields.
 * echo "rank_order,rank,name,scores_overall,scores_overall_rank,scores_teaching,scores_teaching_rank,scores_international_outlook,scores_international_outlook_rank,scores_industry_income,scores_industry_income_rank,scores_research,scores_research_rank,scores_citations,scores_citations_rank,location,aliases,subjects_offered,closed,unaccredited" | tr ',' '\n'
 */

-- MSSQL-compatible CREATE TABLE statement
DROP TABLE IF EXISTS rankings_2011;
CREATE TABLE rankings_2011(
    rank_order INT,
    rank INT,
    name NVARCHAR(MAX),
    scores_overall FLOAT,
    scores_overall_rank INT,
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
    location NVARCHAR(MAX) NULL,
    aliases NVARCHAR(MAX) NULL,
    subjects_offered NVARCHAR(MAX) NULL,
    closed BIT NULL,
    unaccredited BIT NULL,
    PRIMARY KEY (scores_overall, scores_overall_rank)
);
