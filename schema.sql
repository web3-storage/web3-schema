CREATE SCHEMA web3storage;

CREATE TABLE web3storage.user (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  picture TEXT,
  email TEXT NOT NULL,
  issuer TEXT UNIQUE NOT NULL,
  github TEXT,
  public_address TEXT NOT NULL,
  used_storage bigint DEFAULT 0,
  inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE web3storage.auth_key (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  secret TEXT NOT NULL,
  user_id bigint NOT NULL,
  inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  deleted_at timestamp with time zone
);

CREATE TYPE web3storage.upload_type AS ENUM (
  'Car',
  'Blob',
  'Multipart'
);

CREATE TABLE web3storage.upload (
  id BIGSERIAL PRIMARY KEY,
  user_id bigint NOT NULL,
  auth_key_id bigint,
  content_cid TEXT NOT NULL,
  -- CID for content as provided by the user
  source_cid TEXT NOT NULL,
  name TEXT,
  type web3storage.upload_type NOT NULL,
  inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  deleted_at timestamp with time zone
);

CREATE TABLE web3storage.content (
  -- normalized base32 v1
  cid TEXT PRIMARY KEY,
  dag_size BIGINT,
  inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TYPE web3storage.pin_status AS ENUM (
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
);

CREATE TABLE web3storage.pin (
  id BIGSERIAL PRIMARY KEY,
  content_cid TEXT NOT NULL,
  pin_location_id bigint NOT NULL,
  status web3storage.pin_status NOT NULL,
  inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE web3storage.pin_location (
  id BIGSERIAL PRIMARY KEY,
  peer_id TEXT UNIQUE NOT NULL,
  peer_name TEXT,
  region TEXT
);
