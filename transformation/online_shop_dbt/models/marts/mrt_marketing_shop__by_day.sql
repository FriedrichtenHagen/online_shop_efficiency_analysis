WITH
shopify AS (
    SELECT
        created_at_date,
        existing_customer_net_revenue,
        new_customer_net_revenue,
        net_revenue,
        new_customer_orders,
        orders
    FROM {{ ref('mrt_shopify__revenue_by_day')}}
),

facebook_ads AS (
    SELECT
        insight_date,
        SUM(reach) AS reach,
        SUM(impressions) AS impressions,
        SUM(frequency) AS frequency,
        SUM(clicks) AS clicks,
        SUM(unique_clicks) AS unique_clicks,
        SUM(spend) AS spend,
        SUM(offsite_fb_pixel_add_to_cart_value) AS offsite_fb_pixel_add_to_cart_value,
        SUM(offsite_fb_pixel_purchase_value) AS offsite_fb_pixel_purchase_value,
        SUM(offsite_fb_pixel_add_to_cart) AS offsite_fb_pixel_add_to_cart,
        SUM(offsite_fb_pixel_purchase) AS offsite_fb_pixel_purchase
    FROM {{ ref('mrt_facebook_ads')}}
    GROUP BY 1
),

joined AS (
    SELECT
        COALESCE(shopify.created_at_date, facebook_ads.insight_date) AS created_at_date,
        COALESCE(shopify.existing_customer_net_revenue, 0) AS existing_customer_net_revenue,
        COALESCE(shopify.new_customer_net_revenue, 0) AS new_customer_net_revenue,
        COALESCE(shopify.net_revenue, 0) AS net_revenue,
        COALESCE(shopify.new_customer_orders, 0) AS new_customer_orders,
        COALESCE(shopify.orders, 0) AS orders,
        
        COALESCE(facebook_ads.reach, 0) AS reach,
        COALESCE(facebook_ads.impressions, 0) AS impressions,
        COALESCE(facebook_ads.frequency, 0) AS frequency,
        COALESCE(facebook_ads.clicks, 0) AS clicks,
        COALESCE(facebook_ads.unique_clicks, 0) AS unique_clicks,
        COALESCE(facebook_ads.spend, 0) AS spend,
        COALESCE(facebook_ads.offsite_fb_pixel_add_to_cart_value, 0) AS offsite_fb_pixel_add_to_cart_value,
        COALESCE(facebook_ads.offsite_fb_pixel_purchase_value, 0) AS offsite_fb_pixel_purchase_value,
        COALESCE(facebook_ads.offsite_fb_pixel_add_to_cart, 0) AS offsite_fb_pixel_add_to_cart,
        COALESCE(facebook_ads.offsite_fb_pixel_purchase, 0) AS offsite_fb_pixel_purchase
    FROM shopify
    FULL JOIN facebook_ads
        ON shopify.created_at_date = facebook_ads.insight_date
)

SELECT * FROM joined