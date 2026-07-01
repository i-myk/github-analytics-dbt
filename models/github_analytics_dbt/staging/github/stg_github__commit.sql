with source as (
    select *
    from {{ source('github_data', 'commit') }}
),

cleaned as (
    select
        sha as commit_sha,
        repository_id,

        -- author info
        author_name,
        author_email,
        author_date,

        -- committer info
        committer_name,
        committer_email,
        committer_date,

        -- content
        message

    from source
    where sha is not null
)

select * from cleaned