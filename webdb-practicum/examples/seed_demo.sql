BEGIN;
TRUNCATE demo.request_items, demo.requests, demo.resources, demo.users;
INSERT INTO demo.users SELECT g, 'User ' || g FROM generate_series(1,200) AS g;
INSERT INTO demo.resources
SELECT g, 'Resource ' || g, 10 + (g % 100) * 0.5, 1000000
FROM generate_series(1,1000) AS g;
INSERT INTO demo.requests
SELECT g, CASE WHEN g % 10 < 8 THEN 1 ELSE 2 + (g % 199) END,
  timestamptz '2026-01-01 00:00:00+00' + (g % 180) * interval '1 day' + g * interval '1 second',
  CASE WHEN g % 10 < 7 THEN 'confirmed' WHEN g % 10 = 7 THEN 'cancelled' ELSE 'draft' END
FROM generate_series(1,50000) AS g;
INSERT INTO demo.request_items
SELECT q.id, r.id, 1 + (q.id % 5), r.current_price
FROM demo.requests q CROSS JOIN generate_series(1,3) AS line_no
JOIN demo.resources r ON r.id = ((q.id * 7 + line_no) % 1000) + 1;
COMMIT;
ANALYZE demo.users;
ANALYZE demo.resources;
ANALYZE demo.requests;
ANALYZE demo.request_items;
