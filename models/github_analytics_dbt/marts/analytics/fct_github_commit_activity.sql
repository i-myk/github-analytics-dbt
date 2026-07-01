select
    repository_id,
    author_name,
    author_email,
    commit_date,
    commit_year,
    commit_month,
    year_month,
    weekday_number,
    count(*) as commit_cnt

from {{ ref('int_github__commit_activity') }}

group by
    repository_id,
    author_name,
    author_email,
    commit_date,
    commit_year,
    commit_month,
    year_month,
    weekday_number