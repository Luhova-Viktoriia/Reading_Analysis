-- PATTERN MATCHING LIKE, ILIKE and Regular Expressions (~*) - REGEX

/*
these queries are logically identical in purpose,
but use different SQL pattern-matching approaches:
*/

-- LIKE (case-sensitive search)
SELECT
	subgenre
FROM subgenres
WHERE subgenre LIKE '%міфолог%'

-- ILIKE (case-insensitive search)
SELECT
	subgenre
FROM subgenres
WHERE subgenre ILIKE '%Міфолог%'

-- Regex (~*) for flexible text search
SELECT 
	subgenre
FROM subgenres
WHERE subgenre ~* 'Міфолог';


/*
LIKE: detects titles containing an apostrophe
preceded by any single character
*/
SELECT
    title
FROM books
WHERE title LIKE '%_''%';

-- LIKE: finds author last names containing a hyphen (compound surnames)
SELECT
    author_last_name
FROM authors
WHERE author_last_name LIKE '%-%';

-- ILIKE: finds subgenres starting with a specific prefix ("історико-")
SELECT
    subgenre
FROM subgenres
WHERE subgenre ILIKE 'історико-%';

/*
ILIKE: case-insensitive search for series names
ending with a specific phrase ("і ко")
*/
SELECT
    series_name
FROM series
WHERE series_name ILIKE '% і ко';

/*
LIKE: returns distinct genre–subgenre pairs where either value exactly matches "роман"
used to filter and inspect specific genre classification entries in the dataset
*/
SELECT DISTINCT
    g.genre,
    sg.subgenre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE g.genre LIKE 'роман'
   OR sg.subgenre LIKE 'роман'
ORDER BY g.genre, sg.subgenre;

/*
ILIKE: returns books where genre or subgenre
contains the full word "роман" aggregated with
all related genre–subgenre combinations per book
*/
SELECT
    b.title,
    STRING_AGG(
        DISTINCT sg.subgenre || ' ' || g.genre,
        ', '
    ) AS subgenre_genre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE sg.subgenre ILIKE '%роман%'
   OR g.genre ILIKE '%роман%'
GROUP BY b.title
ORDER BY b.title;


/*
ILIKE: returns books where "роман" appears
only as part of a longer word (e.g., "романтичний"),
excluding cases where "роман" is a standalone word
*/
SELECT
    b.title,
    STRING_AGG(
        DISTINCT sg.subgenre || ' ' || g.genre,
        ', '
    ) AS subgenre_genre
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE (
        (sg.subgenre ILIKE '%роман%' AND sg.subgenre NOT ILIKE 'роман')
     OR (g.genre ILIKE '%роман%' AND g.genre NOT ILIKE 'роман')
)
GROUP BY b.title
ORDER BY b.title;

/*
Regex (~*): filters rows where genre or subgenre is exactly "роман" (case-insensitive),
then counts books per genre–subgenre combination
*/
SELECT
    g.genre,
    sg.subgenre,
    COUNT(DISTINCT b.book_id) AS books_count
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
JOIN subgenres sg
    ON gb.subgenre_id = sg.subgenre_id
WHERE g.genre ~* '^роман$'
   OR sg.subgenre ~* '^роман$'
GROUP BY
    g.genre,
    sg.subgenre
ORDER BY
    books_count DESC,
    g.genre,
    sg.subgenre;