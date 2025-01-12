WITH
stg_shopify__orders AS (
    SELECT
        order_id,
        customer_id,
        total_discounts,
        total_line_items_price,
        total_price,
        total_shipping_price,
        total_subtotal_price,
        total_tax,
    
        -- order_adjustment_amount,
        -- order_adjustment_id,
        -- order_adjustment_uid,
        -- order_adjustment_kind,
        -- order_adjustment_reason,
        -- order_adjustment_refund_id,
        -- order_adjustment_refund_uid,
        -- order_adjustment_tax_amount,

        -- line item level is ignored for now       
        -- refund_line_item_created_at,
        -- refund_line_item_order_line_item_id,
        -- refund_line_item_processed_at,
        -- refund_line_item_quantity,
        -- refund_line_item_refund_id,
        -- refund_line_item_refund_line_item_id,
        -- refund_line_item_restock,
        -- refund_line_item_restock_type,

        -- refunds
        refund_transactions_id,
        refund_transactions_amount,
        refund_transactions_created_at,
        refund_transactions_kind,
        refund_transactions_status
    FROM {{ ref('stg_shopify__orders') }}
),

extract_refunds AS (
    SELECT
        order_id,
        customer_id,
        -- just for debugging
        total_discounts,
        total_line_items_price,
        total_price,
        total_shipping_price,
        total_subtotal_price,
        total_tax,
        -- refunds
        CAST(REPLACE(REPLACE(refund_transactions_id, '[', ''), ']', '') AS STRING) AS refund_transactions_id,
        CAST(REPLACE(REPLACE(refund_transactions_amount, '[', ''), ']', '') AS STRING) AS refund_transactions_amount,
        CAST(REPLACE(REPLACE(REPLACE(refund_transactions_created_at, '[', ''), ']', ''),  "'", '') AS STRING) AS refund_transactions_created_at,
        CAST(REPLACE(REPLACE(REPLACE(refund_transactions_kind, '[', ''), ']', ''), "'", '') AS STRING) AS refund_transactions_kind,
        CAST(REPLACE(REPLACE(REPLACE(refund_transactions_status, '[', ''), ']', ''), "'", '') AS STRING) AS refund_transactions_status
    FROM stg_shopify__orders
)

SELECT * FROM extract_refunds
-- exclude non refunds
WHERE refund_transactions_id != ''
