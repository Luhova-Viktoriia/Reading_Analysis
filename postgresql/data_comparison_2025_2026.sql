-- DATA COMPARISON: H1 2025 vs H1 2026

SELECT *
FROM books_2026_h1
ORDER BY book_id;

-- comparison of books read per month in the first half of 2025 vs 2026
SELECT
    month_name
	, books_2025
	, books_2026
FROM (
    SELECT
        m.month_number
		, m.month_name
		, COUNT(b.book_id) FILTER (WHERE b.source_year = '2025') AS books_2025
		, COUNT(b.book_id) FILTER (WHERE b.source_year = '2026') AS books_2026
		, m.month_number AS sort_order
    FROM dim_months m
    LEFT JOIN (
        SELECT book_id, month_read, '2025' AS source_year FROM books
        UNION ALL
        SELECT book_id, month_read, '2026' AS source_year FROM books_2026_h1
    ) b
    ON b.month_read = m.month_name
    WHERE m.month_number BETWEEN 1 AND 6
    GROUP BY m.month_number, m.month_name
    UNION ALL
    SELECT
        NULL AS month_number
		,'TOTAL' AS month_name
		, COUNT(*) FILTER (WHERE source_year = '2025') AS books_2025
		, COUNT(*) FILTER (WHERE source_year = '2026') AS books_2026
		, 999 AS sort_order
    FROM (
        SELECT book_id, month_read, '2025' AS source_year FROM books
        UNION ALL
        SELECT book_id, month_read, '2026' AS source_year FROM books_2026_h1
    ) b2
    WHERE month_read IN (
        SELECT month_name
        FROM dim_months
        WHERE month_number BETWEEN 1 AND 6
    )
) final
ORDER BY sort_order;
/*
SUMMARY: the results show a stable reading pace compared to last year (44 vs 45 books),
allowing tracking of reading dynamics and potential forecasting of total books read in 2026
*/


-- summary of minimum, maximum, and average monthly book counts for H1 2025 vs H1 2026
WITH monthly_counts AS (
    SELECT
        m.month_number
		, m.month_name
		, COUNT(b.book_id) FILTER (WHERE b.source_year = '2025') AS books_2025
		, COUNT(b.book_id) FILTER (WHERE b.source_year = '2026') AS books_2026
    FROM dim_months m
    LEFT JOIN (
        SELECT book_id, month_read, '2025' AS source_year FROM books
        UNION ALL
        SELECT book_id, month_read, '2026' AS source_year FROM books_2026_h1
    ) b
    ON b.month_read = m.month_name
    WHERE m.month_number BETWEEN 1 AND 6
    GROUP BY m.month_number, m.month_name
)
SELECT
    'H1 2025–2026' AS period
	, MIN(LEAST(books_2025, books_2026)) AS min_monthly_books
	, MAX(GREATEST(books_2025, books_2026)) AS max_monthly_books
	, ROUND (AVG(books_2025), 2) AS avg_books_2025
	, ROUND (AVG(books_2026), 2) AS avg_books_2026
FROM monthly_counts;
/*
The results show that the minimum and maximum monthly reading values are
identical across H1 2025 and H1 2026, while the average values differ slightly
between the two periods, indicating a small change in reading intensity
*/


/*
Comparison of books read by format in H1 2025 vs H1 2026,
including absolute difference and trend direction
*/
SELECT
    b.format
	, COUNT(*) FILTER (WHERE b.source_year = '2025') AS books_2025
	, COUNT(*) FILTER (WHERE b.source_year = '2026') AS books_2026
	, (
        COUNT(*) FILTER (WHERE b.source_year = '2026')
        - COUNT(*) FILTER (WHERE b.source_year = '2025')
    ) AS books_diff,
    CASE 
        WHEN COUNT(*) FILTER (WHERE b.source_year = '2026') 
           > COUNT(*) FILTER (WHERE b.source_year = '2025')
        THEN 'increase'
        WHEN COUNT(*) FILTER (WHERE b.source_year = '2026') 
           < COUNT(*) FILTER (WHERE b.source_year = '2025')
        THEN 'decrease'
        ELSE 'no change'
    END AS trend
FROM (
    SELECT 
        book_id
		, format
		, month_read
		, '2025' AS source_year
    FROM books
    UNION ALL
    SELECT 
        book_id
		, format
		, month_read
		,'2026' AS source_year
    FROM books_2026_h1
) b
JOIN dim_months m
    ON b.month_read = m.month_name
WHERE m.month_number BETWEEN 1 AND 6
GROUP BY b.format;
/*
SUMMARY: the results show a shift in my reading format preferences:
audiobooks led the way in 2025, while e-books became more popular in 2026,
while print books remained stable.
*/


/*
this query identifies authors whose books were read in both 2025 and 2026,
enabling a cross-year comparison of reading patterns at the author level
author matching is based on a composite key (first name + last name)
to avoid ambiguity caused by duplicate last names across different authors
*/
WITH a2025 AS (
    SELECT
        a.author_first_name
		, a.author_last_name
		, (a.author_first_name || ' ' || a.author_last_name) AS author_full_name
		, COUNT(b.book_id) AS books_2025
    FROM authors a
    JOIN authors_to_books ab
        ON ab.author_id = a.author_id
    JOIN books b
        ON b.book_id = ab.book_id
    GROUP BY
        a.author_first_name
		, a.author_last_name
),

a2026 AS (
    SELECT
        author_first_name
		, author_last_name
		, (author_first_name || ' ' || author_last_name) AS author_full_name
		, COUNT(book_id) AS books_2026
    FROM books_2026_h1
    GROUP BY
        author_first_name
		, author_last_name
)

SELECT
    a2025.author_full_name
	, a2025.books_2025
	, a2026.books_2026
	, COALESCE(a2025.books_2025, 0)
    + COALESCE(a2026.books_2026, 0) AS total_books
FROM a2025
JOIN a2026
    ON a2025.author_first_name = a2026.author_first_name
   AND a2025.author_last_name = a2026.author_last_name
ORDER BY total_books DESC, author_full_name;

/*
comparison of pages read in H1 2025 and H1 2026,
summarizing total, min, avg, and max monthly reading volume
*/
WITH monthly_pages AS (
    SELECT
        m.month_number
		, m.month_name
		, SUM(b.pages) FILTER (WHERE b.source_year = '2025') AS pages_2025
		, SUM(b.pages) FILTER (WHERE b.source_year = '2026') AS pages_2026
    FROM dim_months m
    LEFT JOIN (
        SELECT book_id, pages, month_read, '2025' AS source_year
        FROM books
		
        UNION ALL
		
        SELECT book_id, pages, month_read, '2026' AS source_year
        FROM books_2026_h1
    ) b
    ON b.month_read = m.month_name
    WHERE m.month_number BETWEEN 1 AND 6
    GROUP BY m.month_number, m.month_name
)

SELECT
    '2025' AS year
	, SUM(pages_2025) AS total_pages
	, MIN(pages_2025) AS min_monthly_pages
	, ROUND(AVG(pages_2025), 0) AS avg_monthly_pages
	, MAX(pages_2025) AS max_monthly_pages
FROM monthly_pages

UNION ALL

SELECT
    '2026' AS year
	, SUM(pages_2026) AS total_pages
	, MIN(pages_2026) AS min_monthly_pages
	, ROUND(AVG(pages_2026), 0) AS avg_monthly_pages
	, MAX(pages_2026) AS max_monthly_pages
FROM monthly_pages
ORDER BY year;


-- Finds publication years that appear in both H1 2025 and H1 2026 reading datasets
WITH combined AS (
    SELECT year_publ, '2025' AS source_year
    FROM books

    UNION ALL

    SELECT year_publ, '2026' AS source_year
    FROM books_2026_h1
),

year_flags AS (
    SELECT
        year_publ
		, COUNT(DISTINCT source_year) AS years_present
    FROM combined
    GROUP BY year_publ
)

SELECT
    year_publ
FROM year_flags
WHERE years_present = 2
ORDER BY year_publ;

/*
Comparison of book publication years between H1 2025 and H1 2026,
identifying shared publication years and comparing min, avg,
and max publication years
*/
SELECT
    '2025' AS period
	, MIN(year_publ) AS min_year_publ
	, ROUND (AVG(year_publ), 0) AS avg_year_publ
	, MAX(year_publ) AS max_year_publ
FROM books

UNION ALL

SELECT
    '2026' AS period
	, MIN(year_publ) AS min_year_publ
	, ROUND (AVG(year_publ), 0) AS avg_year_publ
	, MAX(year_publ) AS max_year_publ
FROM books_2026_h1;