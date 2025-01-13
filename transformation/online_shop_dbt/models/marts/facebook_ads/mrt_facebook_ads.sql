WITH
int_facebook_ads__insights AS (
    SELECT
        account_id,
        campaign_id,
        adset_id,
        ad_id,
        insight_date,
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
        _dlt_id,
        offsite_fb_pixel_add_to_cart_value,
        offsite_fb_pixel_purchase_value,
        offsite_fb_pixel_add_to_cart,
        offsite_fb_pixel_purchase
    FROM {{ ref('int_facebook_ads__insights')}}
),

campaigns AS (
    SELECT
        campaign_id,
        updated_time,
        created_time,
        name,
        status,
        effective_status,
        objective,
        start_time,
        stop_time,
        daily_budget
    FROM {{ref('stg_facebook_ads__campaigns')}}
),

ads AS (
    SELECT
        ad_id,
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
        targeting__targeting_optimization
    FROM {{ ref('stg_facebook_ads__ads')}}
),

-- join the dimensions to the insights fact table
joined AS (
    SELECT
        insights.*,
        ads.name AS ad_name,
        campaigns.name AS campaign_name
    FROM int_facebook_ads__insights AS insights
    LEFT JOIN campaigns
        ON insights.campaign_id = campaigns.campaign_id
    LEFT JOIN ads
        ON insights.ad_id = ads.ad_id
)

SELECT * FROM joined