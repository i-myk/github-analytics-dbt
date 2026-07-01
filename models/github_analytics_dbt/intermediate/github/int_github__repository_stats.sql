select
    repository_id,
    repository_name,
    full_name,
    owner_id,
    description,
    language,
    forks,
    date(created_at) as created_date

from {{ ref('stg_github__repositories') }}

where repository_id is not null