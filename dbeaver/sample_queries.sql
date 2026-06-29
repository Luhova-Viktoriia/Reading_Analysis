-- Sample SQL Queries

-- This file contains a collection of practical SQL queries
-- used for everyday database interaction and data exploration.

-- The examples demonstrate filtering, joins, aggregation,
-- grouping, string aggregation and querying normalized
-- relational data using PostgreSQL.

-- Display all recommended books with their authors
SELECT
    b.titlex
    , CONCAT(a.author_last_name, ' ', a.author_first_name) AS author_name
FROM books b
JOIN authors_to_books ab
    ON b.book_id = ab.book_id
JOIN authors a
    ON ab.author_id = a.author_id
WHERE b.is_recommended = TRUE
ORDER BY
    b.title
    , a.author_last_name;

-- Display books currently owned
SELECT
    title,
    format
FROM books
WHERE is_owned = TRUE
ORDER BY title;

-- Display unfinished book series
SELECT
    series_name
    , status
    , total_books_in_series
    , books_read
    , left_to_read
FROM series
WHERE books_read < total_books_in_series
ORDER BY books_read DESC;

-- Display books in Ukrainian with all authors in one row
SELECT
    b.title
    , STRING_AGG(
        a.author_last_name || ' ' || a.author_first_name
        , ', '
        ORDER BY a.author_last_name, a.author_first_name
    ) AS authors
FROM books b
JOIN authors_to_books ab
    ON b.book_id = ab.book_id
JOIN authors a
    ON ab.author_id = a.author_id
WHERE b.book_language = 'Ukrainian'
GROUP BY b.title
ORDER BY b.title;

-- Display books (Ukrainian) with exactly 2 authors
SELECT
    b.title
    , STRING_AGG(
        a.author_last_name || ' ' || a.author_first_name
        , ', '
        ORDER BY a.author_last_name, a.author_first_name
    ) AS authors
FROM books b
JOIN authors_to_books ab
    ON b.book_id = ab.book_id
JOIN authors a
    ON ab.author_id = a.author_id
WHERE b.book_language = 'Ukrainian'
GROUP BY b.book_id, b.title
HAVING COUNT(DISTINCT a.author_id) = 2
ORDER BY b.title;

-- Display English books with genre → subgenre hierarchy
-- Data model: books → genres_to_books → genres + subgenres
SELECT
    b.title
    , g.genre || ' → ' || sg.subgenre AS genre_hierarchy
FROM books b
JOIN genres_to_books gtb
    ON b.book_id = gtb.book_id
JOIN genres g
    ON gtb.genre_id = g.genre_id
JOIN subgenres sg
    ON sg.subgenre_id = gtb.subgenre_id
WHERE b.book_language = 'English'
ORDER BY
    b.title
    , g.genre
    , sg.subgenre;