WITH
insights AS (
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
        _dlt_id
    FROM {{ ref('stg_facebook_ads__facebook_insights')}}
),

-- the action values need to be grouped by _dlt_parent_id to fit the grain of the insights table
action_values AS (
    SELECT
        -- action_type,
        -- value,
        -- _7d_click,
        -- _dlt_root_id,
        _dlt_parent_id,
        -- _dlt_list_idx,
        -- _dlt_id,
        -- _1d_view,
        -- pivot actions
        SUM(CASE WHEN action_type = 'offsite_conversion.fb_pixel_add_to_cart' THEN _7d_click + _1d_view ELSE 0 END) AS offsite_fb_pixel_add_to_cart_value,
        SUM(CASE WHEN action_type = 'offsite_conversion.fb_pixel_purchase' THEN _7d_click + _1d_view ELSE 0 END) AS offsite_fb_pixel_purchase_value
    FROM {{ ref('stg_facebook_ads__action_values')}}
    -- we will focus on selected action types for now
    WHERE action_type IN ('offsite_conversion.fb_pixel_add_to_cart', 'offsite_conversion.fb_pixel_purchase')
    GROUP BY 1
),

-- the action values need to be grouped by _dlt_parent_id to fit the grain of the insights table
actions AS (
    SELECT        
        -- action_type,
        -- value,
        -- _7d_click,
        -- _dlt_root_id,
        _dlt_parent_id,
        -- _dlt_list_idx,
        -- _dlt_id,
        -- _1d_view,
        -- pivot actions
        SUM(CASE WHEN action_type = 'offsite_conversion.fb_pixel_add_to_cart' THEN _7d_click + _1d_view ELSE 0 END) AS offsite_fb_pixel_add_to_cart,
        SUM(CASE WHEN action_type = 'offsite_conversion.fb_pixel_purchase' THEN _7d_click + _1d_view ELSE 0 END) AS offsite_fb_pixel_purchase,
    FROM {{ ref('stg_facebook_ads__actions')}}
    -- we will focus on selected action types for now
    WHERE action_type IN ('offsite_conversion.fb_pixel_add_to_cart', 'offsite_conversion.fb_pixel_purchase')
    GROUP BY 1
),

-- here the insights, actions and action value tables are denormalized
-- dlt has normalized these tables before loading
-- this point the grain is ad_id, insight_date (one row per ad per day)
denormalized AS (
    SELECT
        insights.account_id,
        insights.campaign_id,
        insights.adset_id,
        insights.ad_id,
        insights.insight_date,
        insights.reach,
        insights.impressions,
        insights.frequency,
        insights.clicks,
        insights.unique_clicks,
        insights.ctr,
        insights.unique_ctr,
        insights.cpc,
        insights.cpm,
        insights.cpp,
        insights.spend,
        insights._dlt_load_id,
        insights._dlt_id,
        COALESCE(action_values.offsite_fb_pixel_add_to_cart_value, 0) AS offsite_fb_pixel_add_to_cart_value,
        COALESCE(action_values.offsite_fb_pixel_purchase_value, 0) AS offsite_fb_pixel_purchase_value,
        COALESCE(actions.offsite_fb_pixel_add_to_cart, 0) AS offsite_fb_pixel_add_to_cart,
        COALESCE(actions.offsite_fb_pixel_purchase, 0) AS offsite_fb_pixel_purchase
    FROM insights
    LEFT JOIN action_values
        ON insights._dlt_id = action_values._dlt_parent_id
    LEFT JOIN actions
        ON insights._dlt_id = actions._dlt_parent_id
)

SELECT * FROM denormalized
