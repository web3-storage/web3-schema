CREATE SCHEMA web3storage
  CREATE TABLE user (
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
  CREATE TABLE auth_key (
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
  CREATE TABLE upload (
    id BIGSERIAL PRIMARY KEY,
    user_id bigint NOT NULL,
    auth_key_id bigint,
    content_cid TEXT NOT NULL,
    -- CID for content as provided by the user
    cid TEXT NOT NULL,
    name TEXT,
    type upload_type NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    deleted_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  )
  CREATE TABLE content (
    -- normalized base32 v1
    cid TEXT PRIMARY KEY,
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
  CREATE TABLE pin (
    id BIGSERIAL PRIMARY KEY,
    content_id bigint NOT NULL,
    pin_location_id bigint NOT NULL,
    status pin_status NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
  )
  CREATE TABLE pin_location (
    id BIGSERIAL PRIMARY KEY,
    peer_id TEXT UNIQUE NOT NULL,
    peer_name TEXT,
    region TEXT
  )
  CREATE TABLE aggregate_entry (
    id BIGSERIAL PRIMARY KEY,
    content_id bigint NOT NULL,
    aggregate_id bigint NOT NULL,
    data_model_selector TEXT
  )
  CREATE TABLE aggregate (
    id BIGSERIAL PRIMARY KEY,
    data_cid TEXT UNIQUE NOT NULL,
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
  CREATE TABLE deal (
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
