select
    repository_id,
    author_name,
    author_email,
    date(committer_date) as commit_date,
    extract(year from committer_date) as commit_year,
    extract(month from committer_date) as commit_month,
    format_date('%Y-%m', date(committer_date)) as year_month,
    extract(dayofweek from committer_date) as weekday_number

from {{ ref('stg_github__commit') }}

where author_name is not null