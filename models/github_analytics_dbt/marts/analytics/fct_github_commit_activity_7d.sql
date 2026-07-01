with daily_commits as (
    select
        commit_date,
        sum(commit_cnt) as commit_cnt
    from {{ ref('fct_github_commit_activity') }}
    group by commit_date
),

calendar as (
    select day as commit_date
    from unnest(
        generate_date_array(
            (select min(commit_date) from daily_commits),
            (select max(commit_date) from daily_commits)
        )
    ) as day
),

daily_commits_filled as (
    select
        c.commit_date,
        coalesce(d.commit_cnt, 0) as commit_cnt
    from calendar as c
    left join daily_commits as d
        on c.commit_date = d.commit_date
),

final as (
    select
        commit_date,
        commit_cnt,
        avg(commit_cnt) over (
            order by commit_date
            rows between 6 preceding and current row
        ) as commit_cnt_7d_avg
    from daily_commits_filled
)

select *
from final
order by commit_date