WITH seller_orders AS (
    SELECT
        oi.seller_id,
        o.order_id,
        MAX(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                 THEN 1 ELSE 0 END) AS is_late
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY oi.seller_id, o.order_id
),
order_scores AS (
    SELECT order_id, AVG(review_score) AS score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    so.seller_id,
    s.seller_state,
    COUNT(*) AS orders,
    ROUND(100.0 * SUM(so.is_late) / COUNT(*), 1) AS late_pct,
    ROUND(AVG(sc.score), 2) AS avg_review
FROM seller_orders so
JOIN sellers s ON so.seller_id = s.seller_id
LEFT JOIN order_scores sc ON so.order_id = sc.order_id
GROUP BY so.seller_id, s.seller_state
HAVING COUNT(*) >= 30
ORDER BY avg_review ASC
LIMIT 15;