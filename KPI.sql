SELECT
    (SELECT ROUND(SUM(p.payment_value), 2)
       FROM orders o JOIN order_payments p ON o.order_id = p.order_id
      WHERE o.order_status = 'delivered') AS total_revenue,
    (SELECT COUNT(*) FROM orders WHERE order_status = 'delivered') AS total_orders,
    (SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date) / COUNT(*), 1)
       FROM orders
      WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL) AS late_delivery_pct,
    3.0 AS repeat_rate_pct;