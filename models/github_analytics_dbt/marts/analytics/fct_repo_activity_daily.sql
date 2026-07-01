with daily_commits as (

    select
        author_name,
        date(committer_date) as stat_date,
        count(*) as commit_count

    from {{ ref('stg_github__commit') }}

    where author_name is not null

    group by 
        author_name,
        stat_date
)

select *

from daily_commits

order by stat_date desc
