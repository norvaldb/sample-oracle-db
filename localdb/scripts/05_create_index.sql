ALTER SESSION SET CONTAINER = FREEPDB1;
ALTER SESSION SET CURRENT_SCHEMA = TEST_USER;

-- Index on foreign key columns in the books table
CREATE INDEX idx_books_author_id ON books(author_id);
CREATE INDEX idx_books_genre_id ON books(genre_id);

-- Index on book title for faster searching
CREATE INDEX idx_books_title ON books(title);

-- Index on author last name
CREATE INDEX idx_authors_last_name ON authors(last_name);

COMMIT;

-- Exit SQL*Plus (optional)
-- EXIT;
