WITH campaigns AS (
    SELECT
        CAST(id AS INT64) AS campaign_id,
        updated_time,
        created_time,
        name,
        status,
        effective_status,
        objective,
        start_time,
        stop_time,
        daily_budget,
        _dlt_load_id,
        _dlt_id
    FROM facebook_ads_dimensions.campaigns
)

SELECT * FROM campaigns



