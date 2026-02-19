-- One row per respondent per technology — for technology-level analytics
-- Unnests semicolon-separated columns into individual rows

WITH languages AS (
    SELECT
        ResponseId,
        survey_date,
        country,
        age,
        experience_level,
        remote_work,
        org_size,
        comp_annual,
        'Language' AS technology_category,
        TRIM(lang.value) AS technology_name
    FROM stg_survey_responses,
         LATERAL UNNEST(STRING_SPLIT(languages_raw, ';')) AS lang(value)
    WHERE languages_raw IS NOT NULL
),

databases AS (
    SELECT
        ResponseId,
        survey_date,
        country,
        age,
        experience_level,
        remote_work,
        org_size,
        comp_annual,
        'Database' AS technology_category,
        TRIM(db.value) AS technology_name
    FROM stg_survey_responses,
         LATERAL UNNEST(STRING_SPLIT(databases_raw, ';')) AS db(value)
    WHERE databases_raw IS NOT NULL
),

platforms AS (
    SELECT
        ResponseId,
        survey_date,
        country,
        age,
        experience_level,
        remote_work,
        org_size,
        comp_annual,
        'Platform' AS technology_category,
        TRIM(plat.value) AS technology_name
    FROM stg_survey_responses,
         LATERAL UNNEST(STRING_SPLIT(platforms_raw, ';')) AS plat(value)
    WHERE platforms_raw IS NOT NULL
),

webframeworks AS (
    SELECT
        ResponseId,
        survey_date,
        country,
        age,
        experience_level,
        remote_work,
        org_size,
        comp_annual,
        'Web Framework' AS technology_category,
        TRIM(wf.value) AS technology_name
    FROM stg_survey_responses,
         LATERAL UNNEST(STRING_SPLIT(webframeworks_raw, ';')) AS wf(value)
    WHERE webframeworks_raw IS NOT NULL
)

SELECT * FROM languages
UNION ALL
SELECT * FROM databases
UNION ALL
SELECT * FROM platforms
UNION ALL
SELECT * FROM webframeworks
