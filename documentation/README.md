# Reading Analytics – Power BI Project

## Overview

This Power BI project is a data analytics solution built on personal reading data.  
It focuses on transforming raw relational data into analytical insights using **DAX measures, calculated columns, and data modeling techniques**.

The project is structured around three analytical layers: behavioral analysis, structural analysis, and curated evaluation.

## Data Model & Transformations

The dataset was structured in a relational model using:
- Books table (main fact table)
- Authors and Genres bridge tables (many-to-many relationships)
- Series dimension
- Time-based reading attributes

### Power BI Techniques Used:
- DAX measures for dynamic aggregations and KPIs
- Calculated columns for classification logic and grouping
- Time intelligence functions for monthly analysis
- Filtering and slicing logic for interactive exploration
- Hierarchical modeling (genre → subgenre → series)

## Dashboard 1: Reading Behavior Analytics

A behavioral analysis dashboard focused on consumption patterns and reading activity.

### Key Calculations:
- Total, average, min, max KPIs (books, pages, reading days)
- Monthly aggregation measures (books/pages per month)
- Ratio calculations (format, rating, genre distribution)
- Diversity metrics (unique authors, genres)
- Behavioral scoring indicators (% pattern vs taste)

### DAX Usage:
- Aggregation measures (SUM, AVERAGE, MIN, MAX)
- Time-based measures by month context
- Ratio and percentage calculations
- Distinct count logic for diversity metrics

## Dashboard 2: Reading Series Progress & Structure Analytics

A structural dashboard analyzing reading series progression and hierarchy.

### Key Calculations:
- Series completion status (read / in progress / not read)
- Books per series vs books read per series
- Series-level KPIs (total, average, min, max books)
- Completion rate calculations per series
- Genre-subgenre mapping logic

### DAX / Modeling:
- Calculated columns for series status classification
- Measures for progress tracking and completion ratios
- Hierarchical filtering (genre → subgenre → series)
- Conditional logic for progress categorization

## Dashboard 3: Top 30 Books – Genre & Subgenre Curation Analytics

A curated analysis of top-performing books in 2025.

### Key Calculations:
- Top 30 ranking logic based on selection criteria
- Genre and subgenre mapping
- Dominant genre classification (business logic layer)
- Rating-based filtering and segmentation
- Visual encoding of thematic dominance

### DAX / Logic:
- Ranking measures (TOPN logic)
- Conditional calculated columns for dominant genre assignment
- Multi-category handling (books belonging to multiple genres)
- Custom classification rules for visualization mapping

## Key Technical Highlights

- Extensive use of **DAX measures for dynamic analytics**
- Calculated columns for **classification and grouping logic**
- Implementation of **many-to-many relationships (bridge tables)**
- Advanced **filter context manipulation in visuals**
- Combination of **quantitative metrics + qualitative classification**

## Outcome

This project demonstrates the ability to:
- build a structured Power BI data model
- apply DAX for analytical computations
- design interactive dashboards with multiple analytical layers
- combine behavioral, structural, and curated data perspectives