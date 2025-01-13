WITH action_values AS (
    SELECT
        action_type,
        value,
        _7d_click,
        _dlt_root_id,
        _dlt_parent_id,
        _dlt_list_idx,
        _dlt_id,
        _1d_view
    FROM facebook_insights_data.facebook_insights__action_values
)

/*
There are 22 action values available in this account:
onsite_web_initiate_checkout
initiate_checkout
view_content
onsite_web_view_content
offsite_conversion.fb_pixel_view_content
omni_view_content
onsite_web_app_view_content
onsite_web_add_to_cart
onsite_web_app_add_to_cart
add_to_cart
omni_add_to_cart
offsite_conversion.fb_pixel_add_to_cart

*/


SELECT * FROM action_values




