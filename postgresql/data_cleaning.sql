-- DATA CLEANING AND QUALITY VALIDATION

/*
This script simulates common data quality issues
and demonstrates how they can be detected,
cleaned, and validated.
*/

UPDATE books_backup
SET title = NULL
WHERE book_id = 2;

UPDATE books_backup
SET title = '  Example Book 3  '
WHERE book_id = 3;

UPDATE authors_backup
SET author_first_name = 'fictional'
WHERE author_id = 1;

UPDATE authors_backup
SET author_experience = NULL
WHERE author_id = 2;

UPDATE authors_backup
SET genre = 'unknown'
WHERE author_id = 3;

/*
Profile the raw data to identify records that require cleaning
The checks below look for missing values, formatting issues,
and non-standard category values.
*/
SELECT *
FROM books_backup
WHERE title IS NULL
   OR title <> TRIM(title);

SELECT *
FROM authors_backup
WHERE author_experience IS NULL
   OR genre = 'unknown'
   OR author_first_name <> INITCAP(author_first_name);
   
/*
Create cleaned working copies of the raw tables
This preserves the original data and follows a
common RAW → CLEAN transformation approach.
*/
CREATE TABLE books_clean AS
SELECT *
FROM books_backup;

CREATE TABLE authors_clean AS
SELECT *
FROM authors_backup;


/*
Standardize text values, replace missing values,
and normalize categories to improve data consistency.
*/
UPDATE books_clean
SET title = TRIM(COALESCE(title, 'Unknown Title'));

UPDATE authors_clean
SET author_first_name = INITCAP(TRIM(author_first_name));

UPDATE authors_clean
SET author_experience = COALESCE(author_experience, 'unknown');

UPDATE authors_clean
SET genre = 'Other'
WHERE genre = 'unknown';

-- Validate the cleaned data
SELECT COUNT(*) AS null_titles
FROM books_clean
WHERE title IS NULL;

SELECT COUNT(*) AS invalid_genres
FROM authors_clean
WHERE genre NOT IN ('Fiction', 'Non-Fiction', 'Other');

-- Review the final cleaned datasets
SELECT *
FROM books_clean;

SELECT *
FROM authors_clean;