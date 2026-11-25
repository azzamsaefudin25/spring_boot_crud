-- User
CREATE TABLE users
(
    username         VARCHAR(100) NOT NULL,
    password         VARCHAR(100) NOT NULL,
    name             VARCHAR(100) NOT NULL,
    token            VARCHAR(100),
    token_expired_at BIGINT,

    CONSTRAINT pk_users PRIMARY KEY (username),
    CONSTRAINT uq_users_token UNIQUE (token)
);

ALTER TABLE users
    DROP CONSTRAINT pk_users;

ALTER TABLE users
    ADD CONSTRAINT users_username_unique UNIQUE (username);

ALTER TABLE users
    DROP COLUMN id;

ALTER TABLE users
    ADD COLUMN id VARCHAR(100) NOT NULL;

ALTER TABLE users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);

ALTER TABLE users
    ADD COLUMN created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN updated_at TIMESTAMPTZ,
    ADD COLUMN deleted_at TIMESTAMPTZ,
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

SELECT * FROM users;

\d users;

-- Contact
CREATE TABLE contacts
(
    id         VARCHAR(100) NOT NULL,
    username   VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100),
    phone      VARCHAR(100),
    email      VARCHAR(100),

    CONSTRAINT pk_contacts PRIMARY KEY (id),
    CONSTRAINT fk_users_contacts
        FOREIGN KEY (username)
            REFERENCES users (username)
);

SELECT * FROM contacts;

\d contacts

ALTER TABLE contacts
    RENAME COLUMN username TO user_id;

ALTER TABLE contacts
    DROP CONSTRAINT fk_contacts_user;

ALTER TABLE contacts
    ADD CONSTRAINT fk_contacts_user
        FOREIGN KEY (user_id)
            REFERENCES users(id);
SELECT
    conname AS constraint_name,
    contype AS constraint_type
FROM pg_constraint
WHERE conrelid = 'contacts'::regclass
  AND contype = 'f';

ALTER TABLE contacts
    ADD CONSTRAINT users_email_unique UNIQUE (email),
    ADD CONSTRAINT users_phone_unique UNIQUE (phone);

ALTER TABLE contacts
    ADD COLUMN created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN updated_at TIMESTAMPTZ,
    ADD COLUMN deleted_at TIMESTAMPTZ,
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- Address

CREATE TABLE addresses
(
    id          VARCHAR(100) NOT NULL,
    contact_id  VARCHAR(100) NOT NULL,
    street      VARCHAR(200),
    city        VARCHAR(100),
    province    VARCHAR(100),
    country     VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10),

    CONSTRAINT pk_addresses PRIMARY KEY (id),
    CONSTRAINT fk_contacts_addresses
        FOREIGN KEY (contact_id)
            REFERENCES contacts (id)
);

ALTER TABLE addresses
    ADD COLUMN created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN updated_at TIMESTAMPTZ,
    ADD COLUMN deleted_at TIMESTAMPTZ;

SELECT * FROM addresses;

\d addresses;

