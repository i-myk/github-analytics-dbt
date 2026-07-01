select
    user_id,
    username,
    display_name,
    company,
    location,
    bio,
    created_at,
    updated_at
from {{ ref('stg_github__user') }}
