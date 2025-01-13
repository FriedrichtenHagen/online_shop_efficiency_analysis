WITH actions AS (
    SELECT
        action_type,
        COALESCE(CAST(value AS FLOAT64), 0) AS value,
        COALESCE(CAST(_7d_click AS FLOAT64), 0) AS _7d_click,
        _dlt_root_id,
        _dlt_parent_id,
        _dlt_list_idx,
        _dlt_id,
        COALESCE(CAST(_1d_view AS FLOAT64), 0) AS _1d_view
    FROM facebook_insights_data.facebook_insights__actions
)
/*
There are 35 actions available in this account:
post_engagement
page_engagement
video_view
onsite_web_app_view_content
onsite_web_view_content
view_content
omni_view_content
offsite_conversion.fb_pixel_view_content
web_in_store_purchase
omni_add_to_cart
omni_initiated_checkout
add_to_cart
onsite_web_app_add_to_cart
onsite_web_add_to_cart
offsite_conversion.fb_pixel_add_payment_info
onsite_web_purchase
onsite_web_app_purchase
purchase
onsite_web_initiate_checkout
add_payment_info
offsite_conversion.fb_pixel_add_to_cart
offsite_conversion.fb_pixel_initiate_checkout
offsite_conversion.fb_pixel_purchase
initiate_checkout
omni_purchase
landing_page_view
comment
like
link_click
post_reaction
onsite_conversion.post_save
post
search
offsite_conversion.fb_pixel_search
omni_search

most interesting:
    offsite_conversion.fb_pixel_add_to_cart
    offsite_conversion.fb_pixel_purchase
*/


SELECT * FROM actions



