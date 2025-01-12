SELECT
    order_id,
    total_discounts,
    shipping_discount,
    line_item_discount
FROM {{ ref('mrt_shopify__orders')}}
WHERE shipping_discount + line_item_discount != total_discounts
OR total_discounts IS NULL
OR shipping_discount IS NULL
OR line_item_discount IS NULL
