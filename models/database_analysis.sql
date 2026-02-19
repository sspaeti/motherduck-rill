-- Database analysis: Used vs Admired vs Desired
-- Unnests database columns into one row per respondent × database × relationship type

WITH used AS (
    SELECT
        s.ResponseId,
        s.survey_date,
        s.survey_year,
        s.country,
        s.age,
        s.experience_level,
        s.remote_work,
        s.org_size,
        s.comp_annual,
        s.dev_type,
        CASE WHEN s.dev_type LIKE '%Data engineer%' THEN true ELSE false END AS is_data_engineer,
        'Used' AS relationship,
        TRIM(db.value) AS database_name
    FROM stg_survey_responses s,
         LATERAL UNNEST(STRING_SPLIT(s.databases_raw, ';')) AS db(value)
    WHERE s.databases_raw IS NOT NULL
),

desired AS (
    SELECT
        s.ResponseId,
        s.survey_date,
        s.survey_year,
        s.country,
        s.age,
        s.experience_level,
        s.remote_work,
        s.org_size,
        s.comp_annual,
        s.dev_type,
        CASE WHEN s.dev_type LIKE '%Data engineer%' THEN true ELSE false END AS is_data_engineer,
        'Desired' AS relationship,
        TRIM(db.value) AS database_name
    FROM sample_data.stackoverflow_survey.survey_results r
    JOIN stg_survey_responses s ON r.ResponseId = s.ResponseId AND r.year = s.survey_year,
         LATERAL UNNEST(STRING_SPLIT(
             CASE WHEN r.DatabaseWantToWorkWith = 'NA' THEN NULL ELSE r.DatabaseWantToWorkWith END
         , ';')) AS db(value)
    WHERE r.DatabaseWantToWorkWith IS NOT NULL AND r.DatabaseWantToWorkWith != 'NA'
),

admired AS (
    SELECT
        s.ResponseId,
        s.survey_date,
        s.survey_year,
        s.country,
        s.age,
        s.experience_level,
        s.remote_work,
        s.org_size,
        s.comp_annual,
        s.dev_type,
        CASE WHEN s.dev_type LIKE '%Data engineer%' THEN true ELSE false END AS is_data_engineer,
        'Admired' AS relationship,
        TRIM(db.value) AS database_name
    FROM sample_data.stackoverflow_survey.survey_results r
    JOIN stg_survey_responses s ON r.ResponseId = s.ResponseId AND r.year = s.survey_year,
         LATERAL UNNEST(STRING_SPLIT(
             CASE WHEN r.DatabaseAdmired = 'NA' THEN NULL ELSE r.DatabaseAdmired END
         , ';')) AS db(value)
    WHERE r.DatabaseAdmired IS NOT NULL AND r.DatabaseAdmired != 'NA'
)

SELECT * FROM used
UNION ALL
SELECT * FROM desired
UNION ALL
SELECT * FROM admired
