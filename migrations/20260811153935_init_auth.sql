-- +goose Up
SELECT 'up SQL query';
CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255),
  email_verified_at TIMESTAMPTZ,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_users_email ON users (email);

CREATE TABLE IF NOT EXISTS accounts (
  id BIGSERIAL,
  user_id BIGINT NOT NULL,
  provider VARCHAR(255) NOT NULL,
  provider_account_id VARCHAR(255),
  access_token TEXT NOT NULL,
  refresh_token TEXT,
  access_token_expires_at TIMESTAMPTZ,
  scope VARCHAR(255) NOT NULL,
  id_token TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (id),
CONSTRAINT fk_accounts_users_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_accounts_user_id_provider ON accounts (user_id);
CREATE UNIQUE INDEX idx_accounts_provider_provider_account_id ON accounts (provider, provider_account_id);

CREATE TABLE IF NOT EXISTS rate_limits (
  id BIGSERIAL,
  key VARCHAR(255) NOT NULL,
  count INTEGER NOT NULL,
  last_request_at BIGINT NOT NULL,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_rate_limits_key ON rate_limits (key);

CREATE TABLE IF NOT EXISTS sessions (
  id BIGSERIAL,
  token VARCHAR(255) NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMPTZ NOT NULL,
  last_access TIMESTAMPTZ NOT NULL,
  metadata JSONB,
  PRIMARY KEY (id),
CONSTRAINT fk_sessions_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE UNIQUE INDEX idx_sessions_token ON sessions (token);
CREATE INDEX idx_sessions_user_id ON sessions (user_id);

CREATE TABLE IF NOT EXISTS verifications (
  id BIGSERIAL,
  subject VARCHAR(255) NOT NULL,
  value TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_verifications_value ON verifications (value);
CREATE INDEX idx_verifications_subject ON verifications (subject);

-- +goose Down
SELECT 'down SQL query';
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS rate_limits;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS verifications;
