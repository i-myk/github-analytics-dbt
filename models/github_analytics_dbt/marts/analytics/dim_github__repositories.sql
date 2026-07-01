select
    repository_id,
    repository_name,
    full_name,
    owner_id,
    description,
    language,
    forks,
    created_at
from {{ ref('stg_github__repositories') }}