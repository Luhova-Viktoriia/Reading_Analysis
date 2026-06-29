-- SET OPERATIONS: UNION, UNION ALL, INTERSECT, EXCEPT

/*
UNION
Unique languages of books read in 2025
using UNION (removes duplicates)
and All Books using UNION ALL (duplicates expected)
*/
SELECT
	'Ukrainian' AS reading_language_2025
FROM books
WHERE book_language = 'Ukrainian'

UNION

SELECT
	'English' AS reading_language_2025
FROM books
WHERE book_language = 'English';

/*
UNION ALL
Classify books as Series, Standalone
and All Books using UNION ALL (duplicates expected)
*/
SELECT title, 'Series' AS category
FROM books
WHERE series_name IS NOT NULL

UNION ALL

SELECT title, 'Standalone' AS category
FROM books
WHERE series_name IS NULL

UNION ALL

SELECT title, 'All Books' AS category
FROM books;

/*
INTERSECT
Identify genres present in both series
and standalone books using INTERSECT
*/
SELECT DISTINCT g.genre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
WHERE b.series_name IS NOT NULL

INTERSECT

SELECT DISTINCT g.genre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
WHERE b.series_name IS NULL;

/*
EXCEPT
Identify subgenres unique to series books by excluding
subgenres associated with standalone books using EXCEPT
*/
SELECT DISTINCT sg.subgenre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE b.series_name IS NOT NULL

EXCEPT

SELECT DISTINCT sg.subgenre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE b.series_name IS NULL;