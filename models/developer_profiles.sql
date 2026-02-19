-- One row per employed respondent — for compensation and workforce analytics
-- Preserves respondent-level grain (no unnesting) for accurate aggregation

SELECT
    ResponseId,
    survey_date,
    survey_year,
    country,
    age,
    education_level,
    experience_level,
    remote_work,
    employment,
    dev_type,
    org_size,
    comp_annual,
    comp_band,
    work_exp,
    job_satisfaction,
    ai_usage,
    ai_sentiment,
    ai_accuracy,

    -- Is this person a data engineer? (semicolon-separated DevType field)
    CASE WHEN dev_type LIKE '%Data engineer%' THEN true ELSE false END AS is_data_engineer,

    -- Count of technologies known per category
    CASE WHEN languages_raw IS NOT NULL
         THEN ARRAY_LENGTH(STRING_SPLIT(languages_raw, ';'))
         ELSE 0
    END AS languages_count,

    CASE WHEN databases_raw IS NOT NULL
         THEN ARRAY_LENGTH(STRING_SPLIT(databases_raw, ';'))
         ELSE 0
    END AS databases_count,

    CASE WHEN editors_raw IS NOT NULL
         THEN ARRAY_LENGTH(STRING_SPLIT(editors_raw, ';'))
         ELSE 0
    END AS editors_count

FROM stg_survey_responses
WHERE employment LIKE '%Employed%'
