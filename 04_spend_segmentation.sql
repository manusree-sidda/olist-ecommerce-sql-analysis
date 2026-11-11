WITH customer_spend AS (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS total_spend
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
segmented AS (
    SELECT
        customer_unique_id,
        total_spend,
        NTILE(10) OVER (ORDER BY total_spend DESC) AS decile
    FROM customer_spend
)
SELECT
    decile,
    COUNT(*) AS customers,
    ROUND(SUM(total_spend), 2) AS revenue,
    ROUND(100.0 * SUM(total_spend) / SUM(SUM(total_spend)) OVER (), 1) AS pct_of_revenue
FROM segmented
GROUP BY decile
ORDER BY decile;