with source as
(select * from {{ source('github_data', 'repository') }}
),
cleaned as (
    select
        -- Primary key
        id as repository_id,
        
        -- Attributes
        name as repository_name,
        full_name,
        owner_id, 
        description,
        language,
        
        -- Metrics
        forks_count as forks,
        
        -- Dates
        created_at
    from source
    where id is not null
)
select * from cleaned

