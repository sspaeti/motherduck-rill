-- Staging model: clean and type-cast 2024 Stack Overflow survey responses
-- Source: sample_data.stackoverflow_survey.survey_results (available in every MotherDuck account)

SELECT
    ResponseId,

    -- Synthetic date for Rill timeseries (single-year snapshot)
    MAKE_DATE(2024, 1, 1) AS survey_date,

    Country,

    -- Simplify age brackets: "25-34 years old" → "25-34"
    REPLACE(Age, ' years old', '') AS age,

    -- Normalize education levels
    CASE
        WHEN EdLevel LIKE 'Bachelor%'                       THEN 'Bachelors'
        WHEN EdLevel LIKE 'Master%'                         THEN 'Masters'
        WHEN EdLevel LIKE '%doctoral%' OR EdLevel LIKE '%Professional%' THEN 'Doctorate'
        WHEN EdLevel LIKE 'Some college%'                   THEN 'Some College'
        WHEN EdLevel LIKE 'Associate%'                      THEN 'Associates'
        WHEN EdLevel LIKE 'Secondary%'                      THEN 'High School'
        WHEN EdLevel LIKE '%without%'                       THEN 'Self-Taught'
        ELSE NULL
    END AS education_level,

    -- Remote work (filter out 'NA')
    CASE WHEN RemoteWork = 'NA' THEN NULL ELSE RemoteWork END AS remote_work,

    -- Employment (semicolon-separated, keep as-is for filtering)
    CASE WHEN Employment = 'NA' THEN NULL ELSE Employment END AS employment,

    -- Developer type
    CASE WHEN DevType = 'NA' THEN NULL ELSE DevType END AS dev_type,

    -- Organization size
    CASE WHEN OrgSize = 'NA' THEN NULL ELSE OrgSize END AS org_size,

    -- Compensation (cast from VARCHAR to DOUBLE)
    TRY_CAST(ConvertedCompYearly AS DOUBLE) AS comp_annual,

    -- Compensation bands
    CASE
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) IS NULL       THEN NULL
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) < 30000       THEN '<$30k'
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) < 50000       THEN '$30k-$50k'
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) < 75000       THEN '$50k-$75k'
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) < 100000      THEN '$75k-$100k'
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) < 150000      THEN '$100k-$150k'
        WHEN TRY_CAST(ConvertedCompYearly AS DOUBLE) < 200000      THEN '$150k-$200k'
        ELSE '$200k+'
    END AS comp_band,

    -- Work experience (cast from VARCHAR to INTEGER)
    TRY_CAST(WorkExp AS INTEGER) AS work_exp,

    -- Experience level derived from work experience
    CASE
        WHEN TRY_CAST(WorkExp AS INTEGER) IS NULL  THEN NULL
        WHEN TRY_CAST(WorkExp AS INTEGER) <= 2     THEN 'Junior (0-2)'
        WHEN TRY_CAST(WorkExp AS INTEGER) <= 5     THEN 'Mid (3-5)'
        WHEN TRY_CAST(WorkExp AS INTEGER) <= 10    THEN 'Senior (6-10)'
        WHEN TRY_CAST(WorkExp AS INTEGER) <= 20    THEN 'Staff (11-20)'
        ELSE 'Principal (20+)'
    END AS experience_level,

    -- AI columns
    CASE WHEN AISelect = 'NA' THEN NULL ELSE AISelect END AS ai_usage,
    CASE WHEN AISent  = 'NA' THEN NULL ELSE AISent  END AS ai_sentiment,
    CASE WHEN AIAcc   = 'NA' THEN NULL ELSE AIAcc   END AS ai_accuracy,

    -- Raw tech columns (kept for counting / unnesting downstream)
    CASE WHEN LanguageHaveWorkedWith  = 'NA' THEN NULL ELSE LanguageHaveWorkedWith  END AS languages_raw,
    CASE WHEN DatabaseHaveWorkedWith  = 'NA' THEN NULL ELSE DatabaseHaveWorkedWith  END AS databases_raw,
    CASE WHEN PlatformHaveWorkedWith  = 'NA' THEN NULL ELSE PlatformHaveWorkedWith  END AS platforms_raw,
    CASE WHEN WebframeHaveWorkedWith  = 'NA' THEN NULL ELSE WebframeHaveWorkedWith  END AS webframeworks_raw

FROM sample_data.stackoverflow_survey.survey_results
WHERE year = '2024'
  AND MainBranch = 'I am a developer by profession'
