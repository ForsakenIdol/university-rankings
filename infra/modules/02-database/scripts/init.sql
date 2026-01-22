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
