-- JOIN TYPES: INNER, LEFT, RIGHT, FULL, CROSS, SELF

/*
INNER JOIN/JOIN:
returns each series with its associated genres,
aggregated into one field
*/
SELECT
    s.series_name
	, STRING_AGG(DISTINCT g.genre, ', ') AS genres
FROM series s
JOIN books b ON s.series_id = b.series_id
JOIN genres_to_books gb ON b.book_id = gb.book_id
JOIN genres g ON gb.genre_id = g.genre_id
GROUP BY s.series_name;

/*
LEFT and RIGHT JOIN produce identical results,
returning each genre with the number of associated subgenres
*/
-- LEFT JOIN:
SELECT
    g.genre
	, COUNT(DISTINCT gb.subgenre_id) AS subgenre_count
FROM genres g
LEFT JOIN genres_to_books gb
    ON g.genre_id = gb.genre_id
GROUP BY g.genre
ORDER BY subgenre_count DESC;

--RIGHT JOIN:
SELECT
    g.genre
	, COUNT(DISTINCT gb.subgenre_id) AS subgenre_count
FROM genres_to_books gb
RIGHT JOIN genres g
    ON g.genre_id = gb.genre_id
GROUP BY g.genre
ORDER BY subgenre_count DESC;

/*
FULL JOIN:
returns list of favorite authors with all their books and page counts
*/
SELECT
    fa.author_name
	, b.title
	, b.pages
FROM favorite_authors fa
FULL JOIN authors a
    ON fa.author_name = a.author_first_name || ' ' || a.author_last_name
FULL JOIN authors_to_books ab
    ON a.author_id = ab.author_id
FULL JOIN books b
    ON ab.book_id = b.book_id
WHERE fa.author_name IS NOT NULL
  AND b.title IS NOT NULL
ORDER BY fa.author_name;

/*
CROSS JOIN:
creates all genre–format combinations and
keeps only those where at least one book was read 
*/
SELECT * FROM (
	SELECT
    g.genre
	, f.format
	, COUNT(DISTINCT b.book_id) AS books_read
FROM genres g
CROSS JOIN (
    SELECT DISTINCT format
    FROM books
) f
LEFT JOIN genres_to_books gb
    ON gb.genre_id = g.genre_id
LEFT JOIN books b
    ON b.book_id = gb.book_id
   AND b.format = f.format
GROUP BY g.genre, f.format
) n
WHERE n.books_read > 0

/*
SELF JOIN/JOIN:
links each book example implemented in two ways: with subqueries and with CTE
excludes series with only one book read,
since no "next book" exists
*/

-- SELF-JOIN with subqueries:
SELECT
    b1.series_name
	, b1.title AS book
	, b2.title AS next_book
FROM (
    SELECT
        book_id
		, series_name
		, title
		, ROW_NUMBER() OVER (
            PARTITION BY series_name
            ORDER BY book_id
        ) AS rn
    FROM books
    WHERE series_name IS NOT NULL
) b1
JOIN (
    SELECT
        book_id
		, series_name
		, title
		, ROW_NUMBER() OVER (
            PARTITION BY series_name
            ORDER BY book_id
        ) AS rn
    FROM books
    WHERE series_name IS NOT NULL
) b2
    ON b1.series_name = b2.series_name
   AND b1.rn = b2.rn - 1
ORDER BY
    b1.series_name
	, b1.rn;

-- SELF-JOIN with CTE:
WITH ordered_books AS (
    SELECT
        book_id
		, series_name
		, title
		, ROW_NUMBER() OVER (
            PARTITION BY series_name
            ORDER BY book_id
        ) AS rn
    FROM books
    WHERE series_name IS NOT NULL
)
SELECT
    b1.series_name
	, b1.title AS book
	, b2.title AS next_book
FROM ordered_books b1
JOIN ordered_books b2
    ON b1.series_name = b2.series_name
   AND b1.rn = b2.rn - 1
ORDER BY
    b1.series_name
	, b1.rn;