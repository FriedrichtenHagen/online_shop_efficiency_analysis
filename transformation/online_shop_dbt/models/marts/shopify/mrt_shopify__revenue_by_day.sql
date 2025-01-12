WITH 
mrt_shopify__orders AS (
    SELECT
        order_id,
        customer_id,
        total_discounts,
        total_line_items_price,
        total_price,
        total_shipping_price,
        total_subtotal_price,
        total_tax,
        taxes_included,
        created_at,
        CAST(created_at AS DATE) AS created_at_date,
        cancelled_at,
        closed_at,
        processed_at,
        updated_at,
        -- discounts
        discount_code_code,
        -- there are different kinds of discounts. Shipping discounts are only subtracted from shipping!
        shipping_discount,
        line_item_discount,

        -- refunds
        refund_transactions_id,
        refund_transactions_amount,
        refund_transactions_created_at,
        refund_transaction_kind,
        refund_transactions_status,

        net_revenue,
        nth_order,
        new_customer
    FROM {{ ref('mrt_shopify__orders')}}
),

-- Klar associates the return to the date the order was placed, while Shopify to the day the return was logged.
aggregate_by_day AS (
    SELECT
       created_at_date,
       SUM(CASE WHEN new_customer = 0 THEN net_revenue ELSE 0 END) AS existing_customer_net_revenue,
       SUM(CASE WHEN new_customer = 1 THEN net_revenue ELSE 0 END) AS new_customer_net_revenue,
       SUM(net_revenue) AS net_revenue

    FROM mrt_shopify__orders
    GROUP BY 1
)

SELECT * FROM aggregate_by_day