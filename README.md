# GitHub Analytics dbt Project

An Analytics Engineering project built with **dbt Cloud** and **Google BigQuery**.

This project demonstrates how to transform raw GitHub data into clean, reusable analytical models using a layered dbt architecture. The pipeline follows analytics engineering best practices by separating transformations into staging, intermediate, and marts layers while applying data quality tests and documentation.

The final models are optimized for reporting and analytics, providing reliable datasets for repository activity, commit trends, and user insights.

The project is developed in **dbt Cloud** with **GitHub integration**, enabling version-controlled development and seamless deployment of model updates through Git commits.


## Tech Stack

- **Data Warehouse:** Google BigQuery
- **Transformation:** dbt Cloud
- **Language:** SQL
- **Data Ingestion:** Fivetran
- **Version Control:** Git & GitHub
- **Source Data:** GitHub API


## Business Metrics

The analytical models provide repository performance insights through the following KPIs:

- **Total Commits** – Overall development activity.
- **Active Contributors** – Number of developers contributing.
- **Repository Activity** – Daily repository engagement.
- **Daily Commits** – Commits by date.
- **7-Day Moving Average** – Smooths daily fluctuations to identify trends.
- **Repository Performance** – Overall repository health and activity.


## Architecture

The dbt project follows a layered architecture that separates transformations into staging, intermediate, and marts layers. This approach improves modularity, maintainability, and reusability of analytical models.


![Architecture](images/architecture.png)


```

### Layer Description

| Layer | Purpose | Materialization |
|--------|---------|-----------------|
| **Staging** | Cleans and standardizes raw GitHub data | View |
| **Intermediate** | Applies reusable business logic and transformations | View |
| **Marts** | Creates business-ready fact and dimension tables | Table |



## Project Structure

The project is organized using dbt best practices with separate staging, intermediate, and marts layers.

```text
.
├── macros/
├── models/
│   └── github_analytics_dbt/
│       ├── staging/
│       │   └── github/
│       │       ├── _github__sources.yml
│       │       ├── _github__models.yml
│       │       ├── stg_github__commit.sql
│       │       ├── stg_github__repositories.sql
│       │       └── stg_github__user.sql
│       │
│       ├── intermediate/
│       │   └── github/
│       │       ├── _intermediate__models.yml
│       │       ├── int_github__commit_activity.sql
│       │       └── int_github__repository_stats.sql
│       │
│       └── marts/
│           └── analytics/
│               ├── _analytics__models.yml
│               ├── dim_github__repositories.sql
│               ├── dim_github__user.sql
│               ├── fct_daily_repo_stats.sql
│               ├── fct_github_commit_activity.sql
│               ├── fct_github_commit_activity_7d.sql
│               └── fct_repo_activity_daily.sql
│
├── seeds/
├── snapshots/
├── dbt_project.yml
└── README.md
```


## Data Models



### Staging Layer


The staging layer standardizes raw GitHub data from BigQuery sources. These models clean column names, select relevant fields, and prepare raw data for downstream transformations.


| Model | Purpose |
|------|---------|
| `stg_github__repositories` | Standardizes repository metadata |
| `stg_github__commit` | Standardizes commit records |
| `stg_github__user` | Standardizes GitHub user data |



### Intermediate Layer


The intermediate layer contains reusable transformation logic used by final marts.


| Model | Purpose |
|------|---------|
| `int_github__commit_activity` | Prepares commit activity data for fact models |
| `int_github__repository_stats` | Prepares repository statistics for downstream marts |



### Marts Layer


The marts layer contains final analytics-ready models used for reporting.


| Model | Type | Purpose |
|------|------|---------|
| `dim_github__repositories` | Dimension | Repository attributes |
| `dim_github__user` | Dimension | GitHub user attributes |
| `fct_daily_repo_stats` | Fact | Daily repository-level statistics |
| `fct_github_commit_activity` | Fact | Commit activity by repository, author, and date |
| `fct_github_commit_activity_7d` | Fact | Seven-day rolling commit activity |
| `fct_repo_activity_daily` | Fact | Daily repository activity metrics |



# Step 1: Data Ingestion with Fivetran

Fivetran was used to automate data ingestion from the GitHub API into Google BigQuery.

The GitHub connector was configured to authenticate with GitHub and perform scheduled incremental synchronizations, automatically loading repository metadata, commits, contributors, issues, pull requests, and other GitHub data into BigQuery.

**Only raw source data was ingested through Fivetran.** 
All transformations, testing, documentation, and analytics models were implemented separately in dbt.

---

## GitHub Connector Configuration

The GitHub connector synchronizes repository data from the GitHub API into Google BigQuery.

**Configuration includes:**

- Source: GitHub API
- Destination: Google BigQuery
- Incremental synchronization
- Scheduled automatic sync
- Raw data ingestion only

**Screenshot: GitHub Connector Configuration**

![GitHub Connector Configuration](images/fivetran_connection.png)

---

## Why Quickstart Transformations Were Not Used

Fivetran provides **Quickstart Transformations**, which automatically generate pre-built staging and reporting models for supported data sources.

For this project, these transformations were intentionally **not used**.

Instead, only the **raw GitHub data** was loaded into BigQuery, while the complete transformation layer was developed manually in **dbt**.

This approach provides full control over the transformation logic and demonstrates modern Analytics Engineering best practices by implementing a custom three-layer architecture:

- **Staging** – cleans and standardizes raw source data
- **Intermediate** – applies reusable business logic and transformations
- **Marts** – creates analytics-ready fact and dimension models for reporting

Building these layers manually makes the project easier to understand, test, maintain, and scale while showcasing the full Analytics Engineering workflow.



# Step 2: BigQuery Data Warehouse

After configuring the GitHub connector in Fivetran, all repository data is automatically synchronized into Google BigQuery.

BigQuery serves as the centralized cloud data warehouse where raw GitHub data is stored before being transformed with dbt.

Following modern ELT architecture, no business logic or data transformations are performed during data ingestion. The raw data is preserved in BigQuery, while all cleaning, modeling, testing, and documentation are implemented later in dbt.

---

## BigQuery Dataset

The project uses a dedicated BigQuery dataset to store raw GitHub data loaded by Fivetran.

| Dataset | Purpose |
|----------|---------|
| **github_data** | Stores raw GitHub data synchronized directly from the GitHub API through Fivetran. |

---

## Raw GitHub Tables

The dataset contains multiple GitHub entities automatically synchronized by Fivetran, including:

- repository
- commit
- user
- issue
- pull_request
- branch_commit_relation
- commit_file
- commit_parent
- repository_language
- repository_clone
- repo_collaborator
- issue_closed_history
- issue_merged
- issue_referenced
- user_email
- page_view

These tables preserve the original GitHub schema and serve as the foundation for all downstream dbt models.

---

## Data Loading Strategy

Fivetran performs automatic incremental synchronization from the GitHub API into BigQuery.

The project intentionally stores only **raw source data** inside BigQuery.

All business logic, data cleaning, transformations, testing, documentation, and analytics models are implemented in **dbt**, providing a clear separation between data ingestion and data transformation.

This architecture follows modern Analytics Engineering best practices and makes the pipeline easier to maintain, test, and scale.

---

## Data Flow

```text
GitHub API
      ↓
Fivetran
      ↓
BigQuery (github_data)
      ↓
dbt Staging Models
      ↓
dbt Intermediate Models
      ↓
dbt Mart Models
      ↓
Looker Studio Dashboard
```

---

## Why BigQuery?

Google BigQuery was selected because it provides:

- Serverless cloud data warehouse
- High-performance analytical queries
- Automatic scalability
- Native integration with Fivetran and dbt
- Reliable foundation for Analytics Engineering workflows

---

## Screenshot: BigQuery Dataset

The `github_data` dataset contains raw GitHub tables automatically synchronized from the GitHub API. 
These tables remain unchanged and serve as the source layer for all dbt transformations.


![BigQuery Dataset](images/bigquery_raw_tables.png)

---



## Screenshot: dbt Models in BigQuery

After the raw GitHub data is loaded into BigQuery, dbt builds analytics-ready models inside the `dbt_imykoliv` dataset.

The models are organized into three logical layers:

- **Staging (`stg_`)** – cleans and standardizes raw GitHub data.
- **Intermediate (`int_`)** – applies reusable business logic and transformations.
- **Marts (`dim_` and `fct_`)** – creates analytics-ready dimension and fact tables used for reporting.

This layered approach follows dbt best practices and provides a clean semantic layer for BI reporting in Looker Studio.

![dbt Models in BigQuery](images/dbt_bigquery_models.png)




# Step 3: dbt Data Transformation

dbt was used to transform raw GitHub data into clean, tested, and analytics-ready models following Analytics Engineering best practices.

The project implements a layered architecture that separates data transformations into staging, intermediate, and marts layers, improving modularity, maintainability, and scalability.

## Data Quality & Testing

Built-in dbt tests were implemented to validate critical business keys and ensure data reliability.

Implemented tests:

- `unique`
- `not_null`

### Tested Models

| Model | Tested Columns |
|--------|----------------|
| stg_github__repositories | repository_id |
| stg_github__user | user_id |
| stg_github__commit | commit_sha |
| dim_github__repositories | repository_id |
| dim_github__user | user_id |
| fct_daily_repo_stats | created_date |

---

## Materialization Strategy

Different materializations were selected depending on the purpose of each layer.

| Layer | Materialization | Purpose |
|--------|-----------------|---------|
| Staging | View | Lightweight cleaning and standardization |
| Intermediate | View | Reusable business logic |
| Marts | Table | Analytics-ready reporting models |

This approach minimizes storage costs while optimizing performance for reporting and BI workloads.

---

## dbt Lineage (DAG)

The lineage graph illustrates dependencies between source tables, staging models, intermediate transformations, and final dimension and fact models.

It provides full visibility into the transformation pipeline and demonstrates how raw GitHub data flows through each modeling layer.

**Screenshot:** dbt Lineage

![dbt Lineage](images/dbt_lineage.png)





---


## Dashboard Preview

The final dbt mart models are used in Looker Studio to visualize repository activity, commit trends, contributors, and repository performance.


![GitHub Analytics Dashboard](images/looker_dashboard.png)

## 🚀 Live Dashboard

[Open Looker Studio Dashboard](https://datastudio.google.com/reporting/7478f0af-71f2-464e-accb-4e4e010b19a9)**



## Key Features


- Layered dbt architecture (Staging → Intermediate → Marts)
- Modular SQL transformations
- Star schema data modeling
- Data quality testing with dbt
- YAML model documentation
- Google BigQuery integration
- GitHub data transformation pipeline
- Analytics-ready fact and dimension models


## Future Improvements

- Implement incremental models for large datasets
- Add snapshot models to track historical changes
- Expand data quality tests
- Integrate CI/CD with GitHub Actions
- Add dbt exposures and metrics


## Author

Created by **Igor Mykoliv** as part of an Analytics Engineering portfolio demonstrating dbt and BigQuery best practices.
