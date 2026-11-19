CREATE SCHEMA IF NOT EXISTS demo;
CREATE TABLE demo.users (
  id bigint PRIMARY KEY,
  name text NOT NULL
);
CREATE TABLE demo.resources (
  id bigint PRIMARY KEY,
  name text NOT NULL,
  current_price numeric(12,2) NOT NULL CHECK (current_price >= 0),
  available integer NOT NULL CHECK (available >= 0)
);
CREATE TABLE demo.requests (
  id bigint PRIMARY KEY,
  user_id bigint NOT NULL REFERENCES demo.users(id),
  created_at timestamptz NOT NULL,
  status text NOT NULL CHECK (status IN ('draft', 'confirmed', 'cancelled'))
);
CREATE TABLE demo.request_items (
  request_id bigint NOT NULL REFERENCES demo.requests(id),
  resource_id bigint NOT NULL REFERENCES demo.resources(id),
  quantity integer NOT NULL CHECK (quantity > 0),
  agreed_price numeric(12,2) NOT NULL CHECK (agreed_price >= 0),
  PRIMARY KEY (request_id, resource_id)
);
