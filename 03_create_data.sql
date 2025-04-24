-- Note: Assumes connection as 'booklib_user'.

-- Insert Sample Authors
INSERT INTO authors (first_name, last_name, birth_date) VALUES ('George', 'Orwell', DATE '1903-06-25');
INSERT INTO authors (first_name, last_name, birth_date) VALUES ('Jane', 'Austen', DATE '1775-12-16');
INSERT INTO authors (first_name, last_name, birth_date) VALUES ('J.R.R.', 'Tolkien', DATE '1892-01-03');
INSERT INTO authors (first_name, last_name, birth_date) VALUES ('Isaac', 'Asimov', DATE '1920-01-02');

-- Insert Sample Genres
INSERT INTO genres (name) VALUES ('Dystopian Fiction');
INSERT INTO genres (name) VALUES ('Romance');
INSERT INTO genres (name) VALUES ('Fantasy');
INSERT INTO genres (name) VALUES ('Science Fiction');
INSERT INTO genres (name) VALUES ('Classic Literature');

-- Insert Sample Books (using subqueries to get IDs - adjust if IDs are known)
INSERT INTO books (title, isbn, publication_date, author_id, genre_id) VALUES (
    'Nineteen Eighty-Four',
    '978-0451524935',
    DATE '1949-06-08',
    (SELECT author_id FROM authors WHERE last_name = 'Orwell'),
    (SELECT genre_id FROM genres WHERE name = 'Dystopian Fiction')
);

INSERT INTO books (title, isbn, publication_date, author_id, genre_id) VALUES (
    'Pride and Prejudice',
    '978-0141439518',
    DATE '1813-01-28',
    (SELECT author_id FROM authors WHERE last_name = 'Austen'),
    (SELECT genre_id FROM genres WHERE name = 'Romance')
);

INSERT INTO books (title, isbn, publication_date, author_id, genre_id) VALUES (
    'The Hobbit',
    '978-0547928227',
    DATE '1937-09-21',
    (SELECT author_id FROM authors WHERE last_name = 'Tolkien'),
    (SELECT genre_id FROM genres WHERE name = 'Fantasy')
);

INSERT INTO books (title, isbn, publication_date, author_id, genre_id) VALUES (
    'Foundation',
    '978-0553293357',
    DATE '1951-06-01',
    (SELECT author_id FROM authors WHERE last_name = 'Asimov'),
    (SELECT genre_id FROM genres WHERE name = 'Science Fiction')
);

INSERT INTO books (title, isbn, publication_date, author_id, genre_id) VALUES (
    'Animal Farm',
    '978-0451526342',
    DATE '1945-08-17',
    (SELECT author_id FROM authors WHERE last_name = 'Orwell'),
    (SELECT genre_id FROM genres WHERE name = 'Classic Literature')
);

COMMIT;

-- Exit SQL*Plus (optional)
-- EXIT;
