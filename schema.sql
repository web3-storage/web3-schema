CREATE SCHEMA web3storage
  CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    picture TEXT,
    email TEXT NOT NULL,
    issuer TEXT UNIQUE NOT NULL,
    github TEXT,
    public_address TEXT NOT NULL,
    used_storage bigint DEFAULT 0,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
  )
  CREATE TABLE auth_tokens (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    secret TEXT NOT NULL,
    user_id bigint NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    deleted_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  )
  CREATE TABLE uploads (
    id BIGSERIAL PRIMARY KEY,
    user_id bigint NOT NULL,
    auth_token_id bigint NOT NULL,
    content_id bigint NOT NULL,
    name TEXT,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    deleted_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  )
  CREATE TABLE contents (
    id BIGSERIAL PRIMARY KEY,
    cid TEXT UNIQUE NOT NULL,
    dag_size bigint DEFAULT 0,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
  )
  CREATE TABLE pins (
    id BIGSERIAL PRIMARY KEY,
    content_id bigint NOT NULL,
    pin_location_id bigint NOT NULL,
    status TEXT NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  )
  CREATE TABLE pin_locations (
    id BIGSERIAL PRIMARY KEY,
    peer_id TEXT UNIQUE NOT NULL,
    peer_name TEXT,
    region TEXT
  )
  CREATE TABLE aggregate_entries (
    id BIGSERIAL PRIMARY KEY,
    content_id bigint NOT NULL,
    aggregate_id bigint NOT NULL,
    data_model_selector TEXT
  )
  CREATE TABLE aggregates (
    id BIGSERIAL PRIMARY KEY,
    data_cid TEXT NOT NULL,
    piece_cid TEXT
  )
  CREATE TABLE deals (
    id BIGSERIAL PRIMARY KEY,
    aggregate_id bigint NOT NULL,
    storage_provider TEXT,
    deal_id bigint UNIQUE NOT NULL,
    activation timestamp(6) without time zone,
    renewel timestamp(6) without time zone,
    status TEXT NOT NULL,
    status_reason TEXT,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated timestamp(6) without time zone NOT NULL
  );
