WITH facebook_insights AS (
    SELECT
        account_id,
        campaign_id,
        adset_id,
        ad_id,
        CAST(date_start AS DATE) AS insight_date,
        -- date_stop, -- both date field always contain the same data
        reach,
        impressions,
        frequency,
        clicks,
        unique_clicks,
        ctr,
        unique_ctr,
        cpc,
        cpm,
        cpp,
        spend,
        _dlt_load_id,
        _dlt_id
    FROM facebook_insights_data.facebook_insights
)

SELECT * FROM facebook_insights



