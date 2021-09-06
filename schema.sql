CREATE SCHEMA web3storage;

-- A user of web3.storage.
CREATE TABLE web3storage.user (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  picture TEXT,
  email TEXT NOT NULL,
  -- The Decentralized ID of the Magic User who generated the DID Token.
  issuer TEXT UNIQUE NOT NULL,
  -- GitHub user handle, may be null if user logged in via email.
  github TEXT,
  -- Cryptographic public address of the Magic User.
  public_address TEXT NOT NULL,
  -- Used storage in bytes.
  used_storage BIGINT DEFAULT 0,
  inserted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- User authentication keys.
CREATE TABLE web3storage.auth_key (
  id BIGSERIAL PRIMARY KEY,
  -- User assigned name.
  name TEXT NOT NULL,
  -- Secret that corresponds to this token.
  secret TEXT NOT NULL,
  -- User this token belongs to.
  user_id BIGINT NOT NULL,
  inserted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE web3storage.upload_type AS ENUM (
  -- A CAR file upload.
  'Car',
  -- A raw blob upload in the request body.
  'Blob',
  -- A multi file upload using a multipart request.
  'Multipart'
);

-- An upload created by a user.
CREATE TABLE web3storage.upload (
  id BIGSERIAL PRIMARY KEY,
  -- User that uploaded this content.
  user_id BIGINT NOT NULL,
  -- User authentication token that was used to upload this content.
  -- Note: nullable, because the user may have used a Magic.link token.
  auth_key_id BIGINT,
  -- The root of the uploaded content.
  content_cid TEXT NOT NULL,
  -- CID for the content as provided by the user.
  source_cid TEXT NOT NULL,
  -- User provided name for this upload.
  name TEXT,
  -- Type of received upload data.
  type web3storage.upload_type NOT NULL,
  inserted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Details of the root of a file/directory stored on web3.storage.
CREATE TABLE web3storage.content (
  -- Root CID for this content. Normalized as v1 base32.
  cid TEXT PRIMARY KEY,
  -- Size of the DAG in bytes. Set if known on upload or for partials is set
  -- when content is fully pinned in at least one location.
  dag_size BIGINT,
  inserted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- IPFS Cluster tracker status values.
CREATE TYPE web3storage.pin_status AS ENUM (
  -- Should never see this value. When used as a filter. It means "all".
  'Undefined',
  -- The cluster node is offline or not responding.
  'ClusterError',
  -- An error occurred pinning.
  'PinError',
  -- An error occurred unpinning.
  'UnpinError',
  -- The IPFS daemon has pinned the item.
  'Pinned',
  -- The IPFS daemon is currently pinning the item.
  'Pinning',
  -- The IPFS daemon is currently unpinning the item.
  'Unpinning',
  -- The IPFS daemon is not pinning the item.
  'Unpinned',
  -- The IPFS daemon is not pinning the item but it is being tracked.
  'Remote',
  -- The item has been queued for pinning on the IPFS daemon.
  'PinQueued',
  -- The item has been queued for unpinning on the IPFS daemon.
  'UnpinQueued',
  -- The IPFS daemon is not pinning the item through this CID but it is tracked
  -- in a cluster dag
  'Sharded'
);

-- Information for piece of content pinned in IPFS.
CREATE TABLE web3storage.pin (
  id BIGSERIAL PRIMARY KEY,
  -- The content being pinned.
  content_cid TEXT NOT NULL,
  -- Identifier for the service that is pinning this pin.
  pin_location_id BIGINT NOT NULL,
  -- Pinning status at this location.
  status web3storage.pin_status NOT NULL,
  inserted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- An IPFS node that is pinning content.
CREATE TABLE web3storage.pin_location (
  id BIGSERIAL PRIMARY KEY,
  -- Libp2p peer ID of the node pinning this pin.
  peer_id TEXT UNIQUE NOT NULL,
  -- Name of the peer pinning this pin.
  peer_name TEXT,
  -- Geographic region this node resides in.
  region TEXT
);
