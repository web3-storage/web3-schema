CREATE SCHEMA web3storage;
  CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name character varying NOT NULL,
    picture character varying,
    email character varying NOT NULL,
    issuer character varying UNIQUE NOT NULL,
    github character varying,
    publicAddress character varying NOT NULL,
    usedStorage bigint DEFAULT 0,
    created timestamp(6) without time zone NOT NULL
  )
  CREATE TABLE auth_tokens (
    id BIGSERIAL PRIMARY KEY,
    name character varying NOT NULL,
    secret character varying NOT NULL, -- TODO unique index?
    userId bigint NOT NULL,
    created timestamp(6) without time zone NOT NULL,
    deleted timestamp(6) without time zone
  )
  CREATE TABLE uploads (
    id BIGSERIAL PRIMARY KEY,
    userId bigint NOT NULL,
    authTokenId bigint NOT NULL,
    name character varying,
    created timestamp(6) without time zone NOT NULL,
    deleted timestamp(6) without time zone
  )
  CREATE TABLE contents (
    id BIGSERIAL PRIMARY KEY,
    cid character varying UNIQUE NOT NULL,
    dagSize bigint DEFAULT 0,
    created timestamp(6) without time zone NOT NULL
  )
  CREATE TABLE pins (
    id BIGSERIAL PRIMARY KEY,
    contentId bigint NOT NULL,
    pinLocationId bigint NOT NULL,
    status character varying NOT NULL,
    created timestamp(6) without time zone NOT NULL,
    updated timestamp(6) without time zone NOT NULL
  )
  CREATE TABLE pin_locations (
    id BIGSERIAL PRIMARY KEY,
    peerId character varying UNIQUE NOT NULL,
    peerName character varying,
    region character varying
  )
  CREATE TABLE aggregate_entries (
    id BIGSERIAL PRIMARY KEY,
    contentId bigint NOT NULL,
    aggregateId bigint NOT NULL,
    dataModelSelector character varying
  )
  CREATE TABLE aggregates (
    id BIGSERIAL PRIMARY KEY,
    dataCid character varying NOT NULL,
    pieceCid character varying
  )
  CREATE TABLE deals (
    id BIGSERIAL PRIMARY KEY,
    aggregateId bigint NOT NULL,
    storageProvider character varying,
    dealId bigint UNIQUE NOT NULL, -- (self referencing column name)
    activation timestamp(6) without time zone
    renewel timestamp(6) without time zone
    status character varying NOT NULL,
    statusReason character varying,
    created timestamp(6) without time zone NOT NULL,
    updated timestamp(6) without time zone NOT NULL
  );
