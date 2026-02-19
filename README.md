# MotherDuck + Rill: Stack Overflow Developer Survey

Companion repo for **[MotherDuck & Rill: Agentic Workflows for BI](https://sspaeti.com/blog/motherduck-rill-agentic-workflows-bi/)**. Clone, set one env var, run `rill start` — enterprise-grade analytics in minutes.

Analyzes **50k+ professional developer responses** from the 2024 Stack Overflow survey using data already available in every free MotherDuck account (`sample_data.stackoverflow_survey`). Zero data pipeline needed.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/sspaeti/motherduck-rill.git
cd motherduck-rill

# 2. Configure (get a free token at https://motherduck.com → Settings → Access Tokens)
cp .env.example .env
# Edit .env → set connector.motherduck.token=your_token

# 3. Run
rill start
```

Open [http://localhost:9009](http://localhost:9009) and explore the dashboard.

## What You Get

- **Survey Overview Dashboard** — KPIs, top languages/databases, compensation by experience, remote work distribution, AI adoption
- **Technology Landscape Explore** — Interactive pivot across languages, databases, platforms, and frameworks
- **Developer Insights Explore** — Slice compensation, remote work, and demographics by country, experience, and more

## Architecture

```
motherduck-rill/
├── rill.yaml                          # Project config (olap_connector: motherduck)
├── connectors/
│   └── motherduck.yaml                # MotherDuck connection (DuckDB driver)
├── models/
│   ├── stg_survey_responses.sql       # Staging: clean, cast, filter 2024 pros
│   ├── technology_usage.sql           # Unnest: one row per respondent × tech
│   └── developer_profiles.sql         # Profiles: one row per employed dev
├── metrics/
│   ├── survey_metrics.yaml            # Compensation, remote %, demographics
│   └── technology_metrics.yaml        # Tech adoption, comp by technology
├── explores/
│   ├── technology_landscape.yaml      # Interactive tech pivot
│   └── developer_insights.yaml        # Interactive workforce pivot
├── dashboards/
│   └── survey_overview.yaml           # Executive canvas dashboard
└── theme.yaml                         # Stack Overflow brand colors
```

## Design Decisions

- **Pure SQL + YAML** — No Python, no dlt, no orchestrator. BI-as-code at its most minimal.
- **MotherDuck sample_data** — Every free account ships with the Stack Overflow survey. Zero ingestion.
- **2024 professionals only** — `stg_survey_responses` filters to `year='2024'` and `MainBranch='I am a developer by profession'` (~50k rows) for focused analysis.
- **Two grains** — `developer_profiles` (1 row/person) for accurate comp stats; `technology_usage` (1 row/person/tech) for adoption metrics.
- **NA → NULL** — The survey uses string `"NA"` for missing values; staging model converts them to proper NULLs.

## Requirements

- [Rill](https://docs.rilldata.com/install) (v0.50+)
- Free [MotherDuck](https://motherduck.com) account

## Deploy to Rill Cloud

```bash
rill deploy
```

## License

MIT
