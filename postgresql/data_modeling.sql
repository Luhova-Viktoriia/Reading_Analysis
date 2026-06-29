-- DATA MODELING: PRIMARY KEY, FOREIGN KEY, MANY TO MANY RELATIONSHIP


-- DATA MODELING

/*
Primary key for uniqueness of relationships
ALTER TABLE: defines a composite primary key
to ensure uniqueness of authors-books relationships
*/
ALTER TABLE authors_to_books_backups
ADD CONSTRAINT authors_to_books_backups_pk
PRIMARY KEY (author_id, book_id);

/*
Foreign key: authors
ALTER TABLE: creates a foreign key relationship
to enforce referential integrity with authors table
*/
ALTER TABLE authors_to_books_backups
ADD CONSTRAINT fk_author
FOREIGN KEY (author_id)
REFERENCES authors_backup(author_id)
ON DELETE CASCADE;

/*
Foreign key: books
ALTER TABLE: creates a foreign key relationship
to enforce referential integrity with books table
*/
ALTER TABLE authors_to_books_backups
ADD CONSTRAINT fk_book
FOREIGN KEY (book_id)
REFERENCES books_backup(book_id)
ON DELETE CASCADE;

--MANY-TO-MANY RELATIONSHIP

/*
Many-to-many relationship example using a bridge table (authors_to_books_backups).
Author 1 is linked to multiple books, while Book 2 has multiple authors,
demonstrating how the bridge table connects authors_clean and books_clean via foreign keys.
*/
SELECT
    a.author_first_name,
    a.author_last_name,
    b.title
FROM authors_clean a
JOIN authors_to_books_backups ab
    ON a.author_id = ab.author_id
JOIN books_clean b
    ON b.book_id = ab.book_id
ORDER BY a.author_id;
/*
Note: using original bridge table as it contains only structural relationships (IDs),
while data quality transformations are applied only to entity tables (authors_clean, books_clean)
*/
