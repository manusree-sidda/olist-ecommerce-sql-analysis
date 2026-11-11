WITH delivery AS (
    SELECT
        o.order_id,
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 'Late'
            ELSE 'On time'
        END AS delivery_status,
        EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS days_to_deliver
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    d.delivery_status,
    COUNT(DISTINCT d.order_id) AS orders,
    ROUND(100.0 * COUNT(DISTINCT d.order_id) / SUM(COUNT(DISTINCT d.order_id)) OVER (), 1) AS pct_of_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(AVG(d.days_to_deliver), 1) AS avg_days_to_deliver
FROM delivery d
JOIN order_reviews r ON d.order_id = r.order_id
GROUP BY d.delivery_status;