-- AGGREGATIONS: BASIC AND WINDOW

-- BASIC AGGREGATIONS

/*
Aggregates books by genre and subgenre,
demonstrating GROUP BY, HAVING, ORDER BY, and LIMIT.
*/
SELECT
    g.genre
	, sg.subgenre
	, COUNT(DISTINCT b.book_id) AS books_count
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE b.rating IS NOT NULL
GROUP BY
    g.genre
	, sg.subgenre
HAVING COUNT(DISTINCT b.book_id) >= 7
ORDER BY
    books_count DESC
	, g.genre
	, sg.subgenre
LIMIT 10;

-- STRING_AGG: basic and limited output examples

/*
Demonstrates STRING_AGG by aggregating
genre-level reading statistics.
*/
SELECT
    g.genre
	, COUNT(b.book_id) AS books_count
	, SUM(b.pages) AS total_pages
	, ROUND(AVG(b.pages), 0) AS avg_pages
	, MIN(b.pages) AS min_pages
	, MAX(b.pages) AS max_pages
	, STRING_AGG(b.title, ', ') AS books_list
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
WHERE b.pages IS NOT NULL
GROUP BY g.genre
ORDER BY total_pages DESC;

/*
Alternative STRING_AGG example with a subquery and LIMIT
to keep the output concise.
*/
SELECT
    g.genre
	, COUNT(b.book_id) AS books_count
	, SUM(b.pages) AS total_pages
	, ROUND(AVG(b.pages), 0) AS avg_pages
	, MIN(b.pages) AS min_pages
	, MAX(b.pages) AS max_pages
	,
	(
        SELECT STRING_AGG(title, ', ')
        FROM (
            SELECT b2.title
            FROM books b2
            JOIN genres_to_books gb2
            ON b2.book_id = gb2.book_id
            WHERE gb2.genre_id = g.genre_id
            AND b2.pages IS NOT NULL
            ORDER BY b2.title
	        LIMIT 2
        ) t
    ) AS books_list
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
WHERE b.pages IS NOT NULL
GROUP BY g.genre, g.genre_id
ORDER BY total_pages DESC;

-- List unique authors whose names start with "M" using STRING_AGG
SELECT
    STRING_AGG(DISTINCT author_last_name,
	', ' ORDER BY author_last_name) AS authors_starting_with_m
FROM authors
WHERE author_last_name ILIKE 'М%';


-- WINDOW AGGREGATIONS

/*
Demonstrates the difference between basic and window aggregations.
PARTITION BY calculates genre-level metrics while preserving
row-level book details.
*/
SELECT
    g.genre
	, b.title
	, b.rating
	, COUNT(*) OVER (PARTITION BY g.genre) AS books_in_genre
	, SUM(b.pages) OVER (PARTITION BY g.genre) AS total_pages_in_genre
	, ROUND(AVG(b.rating) OVER (PARTITION BY g.genre), 2) AS avg_genre_rating
	, MIN(b.pages) OVER (PARTITION BY g.genre) AS min_pages_in_genre
	, MAX(b.pages) OVER (PARTITION BY g.genre) AS max_pages_in_genre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
ORDER BY total_pages_in_genre DESC;

SELECT
    g.genre
	, COUNT(*) AS books_in_genre
	, SUM(b.pages) AS total_pages_in_genre
	, ROUND(AVG(b.rating), 2) AS avg_genre_rating
	, MIN(b.pages)  AS min_pages_in_genre
	, MAX(b.pages)  AS max_pages_in_genre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
GROUP BY g.genre
ORDER BY total_pages_in_genre DESC;