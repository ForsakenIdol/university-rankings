#!/bin/sh

for csvfile in $(find raw | grep "csv"); do
    cat $csvfile | head -1 | tr ',' '\n'
done | awk '!seen[$0]++'

# rank_order
# rank
# name
# scores_overall
# scores_overall_rank
# scores_teaching
# scores_teaching_rank
# scores_international_outlook
# scores_international_outlook_rank
# scores_industry_income
# scores_industry_income_rank
# scores_research
# scores_research_rank
# scores_citations
# scores_citations_rank
# location
# aliases
# subjects_offered
# closed
# unaccredited
# stats_number_students
# stats_student_staff_ratio
# stats_pc_intl_students
# stats_female_male_ratio
# stats_proportion_of_isr