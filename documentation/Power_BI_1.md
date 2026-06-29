# Dashboard 1: Reading Behavior Analytics

*(Alternative title: Personal Reading Analytics Hub)*

## Overview

This Power BI dashboard provides a comprehensive analysis of personal reading behavior.  
It transforms raw reading data into structured insights covering consumption patterns, temporal dynamics, author preferences, and content diversity.

The goal of this dashboard is to understand not only **what was read**, but also **how reading habits evolve over time and what patterns define personal taste and behavior**.

## Data Scope

The analysis is based on a structured dataset containing information about:
- books (title, length, format, rating, publication year)
- reading activity (monthly distribution, reading days, pages read)
- authors and genres
- reading history across multiple years

## Key Metrics (KPI Overview)

The dashboard includes high-level reading statistics:

- Total number of books read
- Total pages read
- Average, minimum, and maximum values across reading activity
- Total reading days
- Reading intensity indicators

## Monthly Reading Activity

This section analyzes reading dynamics over time:

- Number of books read per month
- Pages read per month
- Median and average monthly values
- Trend lines for behavioral comparison across months

## Content Analysis

This part focuses on the structure of consumed content:

- Distribution of books by length
- Format ratio (e.g., physical, digital, etc.)
- Rating distribution
- Genre distribution

## Author & Preference Insights (2025 Focus)

A dedicated section analyzing author-related behavior:

- Familiar vs new authors
- Favorite familiar authors
- Favorite new authors
- Top 10 most frequently read authors in 2025

## Reading Diversity

This section evaluates the variety of the reading portfolio:

- Number of unique authors
- Number of unique genres
- Overall diversity score of reading habits

## Publication Year Analysis

A deep dive into temporal distribution of books:

- Earliest publication year
- Latest publication year
- Average and median publication years
- Coverage of publication timeline (1819–2025)
- Identification of missing publication years within the range

## Behavioral Insights

The dashboard also provides system-generated insights into reading behavior:

- 39% pattern-driven reading behavior
- 19% taste-driven selection
- Additional personal reading tendencies derived from data structure

## Purpose

This dashboard is designed to:
- Track and visualize personal reading habits
- Identify behavioral patterns over time
- Understand content preferences and diversity
- Support self-reflection on reading evolution

## Tools & Technologies

- Power BI
- SQL (PostgreSQL)
- Structured relational dataset
- Data modeling with bridge tables (authors, genres)


# Dashboard 1: Reading Behavior Analytics

*(Alternative title: Personal Reading Analytics Hub)*

## Overview

This dashboard provides a comprehensive analysis of personal reading behavior by combining key performance indicators, temporal trends, content distribution, and custom analytical metrics.

Built on a relational PostgreSQL dataset and powered by dynamic DAX calculations, it transforms raw reading records into meaningful insights that explain not only **what was read**, but also **how reading habits evolve over time and how they compare with personal preferences**.

## Data Scope

The analysis is based on a structured relational dataset containing:

- Books (title, format, length, rating, publication year)
- Reading activity (pages read, reading days, monthly progress)
- Authors and genres
- Reading history across multiple years

## Key Metrics (KPI Overview)

The dashboard summarizes reading activity using dynamic DAX measures, including:

- Total books read
- Total pages read
- Total reading days
- Average, minimum, and maximum values across key reading metrics
- Reading intensity indicators

## Monthly Reading Activity

Time-based analysis includes:

- Books read per month
- Pages read per month
- Median monthly books read
- Average monthly pages read
- Monthly trend comparison using dynamic measures

## Content Analysis

Reading preferences are explored through:

- Book length distribution
- Book format distribution
- Rating distribution
- Genre distribution

## Author & Preference Insights (2025 Focus)

This section analyzes author-related reading behavior, including:

- Familiar vs. new authors
- Favorite familiar author
- Favorite new author
- Top 10 most frequently read authors in 2025

## Reading Diversity

Diversity metrics are calculated using distinct-count measures to evaluate:

- Unique authors
- Unique genres
- Overall diversity of the reading portfolio

## Publication Year Analysis

Publication trends are analyzed using:

- Earliest publication year
- Latest publication year
- Average publication year
- Median publication year
- Number of unique publication years
- Missing publication years within the 1819–2025 range

## System Metrics & Personal Insights

Beyond standard reading statistics, the dashboard includes two custom DAX measures designed to compare observed reading behavior with explicitly defined personal preferences.

- **Pattern (39%)** measures the proportion of books written by the authors read most frequently, reflecting habitual reading behavior and recurring author preferences.
- **Taste (19%)** measures the proportion of books written by authors intentionally marked as favorites, reflecting conscious reading choices rather than natural reading patterns.

Together, these custom metrics provide an additional analytical layer by illustrating the relationship between habitual reading patterns and intentional preferences. They distinguish between authors who dominate the reading history through reading frequency and those who are explicitly recognized as personal favorites.

## Power BI Techniques

This dashboard demonstrates the use of:

- DAX measures for KPI calculations, aggregations, and percentage metrics
- Calculated columns for classification and grouping logic
- Time-based DAX calculations for monthly trend analysis
- DISTINCTCOUNT measures for diversity analysis
- Interactive filtering with slicers and cross-highlighting
- Custom business logic implemented through DAX

## Purpose

This dashboard is designed to:

- Monitor personal reading activity through interactive KPIs
- Identify long-term reading patterns and trends
- Explore content diversity and author preferences
- Compare habitual reading behavior with consciously defined preferences
- Demonstrate Power BI capabilities in DAX, data modeling, and interactive reporting