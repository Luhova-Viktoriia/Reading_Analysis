-- CTE AND WINDOW FUNCTIONS

/*
Demonstrates a common analytical pattern:
basic aggregation in a CTE followed by window function analysis.
*/
WITH series_stats AS (
    SELECT
        s.series_name
		, s.total_books_in_series
		, ROUND(
            COUNT(b.book_id)::numeric / NULLIF(s.total_books_in_series, 0) * 100,
            1
        ) AS completion_pct
		, AVG(b.rating) AS avg_rating
    FROM series s
    LEFT JOIN books b
        ON s.series_id = b.series_id
    GROUP BY
        s.series_name
		, s.total_books_in_series
)

SELECT
    series_name
	, total_books_in_series
	, completion_pct
	, ROUND(avg_rating, 2) AS avg_rating
	, ROW_NUMBER() OVER (ORDER BY completion_pct DESC) AS completion_row_num  -- unique row numbering
	, RANK() OVER (ORDER BY completion_pct DESC) AS completion_rank -- rank with gaps for tied values
	, DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS quality_dense_rank -- ranking without gaps for tied values

FROM series_stats;


/*
Ranks books by rating within each genre using RANK().
Books with the same rating receive the same rank,
and subsequent ranks contain gaps.
*/
SELECT
    g.genre
	, b.title
	, b.rating
	, RANK() OVER (
        PARTITION BY g.genre
        ORDER BY b.rating DESC
    ) AS genre_rank
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
WHERE b.rating IS NOT NULL
ORDER BY g.genre, genre_rank;

/*
Compares each book's rating to the genre average.
Positive values indicate above-average ratings, negative values
indicate below-average ratings, and zero indicates the genre average.
*/
SELECT
    g.genre
	, b.title
	, b.rating
	, ROUND(
        AVG(b.rating) OVER (PARTITION BY g.genre), 2
    ) AS avg_genre_rating
	, ROUND(
        b.rating - AVG(b.rating) OVER (PARTITION BY g.genre), 2
    ) AS rating_difference
FROM books b
JOIN genres_to_books gb
    ON b.book_id = gb.book_id
JOIN genres g
    ON gb.genre_id = g.genre_id
WHERE b.rating IS NOT NULL;


/*
Calculates a running total of pages read over time by joining books
with dim_months to ensure correct chronological ordering via
month_number (instead of alphabetical order) and using SUM() OVER()
to accumulate pages across months and book titles.
*/
SELECT
    b.month_read
	, b.title
	, b.pages
	, SUM(b.pages) OVER (
        ORDER BY
            dm.month_number
			, b.title
    ) AS running_total_pages
FROM books b
JOIN dim_months dm
    ON b.month_read = dm.month_name
ORDER BY
    dm.month_number
	, b.title;