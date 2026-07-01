with 

source as (

    select * from {{ source('github_data', 'commit') }}

),

renamed as (

    select
        sha,
        repository_id,
        committer_date,
        author_email,
        author_name,
        author_date,
        committer_email,
        committer_name,
        message,
        _fivetran_synced

    from source

)

select * from renamed