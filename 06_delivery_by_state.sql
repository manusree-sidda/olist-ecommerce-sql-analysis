WITH delivery AS (
    SELECT
        c.customer_state AS state,
        o.order_id,
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
             THEN 1 ELSE 0 END AS is_late,
        EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS days_to_deliver
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    d.state,
    COUNT(DISTINCT d.order_id) AS orders,
    ROUND(100.0 * SUM(d.is_late) / COUNT(*), 1) AS late_pct,
    ROUND(AVG(d.days_to_deliver), 1) AS avg_days,
    ROUND(AVG(r.review_score), 2) AS avg_review
FROM delivery d
JOIN order_reviews r ON d.order_id = r.order_id
GROUP BY d.state
HAVING COUNT(DISTINCT d.order_id) >= 100
ORDER BY late_pct DESC;