-- DATA FILTERING AND CONDITIONAL LOGIC: CASE, WHERE, AND/OR, IN, BETWEEN

-- Categorize individual books by page count using CASE and BETWEEN conditions;
-- assign each book to a length group: Short, Medium, Long, or Huge
SELECT
    title
	, pages
	, CASE
     	WHEN pages < 300 THEN 'Short'
        WHEN pages BETWEEN 300 AND 599 THEN 'Medium'
        WHEN pages BETWEEN 600 AND 899 THEN 'Long'
        ELSE 'Huge'
    END AS book_length
FROM books
ORDER BY pages DESC;

-- Analyze book length categories and calculate count and
-- page statistics (min, avg, max, total) using CASE-based grouping
SELECT
    CASE
        WHEN pages < 300 THEN 'Short'
        WHEN pages BETWEEN 300 AND 599 THEN 'Medium'
        WHEN pages BETWEEN 600 AND 899 THEN 'Long'
        ELSE 'Huge'
    END AS book_length
	, COUNT(*) AS books_count
	, ROUND(MIN(pages), 0) AS min_pages
	, ROUND(AVG(pages), 0) AS avg_pages
	, ROUND(MAX(pages), 0) AS max_pages
	, ROUND(SUM(pages), 0) AS sum_pages
FROM books
GROUP BY book_length
ORDER BY avg_pages;

-- Identify books that are either very short or highly popular format candidates
SELECT
    title
	, pages
FROM books
WHERE pages < 300
   OR pages > 900
ORDER BY pages DESC;

-- Analyze book consumption segments:
-- compare extreme categories (Short and Huge)
SELECT
    CASE
        WHEN pages < 300 THEN 'Short'
        WHEN pages BETWEEN 300 AND 599 THEN 'Medium'
        WHEN pages BETWEEN 600 AND 899 THEN 'Long'
        ELSE 'Huge'
    END AS reading_segment,

    COUNT(*) AS books_count,
    ROUND(AVG(pages), 0) AS avg_pages,
    MIN(pages) AS min_pages,
    MAX(pages) AS max_pages
FROM books
WHERE
    pages < 300
    OR pages > 899
GROUP BY
    CASE
        WHEN pages < 300 THEN 'Short'
        WHEN pages BETWEEN 300 AND 599 THEN 'Medium'
        WHEN pages BETWEEN 600 AND 899 THEN 'Long'
        ELSE 'Huge'
    END
ORDER BY books_count DESC;


-- Retrieve highly rated books in selected formats using AND and IN operators
SELECT
    title
    , format
    , rating
FROM books
WHERE format IN ('Ebook', 'Audio')
    AND rating >=5
ORDER BY rating DESC;


-- Retrieve books from selected reading months using the IN operator
SELECT
    title
	, month_read
	, rating
FROM books
WHERE month_read IN ('January', 'February', 'March')
ORDER BY month_read, rating DESC;