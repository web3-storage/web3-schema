CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER dagcargo
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host '{CARGO_HOST}', port '5432', dbname '{CARGO_DB_NAME}');

CREATE USER MAPPING FOR {DB_USER}
  SERVER dagcargo
  OPTIONS (user '{CARGO_USER}', password '{CARGO_PASSWORD}');

IMPORT FOREIGN SCHEMA cargo
  LIMIT TO (deals, aggregates, aggregate_entries)
  FROM SERVER dagcargo
  INTO web3storage;
