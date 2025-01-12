WITH
stg_shopify__orders AS (
    SELECT
        order_id,
        customer_id,
        -- the following metrics are just for checks. They do not really belong here
        total_line_items_price,
        total_discounts,
        total_subtotal_price,
        total_shipping_price,
        total_tax,
        total_price,
        
        -- discounts -- 
        -- This method only works because there are no columns with more than one element in the list (one discount per order).
        -- To handle multiple list elements the array would have to be unnested.
        -- Since this is just a test, i will take the easy route and use regex.
        REGEXP_EXTRACT(discount_application_target_type, r'\[\'([^\']+)\'\]') AS discount_application_target_type,
        REGEXP_EXTRACT(discount_application_allocation_method, r'\[\'([^\']+)\'\]') AS discount_application_allocation_method,
        REGEXP_EXTRACT(discount_application_code, r'\[\'([^\']+)\'\]') AS discount_application_code,
        REGEXP_EXTRACT(discount_application_target_selection, r'\[\'([^\']+)\'\]') AS discount_application_target_selection,
        REGEXP_EXTRACT(discount_application_type, r'\[\'([^\']+)\'\]') AS discount_application_type,
        CAST(REPLACE(REPLACE(discount_application_value, '[', ''), ']', '') AS FLOAT64) AS discount_application_value,

        REGEXP_EXTRACT(discount_application_value_type, r'\[\'([^\']+)\'\]') AS discount_application_value_type,
        REGEXP_EXTRACT(discount_application_title, r'\[\'([^\']+)\'\]') AS discount_application_title,
        REGEXP_EXTRACT(discount_application_description, r'\[\'([^\']+)\'\]') AS discount_application_description,
        REGEXP_EXTRACT(discount_code_code, r'\[\'([^\']+)\'\]') AS discount_code_code,
        REGEXP_EXTRACT(discount_code_type, r'\[\'([^\']+)\'\]') AS discount_code_type,
        CAST(REPLACE(REPLACE(discount_code_amount, '[', ''), ']', '') AS FLOAT64) AS discount_code_amount,
    FROM {{ ref('stg_shopify__orders') }}
    -- only handle discounts in this model
    WHERE total_discounts > 0
),

-- there are different types of discounts
-- if discount_application_target_type = shipping_line, then the discount is only subtracted from the shipping!

SELECT * FROM stg_shopify__orders