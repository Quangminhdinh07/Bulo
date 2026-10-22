CREATE TYPE request_status AS ENUM('pending', 'accepted', 'declined');

CREATE TABLE Users (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	username TEXT NOT NULL CHECK (length(username) <= 50),
	email TEXT CHECK (length(email) <= 255),
	phone_number TEXT UNIQUE,
	birthday DATE,
	password_hash TEXT NOT NULL,
	display_name TEXT NOT NULL,
	avatar_url TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
	CONSTRAINT minimum_identifier
		CHECK (email IS NOT NULL OR phone_number IS NOT NULL)
);

CREATE UNIQUE INDEX unique_email ON Users (lower(email));
CREATE UNIQUE INDEX unique_username ON Users (lower(username));

CREATE TABLE Friendships (
	user_a_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	user_b_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
	CONSTRAINT no_self_friendship
		CHECK (user_a_id < user_b_id),
	PRIMARY KEY (user_a_id, user_b_id)
);

CREATE INDEX order_user_b ON Friendships (user_b_id);

CREATE TABLE Friend_requests (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	sender_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	receiver_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	status REQUEST_STATUS NOT NULL DEFAULT 'pending',
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
	CONSTRAINT id_ordering
		CHECK (sender_id != receiver_id)
);

CREATE UNIQUE INDEX unique_pair ON Friend_requests (
	LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id))
	WHERE status = 'pending';
CREATE INDEX pair_receiver ON Friend_requests (receiver_id);

CREATE TABLE Posts (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	sender_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	storage_key TEXT NOT NULL,
	caption TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX post_order ON Posts (sender_id, created_at);

CREATE TABLE Feed_entries (
	post_id BIGINT NOT NULL REFERENCES Posts(id) ON DELETE CASCADE,
	recipient_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY (post_id, recipient_id)
);

CREATE INDEX feed_order ON Feed_entries (recipient_id, created_at, post_id);

CREATE TABLE Refresh_tokens (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id BIGINT NOT NULL REFERENCES Users(id) ON DELETE CASCADE,
	token_hash TEXT UNIQUE NOT NULL,
	family_id UUID NOT NULL DEFAULT gen_random_uuid(),
	expires_at TIMESTAMPTZ NOT NULL,
	revoked_at TIMESTAMPTZ
);

CREATE INDEX token_order_user ON Refresh_tokens (user_id);
CREATE INDEX token_order_family ON Refresh_tokens (family_id);