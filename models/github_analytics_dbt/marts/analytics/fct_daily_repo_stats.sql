with repositories as (
    select *
    from {{ ref('int_github__repository_stats') }}
),

daily_stats as (
    select
        repository_name,
        created_date,
        coalesce(language, 'Unknown') as repo_language,
        count(*) as repo_count,
        sum(forks) as total_forks,
        round(avg(forks), 2) as avg_forks

    from repositories
    group by 
        repository_name,
        created_date,
        repo_language
)

select *
from daily_stats
order by created_date desc