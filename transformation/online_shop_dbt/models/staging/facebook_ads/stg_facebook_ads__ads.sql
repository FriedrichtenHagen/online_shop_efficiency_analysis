WITH ads AS (
    SELECT
        id AS ad_id,
        adset_id,
        campaign_id,
        creative__id,
        updated_time,
        created_time,
        name,
        status,
        effective_status,
        targeting__age_max,
        targeting__age_min,
        targeting__targeting_automation__advantage_audience,
        _dlt_load_id,
        _dlt_id,
        targeting__targeting_optimization
    FROM facebook_ads_dimensions.ads
)

SELECT * FROM ads