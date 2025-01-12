SELECT
    order_id,
    total_price,
    total_line_items_price,
    total_discounts,
    total_shipping_price,
    total_tax,
    taxes_included
FROM {{ ref('mrt_shopify__orders')}}
WHERE ROUND(
    (total_line_items_price - total_discounts + total_shipping_price + 
        (CASE WHEN taxes_included IS TRUE THEN 0 ELSE total_tax END) -- exclude the taxes if they are already included
    )
    , 2) 
    != total_price