-- One row per employed respondent — for compensation and workforce analytics
-- Preserves respondent-level grain (no unnesting) for accurate aggregation

SELECT
    ResponseId,
    survey_date,
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
    ai_usage,
    ai_sentiment,
    ai_accuracy,

    -- Count of technologies known per category
    CASE WHEN languages_raw IS NOT NULL
         THEN ARRAY_LENGTH(STRING_SPLIT(languages_raw, ';'))
         ELSE 0
    END AS languages_count,

    CASE WHEN databases_raw IS NOT NULL
         THEN ARRAY_LENGTH(STRING_SPLIT(databases_raw, ';'))
         ELSE 0
    END AS databases_count

FROM stg_survey_responses
WHERE employment LIKE '%Employed%'
