CREATE TABLE account (
    id TEXT PRIMARY KEY,
    email_address TEXT NOT NULL UNIQUE,
    password_hash BYTEA NOT NULL,
    password_salt BYTEA NOT NULL,
    created_at BIGINT NOT NULL
);

CREATE TABLE auth_session (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    secret_hash BYTEA NOT NULL,
    created_at BIGINT NOT NULL
);

CREATE INDEX auth_session_user_index ON auth_session(user_id);

CREATE TABLE signup_session (
    id TEXT PRIMARY KEY,
    secret_hash BYTEA NOT NULL,
    email_address TEXT NOT NULL,
    email_address_verification_code TEXT NOT NULL,
    email_address_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at BIGINT NOT NULL
);

CREATE TABLE email_address_update_session (
    id TEXT PRIMARY KEY,
    auth_session_id TEXT NOT NULL REFERENCES auth_session(id) ON DELETE CASCADE,
    secret_hash BYTEA NOT NULL,
    user_identity_verified BOOLEAN NOT NULL DEFAULT FALSE,
    new_email_address TEXT,
    new_email_address_verification_code TEXT,
    created_at BIGINT NOT NULL
);

CREATE INDEX email_address_update_session_auth_session_id_index
ON email_address_update_session(auth_session_id);

CREATE TABLE password_update_session (
    id TEXT PRIMARY KEY,
    auth_session_id TEXT NOT NULL REFERENCES auth_session(id) ON DELETE CASCADE,
    secret_hash BYTEA NOT NULL,
    user_identity_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at BIGINT NOT NULL
);

CREATE INDEX password_update_session_auth_session_id_index
ON password_update_session(auth_session_id);

CREATE TABLE account_deletion_session (
    id TEXT PRIMARY KEY,
    auth_session_id TEXT NOT NULL REFERENCES auth_session(id) ON DELETE CASCADE,
    secret_hash BYTEA NOT NULL,
    user_identity_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at BIGINT NOT NULL
);

CREATE INDEX account_deletion_session_auth_session_id_index
ON account_deletion_session(auth_session_id);

CREATE TABLE password_reset_session (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    secret_hash BYTEA NOT NULL,
    email_code_hash BYTEA NOT NULL,
    email_code_salt BYTEA NOT NULL,
    user_identity_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at BIGINT NOT NULL
);

CREATE INDEX password_reset_session_user_id_index
ON password_reset_session(user_id);
