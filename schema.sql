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
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone
  )
  CREATE TABLE auth_tokens (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    secret TEXT NOT NULL,
    user_id bigint NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    deleted_at timestamp with time zone
  )
  CREATE TYPE upload_type AS ENUM (
    'Car',
    'Blob',
    'Multipart'
  )
  CREATE TABLE uploads (
    id BIGSERIAL PRIMARY KEY,
    user_id bigint NOT NULL,
    auth_token_id bigint,
    content_id bigint NOT NULL,
    name TEXT,
    type upload_type NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    deleted_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  )
  CREATE TABLE contents (
    id BIGSERIAL PRIMARY KEY,
    cid TEXT UNIQUE NOT NULL,
    dag_size bigint DEFAULT 0,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone  DEFAULT timezone('utc'::text, now())
  )
  CREATE TYPE pin_status AS ENUM (
    'Undefined',
    'ClusterError',
    'PinError',
    'UnpinError',
    'Pinned',
    'Pinning',
    'Unpinning',
    'Unpinned',
    'Remote',
    'PinQueued',
    'UnpinQueued',
    'Sharded'
  )
  CREATE TABLE pins (
    id BIGSERIAL PRIMARY KEY,
    content_id bigint NOT NULL,
    pin_location_id bigint NOT NULL,
    status pin_status NOT NULL,
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
    aggregate_cid text UNIQUE NOT NULL, -- previously dataCid
    piece_cid TEXT UNIQUE,
    sha256hex TEXT,
    export_size BIGINT,
    metadata jsonb NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
  )
  CREATE TYPE deal_status AS ENUM (
    'Queued',
    'Published',
    'Active',
    'Terminated'
  )
  CREATE TABLE deals (
    id BIGSERIAL PRIMARY KEY,
    aggregate_id bigint NOT NULL,
    storage_provider TEXT,
    deal_id bigint UNIQUE NOT NULL,
    activation timestamp with time zone,
    renewal timestamp with time zone,
    status deal_status NOT NULL,
    status_reason TEXT,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  );
