WITH orders AS (
    SELECT
        order_id,
        customer_id,
        total_discounts,
        total_line_items_price,
        total_price, -- total_price is what the customer pays
        total_shipping_price,
        total_subtotal_price,
        total_tax,

        created_at,
        cancelled_at,
        closed_at,
        processed_at,
        updated_at,
        discount_application_allocation_method,
        discount_application_code,
        discount_application_target_selection,
        discount_application_target_type,
        discount_application_type,
        discount_application_value,
        discount_application_value_type,
        discount_application_title,
        discount_application_description,
        discount_code_amount,
        discount_code_code,
        discount_code_type,
        landing_site,
        base_url,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        fbclid,
        campaign_id,
        order_adjustment_amount,
        order_adjustment_id,
        order_adjustment_uid,
        order_adjustment_kind,
        order_adjustment_reason,
        order_adjustment_refund_id,
        order_adjustment_refund_uid,
        order_adjustment_tax_amount,
        payment_gateway_names,
        presentment_currency,
        referring_site,
        refund_line_item_created_at,
        refund_line_item_order_line_item_id,
        refund_line_item_processed_at,
        refund_line_item_quantity,
        refund_line_item_refund_id,
        refund_line_item_refund_line_item_id,
        refund_line_item_restock,
        refund_line_item_restock_type,
        refund_transactions_id,
        refund_transactions_amount,
        refund_transactions_created_at,
        refund_transactions_kind,
        refund_transactions_status,
        shipping_line_discount_allocations_index,
        shipping_line_discount_amount,
        shipping_line_discounted_price,
        shipping_line_id,
        shipping_line_uid,
        shipping_line_price,
        shipping_line_source,
        shipping_line_tax_lines_price,
        shipping_line_tax_lines_rate,
        shipping_line_tax_lines_title,
        shipping_line_title,
        tax_line_price,
        tax_line_rate,
        tax_line_title,
        taxes_included,
        test
    FROM {{ ref('int_shopify__orders')}}
),

-- if discount_application_target_type = shipping_line, then the discount is only subtracted from the shipping!
discounts AS (
    SELECT
        order_id,
        discount_application_target_type,
        discount_application_allocation_method,
        discount_application_code,
        discount_application_target_selection,
        discount_application_type,
        discount_application_value,

        discount_application_value_type,
        discount_application_title,
        discount_application_description,
        discount_code_code,
        discount_code_type,
        discount_code_amount,
    FROM {{ ref('int_shopify__order_discount')}}
),

refunds AS (
    SELECT
        order_id,
        -- refunds
        refund_transactions_id,
        refund_transactions_amount,
        refund_transactions_created_at,
        refund_transactions_kind,
        refund_transactions_status
    FROM {{ ref('int_shopify__order_refund')}}
),

joined_discounts AS (
    SELECT
        -- orders
        orders.order_id,
        orders.customer_id,
        orders.total_discounts,
        orders.total_line_items_price,
        orders.total_price,
        orders.total_shipping_price,
        orders.total_subtotal_price,
        orders.total_tax,
        orders.taxes_included,
        orders.created_at,
        orders.cancelled_at,
        orders.closed_at,
        orders.processed_at,
        orders.updated_at,
        -- discounts
        COALESCE(discounts.discount_code_code, 'NO CODE USED') AS discount_code_code,
        -- there are different kinds of discounts. Shipping discounts are only subtracted from shipping!
        COALESCE(CASE WHEN discounts.discount_application_target_type = 'shipping_line' THEN discounts.discount_code_amount ELSE 0 END, 0) AS shipping_discount,
        COALESCE(CASE WHEN discounts.discount_application_target_type = 'line_item' THEN discounts.discount_code_amount ELSE 0 END, 0) AS line_item_discount
    FROM orders
    LEFT JOIN discounts
    ON orders.order_id = discounts.order_id
),

-- refunds are joined to the order that is refunded
-- Klar associates the return to the date the order was placed, while Shopify to the day the return was logged.
joined_refunds AS (
    SELECT
        joined_discounts.order_id,
        joined_discounts.customer_id,
        joined_discounts.total_discounts,
        joined_discounts.total_line_items_price,
        joined_discounts.total_price,
        joined_discounts.total_shipping_price,
        joined_discounts.total_subtotal_price,
        joined_discounts.total_tax,
        joined_discounts.taxes_included,
        joined_discounts.created_at,
        joined_discounts.cancelled_at,
        joined_discounts.closed_at,
        joined_discounts.processed_at,
        joined_discounts.updated_at,
        -- discounts
        joined_discounts.discount_code_code,
        -- there are different kinds of discounts. Shipping discounts are only subtracted from shipping!
        joined_discounts.shipping_discount,
        joined_discounts.line_item_discount,

        -- refunds
        COALESCE(refunds.refund_transactions_id, 'NO REFUND') AS refund_transactions_id,
        COALESCE(refunds.refund_transactions_amount, 0) AS refund_transactions_amount,
        COALESCE(refunds.refund_transactions_created_at, TIMESTAMP '1970-01-01 00:00:00') AS refund_transactions_created_at,
        COALESCE(refunds.refund_transactions_kind, 'NO REFUND') AS refund_transaction_kind,
        COALESCE(refunds.refund_transactions_status, 'NO REFUND') AS refund_transactions_status
    FROM joined_discounts
    LEFT JOIN refunds
        ON joined_discounts.order_id = refunds.order_id
)
,

-- Klar definition: Net Revenue = Gross Revenue - Taxes - Refund Value

-- calculating net_revenue:
--                  total_line_items_price
--                  - total_discounts (careful! This is only valid for discount_application_target_type != shipping_line. See order_id = 6064341483866 for an example.)
--                  ----------------
--                  = total_subtotal_price 
--                      + total_shipping_price
--                      -----------------                    
--                          - returns/refunds
--                          -----------------
--                          = net_revenue

calculate_net_revenue AS (
    SELECT
        *,
        (total_line_items_price - line_item_discount - shipping_discount - refund_transactions_amount) AS net_revenue
    FROM joined_refunds
)
,

-- show which order this is for each customer
calculate_nth_order AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY created_at ASC) AS nth_order
    FROM calculate_net_revenue
),

-- flag for quick separation of new customer orders and existing customer orders
calculate_new_customer_status AS (
    SELECT
        *,
        CASE WHEN nth_order = 1 THEN 1 ELSE 0 END AS new_customer
    FROM calculate_nth_order
)

SELECT * FROM calculate_new_customer_status