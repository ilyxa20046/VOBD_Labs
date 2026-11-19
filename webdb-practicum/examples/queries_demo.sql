EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT id, created_at, status FROM demo.requests
WHERE user_id = 1
ORDER BY created_at DESC, id DESC LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT date_trunc('day', q.created_at AT TIME ZONE 'UTC') AS day,
       count(DISTINCT q.id) AS requests,
       sum(i.quantity * i.agreed_price) AS amount
FROM demo.requests q JOIN demo.request_items i ON i.request_id = q.id
WHERE q.status = 'confirmed'
GROUP BY 1 ORDER BY 1;

-- Test this index as a separate experiment; do not create it before the baseline.
-- CREATE INDEX requests_user_time_idx ON demo.requests (user_id, created_at DESC, id DESC);
