select
    c.repository_id,
    r.repository_name,
    c.author_name,
    c.author_email,
    c.commit_date,
    c.commit_year,
    c.commit_month,
    c.year_month,
    c.weekday_number,
    count(*) as commit_cnt

from {{ ref('int_github__commit_activity') }} c

left join {{ ref('dim_github__repositories') }} r
    on c.repository_id = r.repository_id

group by
    c.repository_id,
    r.repository_name,
    c.author_name,
    c.author_email,
    c.commit_date,
    c.commit_year,
    c.commit_month,
    c.year_month,
    c.weekday_number