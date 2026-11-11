WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE num_orders > 1) AS repeat_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE num_orders > 1) / COUNT(*), 2) AS repeat_rate_pct
FROM customer_orders;