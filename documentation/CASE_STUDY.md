# 1. INTRODUCTION

**Book Reading Analytics** is an end-to-end data analytics case study built around a real-world book reading dataset that I personally maintain and continuously update. It demonstrates the complete analytical workflow – from data collection and relational database design to SQL analysis and interactive Power BI reporting.
The project was designed to simulate the responsibilities of a Data Analyst working with a real dataset. It goes beyond individual SQL queries or dashboard development and focuses on the full analytics lifecycle: from raw data organization and relational database design to data validation, analytical querying and interactive visualization of insights.
Rather than presenting only the final solution, this project also documents the design decisions, challenges encountered and the reasoning behind each improvement, reflecting how the analytical model evolved throughout development.

Throughout the project, I used Excel, PostgreSQL, DBeaver, Power BI and Git to build a structured, well-documented analytics solution that can continue to evolve as new data becomes available.
## Project Scope

The repository covers the full end-to-end analytical workflow, including:

- Data collection and preparation from raw Excel sources (initial dataset maintained in Excel and structured into a tabular format before database import, including standardization of columns such as  `title`, `author_last_name`, `author_first_name` etc.)
- Relational data modeling and database design (design of a normalized PostgreSQL schema with separate tables for `books`, `authors`, and a many-to-many relationship implemented via the bridge tables `authors_to_books` and `genres_to_books`)
- Data cleaning, validation and quality assurance (handling missing values, standardizing categorical fields, ensuring consistent formats and preventing duplicate primary key issues during re-imports)
- SQL-based data exploration and analytical querying (use of aggregations, CTEs, conditional logic and joins to analyze reading behavior, author frequency and book characteristics)
- Time-based comparative analysis (H1 2025 vs H1 2026) (year-over-year comparison of reading activity, including monthly trends, format distribution and total book counts across periods)
- Data visualization and interactive reporting in Power BI (development of an interactive dashboard with filters, slicers and dynamic visuals for exploring reading patterns across multiple dimensions)
- Documentation, version control and project structuring (structured GitHub repository with clear folder hierarchy, version-controlled SQL and data files and comprehensive documentation including `README` and `CASE STUDY`).
This structure reflects a complete analytics pipeline, from raw data ingestion to final insight delivery.

# 2. WHY THIS DATASET?

Many portfolio projects rely on publicly available datasets, which are valuable for learning but often lead to repetitive analyses and similar dashboard outcomes.

For this project, I chose a dataset that I personally maintain and continuously update. This gives me full understanding of how the data is collected, allows me to ensure its consistency and makes it possible to extend the project over time as new data is added.

Working with a self-maintained dataset enabled me to focus on more than just PostgreSQL or Power BI implementation. It required designing a realistic database structure, making deliberate analytical decisions and building a solution that can evolve beyond a static portfolio project.

Unlike anonymized sample data, each record represents a real book I have read, which makes the analysis more contextual and interpretable. The dataset covers a wide range of genres, authors and formats, allowing the project to reflect both analytical insights and personal reading diversity.

# 3. PROJECT OBJECTIVES

The primary goal of this project was to simulate a realistic end-to-end analytics workflow using a dataset that evolves over time. Rather than solving isolated SQL tasks, I wanted to build a complete analytical solution that reflects the responsibilities of a Data Analyst working with structured data.

The project objectives were to:

- Design a normalized relational database from raw Excel data.

- Build a scalable data model that supports future data expansion.

- Perform data cleaning and validation before analysis.

- Write efficient SQL queries to answer analytical and business-oriented questions.

- Compare reading trends across different time periods.

- Create interactive Power BI dashboards to communicate insights.

- Document the project structure, design decisions and analytical workflow following best practices for GitHub portfolio projects.

By completing these objectives, the project demonstrates not only technical skills but also an analytical approach to data organization, problem-solving and documentation.

# 4. DATABASE DESIGN

## Database Design Principles

The database was designed to support scalable analysis while ensuring consistency, integrity and long-term maintainability.

Rather than storing all information in a single table, I designed a normalized relational database that separates books, authors and supporting entities into dedicated tables connected through primary and foreign keys. This approach reduces redundancy, improves data consistency and preserves data integrity.

The resulting schema provides a flexible foundation for PostgreSQL analysis, Power BI reporting and future database expansion.

## Naming Conventions

To ensure consistency, readability and maintainability, the database follows a set of naming conventions:

- Table names use plural nouns, as each table stores a collection of entities (e.g. `books`, `authors`, `genres`, `series`, `subgenres`).

- Column names use singular nouns where appropriate to represent individual attributes (e.g. `title`, `format`, `genre`, `subgenre`).

- Primary and foreign keys follow the `<entity>_id` naming convention (e.g. `book_id`, `author_id`, `genre_id`), making relationships between tables easy to identify.

- All database objects use `snake_case` naming for consistency.

- Descriptive names are used to avoid conflicts with SQL reserved keywords. For example, `book_language` is used instead of `language` and `year_publ` instead of `year`.

## Data Types

Data types were selected according to the nature of each attribute. Text fields are used for descriptive values such as `title`, `genre` and `series_name`, integer fields store numerical values including `pages`, `year_publ`, `month_number` and `rating`, while boolean fields represent logical attributes such as `is_recommended`, `is_owned`, `gender` and `is_favorite`.

## Database Schema Overview

The schema consists of several groups of tables, each serving a specific role within the analytical workflow.

### Main Tables

- **`books`**

  The central table containing one record per book. It stores bibliographic information together with reading-related attributes, including publication year, number of pages, reading format, reading month, personal rating and other analytical fields.

- **`authors`**

  Stores a unique record for each author, including descriptive attributes such as first name, last name and gender, enabling author-level analysis.

- **`series`**

  Contains one record for each book series, including the series name, total number of books, the number of books completed, the remaining books to read and the entry point within the series where my reading journey began in 2025. This enables progress tracking and series-level analysis.

- **`genres`**

  Stores the primary genres represented in the dataset.

- **`subgenres`**

  Provides a more detailed categorization of books, enabling deeper analysis beyond the primary genre level.

### Bridge Tables

- **authors_to_books**  
  Implements the many-to-many relationship between books and authors, allowing a single book to have multiple authors while ensuring that each author is stored only once. This table contains two columns: `author_id` and `book_id`.

- **genres_to_books**  
  Implements the many-to-many relationship between books and genres. A single book may belong to multiple genres, making this approach more flexible than storing genres in a single column. Unlike `authors_to_books`, this table contains three columns: `book_id`, `genre_id` and `subgenre_id`.

### Dimension Table

- **`dim_months`**

  A calendar dimension that assigns each month a numerical order and serves as the project's reusable time dimension.

  Using a dedicated dimension table ensures correct chronological sorting in PostgreSQL queries and Power BI visualizations, avoids alphabetical ordering of month names and provides a scalable foundation for comparative and future time-based analyses.

### Reference Table

- **`favorite_authors`**

  Stores a curated list of favorite authors using references to the `authors` table. Although it is not required for the core analytical workflow, it demonstrates how supplementary reference data can be integrated into the database for additional analyses, filtering or future dashboard enhancements.

### Data Preparation Tables

To demonstrate a complete data preparation workflow, the project includes several tables representing different stages of data processing.

- **`books_backup`** and **`authors_backup`**

  Copies of the original datasets used to introduce intentionally inconsistent or incomplete data (e.g., missing values, formatting issues and duplicate records). These tables provide the starting point for demonstrating data cleaning techniques without modifying the production data.

- **`authors_to_books_backup`**

  A backup version of the bridge table used to demonstrate the creation and maintenance of many-to-many relationships during database modeling.

- **`books_clean`** and **`authors_clean`**

  Contain the cleaned versions of the backup datasets after applying validation and transformation steps. They illustrate the transition from raw to analysis-ready data.

### Staging Table

- **`books_2026_h1`**

  A staging table containing reading data for the first half of 2026. It is used for year-over-year comparison with the primary `books` table while keeping the production dataset unchanged.

Separating production, backup, cleaned and staging tables preserves data integrity, makes the analytical workflow reproducible and clearly documents each stage of data preparation.

# 5. Database Evolution

Like many real-world analytics projects, this database was developed iteratively rather than being designed in its final form from the beginning. As new analytical requirements emerged, the database structure was gradually refined to improve **normalization, scalability, maintainability and analytical flexibility**.

The following sections summarize the major design improvements introduced during the project's evolution.

## Time Dimension

Initially, chronological ordering was handled using a `month_number` column stored directly in the `books` table.

As the project expanded to include comparative analysis between **H1 2025** and **H1 2026**, this approach was replaced with a dedicated `dim_months` dimension table.

To preserve compatibility with the existing analytical model and previously developed SQL queries, the original `month_number` column remained in the `books` table. The newly imported `books_2026_h1` dataset, however, relies exclusively on the `dim_months` table for month ordering.

This reflects a common real-world practice of evolving a database design while maintaining backward compatibility with existing analytical workflows.

## Many-to-Many Relationships

The initial database assumed that each book belonged to a single author and a single genre.

As the dataset expanded, dedicated bridge tables were introduced:

- `authors_to_books`
- `genres_to_books`

These bridge tables were implemented to:

- model many-to-many relationships
- eliminate duplicated information
- improve data normalization
- increase the flexibility of SQL queries

## Data Preparation Workflow

Rather than modifying the original datasets directly, separate **backup** and **cleaned** tables were created.

This approach:

- preserves the raw source data
- documents every transformation step
- makes the data cleaning process transparent
- ensures the ETL workflow remains fully reproducible

## Comparative Analysis

The project initially focused on a single reading dataset.

As additional reading data became available, a dedicated staging table (`books_2026_h1`) was introduced to support year-over-year comparisons while keeping the primary production dataset unchanged.

This separation allows new datasets to be:

- analyzed independently
- validated before integration
- incorporated into the analytical model only after verification

## Evolution Summary

The database evolved incrementally as the project became more sophisticated. Rather than redesigning the schema from scratch, each enhancement was introduced to address a specific analytical requirement while preserving compatibility with the existing structure.

Key improvements include:

- introducing dimension tables for improved scalability
- implementing bridge tables to support many-to-many relationships
- separating raw, cleaned, and production datasets
- extending the model to support comparative analysis
- maintaining backward compatibility throughout the database evolution

Overall, these iterative improvements demonstrate an approach to database development that prioritizes **scalability, maintainability, extensibility and analytical integrity**—principles commonly applied in real-world data analytics projects.

# 6. Data Collection & Import

## Overview

The dataset was initially maintained in Microsoft Excel, where each row represents a single book and its associated reading information. This raw tabular structure reflects how reading data is typically collected before being transformed into a normalized relational database.

Before importing the data into PostgreSQL, the dataset was reviewed and standardized to ensure consistent formatting, naming conventions, and attribute values across all records. This preparation included validation of author information, reading dates, publication metadata and other book attributes.

Once imported, the data was ready for validation, cleaning, transformation and subsequent analytical processing using SQL and Power BI.

## Data Import Workflow

The import process followed a structured ETL workflow consisting of the following stages:

1. **Raw data collection**
  - Reading data maintained in Microsoft Excel, with each row representing a single book and its associated metadata.

2. **CSV export**
  - Exported to a comma-separated values (CSV) file using UTF-8 encoding compatible with PostgreSQL.

3. **Schema validation**
  - Verified alignment between the CSV file and the predefined database schema, including:
    - column order
    - data types
    - naming conventions
    - integrity constraints

4. **Bulk data import**
  - Imported into PostgreSQL using the `COPY` command for efficient batch loading.

5. **Import verification**
  - Confirmed successful import by validating:
    - record counts
    - primary keys
    - table constraints
    - overall data integrity

6. **Incremental data loading**
  - Imported additional datasets (e.g., `books_2026_h1`) into dedicated staging tables, allowing independent validation and comparative analysis without affecting the production dataset.

## ETL Perspective

This workflow follows a typical **Extract–Transform–Load (ETL)** process:

- **Extract** – collect raw reading data from Excel.
- **Transform** – standardize, validate and prepare the data for analysis.
- **Load** – import validated datasets into PostgreSQL for SQL querying and Power BI reporting.

This approach ensures a transparent, reproducible and scalable data ingestion process suitable for analytical workflows.

# 7. Data Cleaning

## Overview

Data cleaning was performed to ensure data quality, consistency and analytical reliability across both PostgreSQL queries and Power BI visualizations.

The cleaning process focused on improving data consistency, preserving referential integrity and preparing the dataset for accurate aggregation, reporting and time-based analysis.

## Data Cleaning Tasks

### Text Standardization

Standardized textual attributes to ensure consistent formatting across the dataset, including:

- Author names
- Book titles
- Reading formats

Examples:

- Applied **Title Case** formatting to book titles while preserving the correct capitalization of proper nouns.
- Manually reviewed and corrected individual records to eliminate inconsistencies.

### Missing Values

Handled missing and incomplete values where appropriate by:

- Identifying `NULL` values in optional fields
- Imputing missing values when possible
- Preserving `NULL` values when they represented valid unknown information

Examples include:

- Ratings
- Reading dates

### Date & Numeric Standardization

Standardized date and numeric fields to support reliable calculations and time-based analysis.

Examples:

- Converted date values into a consistent `DATE` format
- Validated numeric fields used for aggregations and reporting

### Duplicate Prevention

Implemented deduplication techniques to prevent duplicate records from affecting analytical results and database constraints.

SQL techniques included:

- `DISTINCT`
- `ROW_NUMBER() OVER (PARTITION BY ...)`
- Common Table Expressions (CTEs)

These approaches improved query readability while supporting controlled duplicate detection and removal.

### Category Standardization

Standardized categorical values to ensure reliable grouping and aggregation.

Example:

| Original Values | Standardized Value |
|-----------------|--------------------|
| `ebook`, `e-book`, `EBOOK` | `Ebook` |

## Data Integrity

Special attention was given to maintaining referential integrity across the relational model, particularly within the many-to-many relationships between books, authors and genres.

Additionally, staging tables (e.g., `books_2026_h1`) were used to validate newly imported datasets before incorporating them into the analytical workflow. This approach enabled controlled updates while preserving the integrity of existing analyses.

## Outcome

The data cleaning process resulted in:

- Improved data consistency
- Reliable aggregations and KPI calculations
- Accurate time-based analysis
- Preserved referential integrity
- Reproducible data preparation workflow
- High-quality datasets for SQL analysis and Power BI reporting

# 8. Data Modeling

## Overview

The data model was designed to transform raw reading data into a normalized relational structure optimized for PostgreSQL queries and Power BI reporting.

The model separates analytical, descriptive and relationship data into dedicated tables, improving scalability, maintainability and analytical flexibility while ensuring consistent aggregations and efficient filtering.

## Data Model Structure

### `books` — Analytical Core Table

The `books` table serves as the primary analytical table and contains one record per book.

It is the main source for quantitative analysis and supports:

- KPI calculations
- Aggregations
- Time-based analysis
- Power BI measures

Typical metrics include:

- `COUNT()` of books
- `SUM()` of pages read
- `AVG()` rating
- Reading trends by month and publication year

### `authors` — Reference Table

Stores unique author records used as descriptive metadata.

Primary purposes:

- Filtering and segmentation
- Grouping books by author
- Providing descriptive context for analysis

This table does not contain numerical measures and is not aggregated directly.

### `genres` & `subgenres` — Classification Tables

Store the hierarchical classification of books.

They provide:

- Genre-based filtering
- Subgenre drill-down analysis
- Consistent categorization across SQL queries and Power BI reports

### `authors_to_books` — Bridge Table

Implements the many-to-many relationship between books and authors.

This table enables:

- Accurate aggregation for books with multiple authors
- Flexible grouping at both book and author levels
- Elimination of duplicated author information

Although it is not aggregated directly, it is essential for maintaining relational integrity.

### `genres_to_books` — Bridge Table

Implements the many-to-many relationship between books, genres and subgenres.

It supports:

- Books belonging to multiple genres
- Genre and subgenre hierarchy
- Flexible filtering and cross-analysis in Power BI

This design allows books to be analyzed across multiple classification dimensions without introducing redundancy.

### `dim_months` — Time Dimension

A dedicated calendar dimension used to maintain chronological ordering.

It provides:

- Correct month sorting
- Time-series analysis
- Consistent reporting periods
- Support for comparative analysis across years

This table functions purely as a dimension for filtering and ordering.

## Design Principles

The data model follows several core design principles:

- Separation of analytical and reference data
- Normalization to minimize data redundancy
- Many-to-many relationships implemented through bridge tables
- Referential integrity enforced with primary and foreign keys
- Flexible filtering through dimension tables
- Scalable architecture supporting future data expansion without structural changes

## Analytical Benefits

This structure ensures:

- Consistent and reliable aggregations
- Predictable Power BI relationships
- Efficient SQL joins
- Flexible slicing and filtering
- Clean and maintainable SQL queries
- Optimized performance for analytical workloads

## Technologies Applied

- PostgreSQL relational data modeling
- Primary and foreign key constraints
- Many-to-many relationship design
- Bridge tables
- Dimension tables
- Normalization
- Power BI relationship modeling

# 9. SQL Analysis

## Overview

The SQL layer represents the analytical core of the project, where structured relational data is transformed into meaningful insights through a combination of exploratory, descriptive, comparative and time-based analyses.

SQL was used not only to retrieve data but also to validate data quality, generate analytical metrics, identify trends and prepare datasets for Power BI reporting.

## Key Analytical Areas

### Time-Based Analysis

Analyzed reading activity over time using monthly and yearly aggregations.

Examples include:

- Monthly reading trends
- Year-over-year comparisons (H1 2025 vs. H1 2026)
- Cumulative reading metrics
- Publication timeline analysis

### Comparative Analysis

Compared reading behavior across multiple datasets to identify changes in:

- Total books read
- Monthly reading distribution
- Reading format preferences
- Publication year characteristics

### Author Analysis

Analyzed author-related reading behavior, including:

- Authors appearing in both datasets
- Reading frequency by author
- Comparative author statistics across time periods

### Descriptive Statistics

Calculated summary statistics for key reading metrics, including:

- Minimum, maximum, average and median books read per month
- Total and average pages read
- Publication year distribution
- Reading activity indicators

## SQL Techniques

The project demonstrates the practical application of:

- Aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
- Conditional aggregation using `FILTER`
- Common Table Expressions (CTEs)
- `UNION ALL` for combining datasets
- Window functions (`OVER`) for cumulative calculations and ranking
- `CASE` expressions for classification and trend analysis
- `JOIN` operations across normalized tables
- `GROUP BY` and `ORDER BY` for analytical summarization
- Subqueries for intermediate analytical logic

## SQL Development Workflow

The SQL analysis was developed incrementally through several stages:

1. Exploratory queries
2. Data validation
3. Descriptive analysis
4. Comparative analysis
5. Window function calculations
6. Reusable CTE-based solutions

## Outcome

The SQL layer transforms raw relational data into a structured analytical framework capable of answering complex business questions related to reading behavior, author preferences, publication trends and year-over-year comparisons.

The resulting queries also serve as the foundation for Power BI dashboards, DAX calculations and further exploratory analysis.

# 10. Power BI Dashboards

## Overview

The Power BI layer represents the final stage of the analytical workflow, transforming structured PostgreSQL data into interactive dashboards that support exploratory analysis and data-driven storytelling.

Built on a relational data model and enhanced with DAX calculations, the dashboards enable users to explore reading behavior through dynamic filtering, interactive visualizations, and custom analytical metrics.


## Data Model

The Power BI data model is based on the normalized PostgreSQL schema, preserving relationships between analytical, reference and bridge tables.

The model includes:

- **Fact table** (`books`) containing core analytical measures such as pages, ratings, publication year, reading dates and book formats
- **Dimension tables** (`authors`, `genres`, `subgenres`, `dim_months`) providing descriptive context, filtering and hierarchical navigation
- **Bridge tables** (`authors_to_books`, `genres_to_books`) supporting many-to-many relationships without data duplication
- **Relationship-based model** enabling accurate cross-filtering, drill-down analysis and consistent DAX calculations

## Dashboard Structure

The reporting layer consists of three complementary dashboards, each focusing on a different analytical perspective.

### Dashboard 1 – Reading Behavior Analytics

Provides a comprehensive overview of reading activity through:

- KPI cards and summary statistics
- Monthly reading trends
- Reading diversity metrics
- Author preference analysis
- Publication year analysis
- Custom behavioral metrics (**Pattern** and **Taste**)

### Dashboard 2 – Reading Series Progress & Structure Analytics

Focuses on reading progress across book series by providing:

- Series completion tracking
- Genre and subgenre hierarchy
- Progress visualization
- Series-level KPIs
- Interactive filtering by rating

### Dashboard 3 – Top 30 Books: Genre & Subgenre Curation Analytics

Presents the highest-rated books of 2025 using an interactive treemap that highlights:

- Genre and subgenre relationships
- Dominant genre classification
- Custom color mapping
- Interactive cross-highlighting
- Visual comparison of thematic distribution

## Power BI Features

The dashboards demonstrate the use of:

- DAX measures for dynamic KPI calculations
- Calculated columns for classification and business logic
- Interactive slicers and filters
- Cross-filtering between visuals
- Drill-down and hierarchical navigation
- Conditional formatting
- Custom tooltips
- Treemap, matrix, KPI cards, bar, line and area charts

## Analytical Capabilities

The reporting solution enables users to:

- Monitor reading activity through interactive KPIs
- Explore monthly and yearly reading trends
- Compare reading behavior across different time periods
- Analyze authors, genres and publication years
- Track progress across book series
- Identify reading preferences using custom DAX metrics
- Perform exploratory analysis without writing SQL queries

## Outcome

The Power BI dashboards complete the end-to-end analytics pipeline by transforming SQL-based analytical outputs into an interactive reporting solution.

Together with the PostgreSQL database and SQL analysis layer, they demonstrate the full workflow of a data analytics project—from data collection and modeling to visualization and business insight generation.

# 11. Key Insights

## Overview

The project combines descriptive statistics with higher-level behavioral analysis to provide a comprehensive understanding of personal reading habits.

Rather than presenting raw metrics alone, the analytical model transforms structured data into insights about reading preferences, long-term patterns and content diversity.

## Descriptive Insights

The dashboards provide a quantitative overview of the dataset, including:

- Total books, pages, authors, genres, and subgenres
- Distribution of reading formats (Print, eBook, Audiobook)
- Publication year distribution
- Books read as part of a series versus standalone titles
- Reading activity across different months and years
- Author and genre diversity

These metrics establish the quantitative foundation for further analytical exploration.

## Behavioral Insights

Building on the descriptive metrics, the project identifies several behavioral patterns.

### Reading Preferences

- Preferred reading formats
- Favorite and most frequently read authors
- Genre and subgenre preferences
- Reading diversity across authors and genres

### Reading Behavior

- Monthly and yearly reading trends
- Balance between familiar and newly discovered authors
- Engagement with book series versus standalone books
- Publication period preferences

### Custom Analytical Metrics

The project introduces two custom DAX measures designed to compare observed reading behavior with explicitly defined personal preferences.

- **Pattern** – measures the proportion of books written by the most frequently read authors, representing habitual reading behavior.
- **Taste** – measures the proportion of books written by authors intentionally marked as favorites, representing conscious reading preferences.

Together, these metrics provide an additional interpretative layer by distinguishing between recurring reading habits and deliberate author selection.

## Analytical Value

The combination of a normalized relational database, SQL analysis and interactive Power BI dashboards makes it possible to:

- Identify long-term reading trends
- Compare reading behavior across different time periods
- Analyze relationships between authors, genres, and reading formats
- Explore reading diversity through interactive filtering
- Transform raw reading records into actionable analytical insights

## Current Limitations

While the dataset supports comprehensive descriptive and comparative analysis, several additional attributes could further enhance the analytical model.

The primary limitation is the absence of **reading start** and **reading end** dates for each book.

Currently, only a single reading date is stored, limiting the ability to measure reading duration and pace.

## Future Enhancements

Including reading start and end dates would enable:

- Reading duration analysis
- Pages read per day calculations
- Reading speed comparisons
- Genre-based reading pace analysis
- More advanced time-series analysis
- Behavioral segmentation based on reading efficiency

These additions would extend the project beyond volume-based reporting toward more advanced behavioral analytics.

## Overall Interpretation

The project demonstrates how a normalized PostgreSQL database, SQL analytics, DAX calculations and interactive Power BI dashboards can be combined to transform personal reading data into a scalable analytical solution.

Beyond descriptive reporting, the project highlights behavioral patterns, personal preferences and long-term reading trends through a combination of quantitative metrics and custom analytical logic.

# 12. Project Structure

## Overview

The repository is organized to reflect the complete end-to-end analytics workflow, from raw data collection and database design to SQL analysis, Power BI reporting and project documentation.

Each directory represents a distinct stage of the analytical process, ensuring clarity, reproducibility, scalability and ease of maintenance.

## Repository Structure

```text
Book-Reading-Analytics/
│
├── data/
│   ├── raw/
│   │   ├── books_2025.xlsx
│   │   └── books_2026_h1.xlsx
│   │
│   └── processed/
│       ├── books_2025.csv
│       └── books_2026_h1.csv
│
├── postgresql/
│   ├── data_modeling.sql
│   ├── data_cleaning.sql
│   ├── data_filtering.sql
│   ├── data_joins.sql
│   ├── data_set_operations.sql
│   ├── data_pattern_matching.sql
│   ├── data_aggregations.sql
│   ├── data_window_functions.sql
│   └── data_comparison_2025_2026.sql
│
├── dbeaver/
│   ├── sample_queries.sql
│   ├── ER_diagram_main_tables.png
│   └── ER_diagram_backup_tables.png
│
├── powerbi/
│   ├── books_reading_analytics.pbix
│   ├── README.md
│   └── screenshots/
│       ├── dashboard_1.png
│       ├── dashboard_2.png
│       └── dashboard_3.png
│
├── documentation/
│   ├── CASE_STUDY.md
│   ├── Power_BI_1.md
│   ├── Power_BI_2.md
│   ├── Power_BI_3.md
│   └── Power_BI_all.md
│
└── README.md
```
## Structure Design Principles

The repository follows several design principles that support an efficient and maintainable analytics workflow.

### Separation of Concerns

Each stage of the project is organized into a dedicated directory, separating:

- source data
- database objects
- PostgreSQL scripts
- DBeaver resources
- Power BI reports
- project documentation

This organization keeps the analytical workflow modular and easy to navigate.

### Reproducibility

Every major step of the project can be reproduced—from importing the original Excel files to generating SQL analyses and interactive Power BI dashboards.

### Scalability

The modular folder structure supports future dataset updates, additional SQL scripts, new Power BI dashboards and expanded project documentation without requiring structural changes.

### Maintainability

SQL scripts are organized according to their analytical purpose, while database objects, BI reports, ER diagrams and documentation are stored independently. This structure simplifies maintenance and future development.

### Documentation

Comprehensive documentation accompanies every major stage of the project, improving transparency and making the complete analytical workflow easier to understand and reproduce.

## Outcome

The repository structure reflects a real-world analytics workflow by clearly separating data collection, database development, SQL analysis, business intelligence reporting and technical documentation into distinct layers.

This modular organization improves readability, maintainability, reproducibility and provides a scalable foundation for future project enhancements.

# 13. Challenges & Design Decisions

## Overview

As this is a learning project, the database and analytical model evolved incrementally as I gained practical experience with PostgreSQL and Power BI. Rather than presenting only the final solution, this project documents the design decisions, challenges encountered and the reasoning behind each improvement.

Several aspects of the project remain intentionally open for future refinement as additional reading data and analytical requirements are introduced.

## Data Safety and Workflow

One of the first priorities was ensuring that experimentation would not compromise the original data.

To support safe development, backup tables were created before major modifications, allowing the database to be restored if necessary. This also provided practical experience with backup and recovery workflows commonly used when working with relational databases.

At the data collection stage, consistency was addressed directly in the Excel source file. For example, book formats were restricted through predefined dropdown lists (`Audio`, `Ebook` and `Print`), preventing inconsistent values such as `ebook`, `E-book`, or `PRINT` from entering the database.

## Modeling Multiple Authors

The most significant design challenge involved representing books written by multiple authors.

The initial flat-table approach worked well for books with a single author but quickly became insufficient when a book needed to reference two or more authors. Solving this problem required redesigning the database into a normalized relational model and introducing the `authors_to_books` bridge table to support many-to-many relationships.

This became one of the most valuable learning experiences of the project, demonstrating how proper relational modeling improves data consistency, scalability and query flexibility.

## Designing for Growth

The project was originally created to analyze reading data for a single year. As the analytical scope expanded, the database structure was adapted to support additional datasets without disrupting the existing model.

Instead of replacing existing data, new records (e.g., `books_2026_h1`) were loaded into separate staging tables for validation and comparison before integration. This approach made it possible to perform year-over-year analyses while preserving historical data.

The same architecture will support future expansion with reading records from 2016–2024 and subsequent years, allowing the analytical model to grow without requiring fundamental structural changes.

## Reflection

Looking back, the project demonstrates not only the final analytical solution but also the learning process behind it. Each challenge led to improvements in database design, data quality, and analytical thinking.

Rather than treating the project as a finished product, I view it as an evolving analytics solution that will continue to expand as new data and new analytical ideas emerge.

# 14. Future Improvements

## Overview

Although this project demonstrates a complete end-to-end analytics workflow, it is intentionally designed as an evolving solution rather than a static portfolio project. The following enhancements would further improve its scalability, automation and analytical capabilities.

## ETL Automation

The current data import process is performed manually. A natural next step would be to automate the ETL workflow using scheduled scripts or orchestration tools such as Apache Airflow, enabling regular data ingestion and reducing manual effort.

## Incremental Data Loading

Instead of re-importing complete datasets (e.g., **H1 2025** and **H1 2026**), future versions could implement incremental loading to process only new or modified records.

Benefits include:

- Faster data refresh
- Reduced processing time
- Improved scalability
- Alignment with real-world data engineering practices

## Enhanced Data Validation

Additional automated validation rules could be introduced to improve data quality, including:

- Uniqueness checks
- Format validation
- Referential integrity validation
- Missing value detection
- Consistency checks for categorical data

## Advanced Analytics

The current project focuses primarily on descriptive and comparative analysis. Future enhancements may include:

- Trend forecasting
- Predictive analysis of reading behavior
- Behavioral segmentation
- Time-series modeling

## Power BI Enhancements

The reporting layer could be extended with:

- More advanced DAX measures
- Drill-through pages
- Scenario-based analysis
- Additional KPIs
- Improved user experience and data storytelling

## Dataset Enrichment

The analytical model could be expanded by incorporating additional attributes such as:

- Reading start and completion dates
- Reading duration
- Pages read per day
- Genre-specific reading pace
- Rating trends over time
- External book metadata (e.g., Goodreads-style enrichment)

These additions would support deeper behavioral analysis and more advanced time-based metrics.

## Long-Term Vision

In the long term, this project could evolve from a portfolio case study into a fully automated personal analytics platform featuring:

- Automated data ingestion
- ETL orchestration
- Incremental data loading
- Continuous reporting
- Interactive Power BI dashboards
- Scalable analytical data model

## Final Note

The project was intentionally designed with scalability and extensibility in mind. Its modular architecture allows new datasets, analytical features and reporting capabilities to be integrated without requiring major structural changes, making it well suited for continuous development and experimentation.

# 15. Lessons Learned

## Overview

This project provided hands-on experience across the full data analytics lifecycle, including data collection in Excel, relational database design in PostgreSQL, SQL-based analysis and interactive dashboard development in Power BI.

Working with a continuously evolving dataset helped me understand how analytical systems grow over time and how design decisions made early in the process directly affect scalability, data quality and reporting flexibility.

## Technical Skills Developed

Throughout the project, I gained practical experience in:

- Designing a normalized relational database schema (books, authors, genres, subgenres)
- Implementing many-to-many relationships using bridge tables (`authors_to_books`, `genres_to_books`)
- Structuring time-based analysis using a dedicated `dim_months` table
- Writing analytical SQL queries using:
    - JOINs across multiple tables
    - Aggregation and grouping
    - Window functions for ranking and cumulative metrics
    - CTEs for reusable logic
- Handling dataset evolution using staging tables (e.g. `books_2026_h1`) for safe comparison between time periods
- Performing data cleaning and standardization directly at the data source (Excel constraints such as dropdown validation for formats)
- Building interactive Power BI dashboards with DAX measures and calculated columns

## Key Takeaways

Working with this project reinforced several important principles of data analytics:

- **Data modeling drives everything**: decisions such as introducing bridge tables directly impacted analytical flexibility and query design.
- **Data quality starts at the source**: Excel-level constraints (e.g. controlled format values) significantly reduced downstream cleaning effort.
- **Iterative development is essential**: the model evolved from a single dataset structure to a multi-period analytical system (2025–2026 and beyond).
- **Staging tables improve safety**: separating new data (e.g. `books_2026_h1`) allowed controlled validation before integrating into the main model.
- **Power BI depends on strong modeling**: meaningful dashboards were only possible because of a properly normalized relational structure.

## Reflection

This project strengthened my ability to design and implement an end-to-end analytical workflow, from raw data structuring to insight generation.

It also demonstrated that analytics is not only about writing SQL queries or building dashboards, but about making consistent architectural decisions that ensure scalability, clarity and long-term usability of the data model.

Overall, the project helped me connect database design, SQL analysis, and BI visualization into a single coherent system that can continue to evolve as new data is added.