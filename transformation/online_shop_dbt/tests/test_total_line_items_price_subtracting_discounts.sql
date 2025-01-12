SELECT 
    order_id,
    total_line_items_price,
    total_subtotal_price,
    line_item_discount
FROM {{ ref('mrt_shopify__orders')}}
WHERE ROUND((total_line_items_price - line_item_discount), 2) != total_subtotal_price