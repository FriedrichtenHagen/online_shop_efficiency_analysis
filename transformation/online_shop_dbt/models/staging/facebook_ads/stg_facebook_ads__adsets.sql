WITH adsets AS (
    SELECT
        id AS adset_id,
        updated_time,
        created_time,

        name,
        status,
        effective_status,
        campaign_id,
        start_time,
        end_time,
        optimization_goal,
        promoted_object__page_id,
        billing_event,
        targeting__age_max,
        targeting__age_min,
        targeting__targeting_automation__advantage_audience,
        _dlt_load_id,
        _dlt_id,
        promoted_object__pixel_id,
        promoted_object__custom_event_type,
        daily_budget,
        lifetime_budget,
        bid_strategy,
        targeting__targeting_optimization
    FROM facebook_ads_dimensions.ad_sets
)

SELECT * FROM adsets



