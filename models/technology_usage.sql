-- One row per respondent per technology — for technology-level analytics
-- Unnests semicolon-separated columns into individual rows

WITH languages AS (
    SELECT
        ResponseId,
        survey_date,
        survey_year,
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
        survey_year,
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
        survey_year,
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
        survey_year,
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
),

editors AS (
    SELECT
        ResponseId,
        survey_date,
        survey_year,
        country,
        age,
        experience_level,
        remote_work,
        org_size,
        comp_annual,
        'Editor/IDE' AS technology_category,
        TRIM(ed.value) AS technology_name
    FROM stg_survey_responses,
         LATERAL UNNEST(STRING_SPLIT(editors_raw, ';')) AS ed(value)
    WHERE editors_raw IS NOT NULL
),

operating_systems AS (
    SELECT
        ResponseId,
        survey_date,
        survey_year,
        country,
        age,
        experience_level,
        remote_work,
        org_size,
        comp_annual,
        'Operating System' AS technology_category,
        TRIM(os.value) AS technology_name
    FROM stg_survey_responses,
         LATERAL UNNEST(STRING_SPLIT(os_raw, ';')) AS os(value)
    WHERE os_raw IS NOT NULL
)

SELECT * FROM languages
UNION ALL
SELECT * FROM databases
UNION ALL
SELECT * FROM platforms
UNION ALL
SELECT * FROM webframeworks
UNION ALL
SELECT * FROM editors
UNION ALL
SELECT * FROM operating_systems
