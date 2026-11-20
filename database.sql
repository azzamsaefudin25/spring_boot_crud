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

SELECT * FROM addresses;

\d addresses

-- Delete data

DELETE FROM addresses;

DELETE FROM contacts;

DELETE FROM users;