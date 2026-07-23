## Decision 6 – Adopt an Evidence-Based Schema Design

**Date:** 14 July 2026

### Context
While designing the `products` table, several columns appeared to contain no missing values during data sampling. The question arose whether `NOT NULL` constraints should be added based on the sampled data.

### Decision
Do not define database constraints solely from sampled observations. Create the initial schema using known business rules and verify additional constraints through complete data profiling.

### Reason
- Sampled data does not guarantee the absence of missing values in the full dataset.
- Data profiling provides evidence before strengthening the schema.
- Prevents incorrect assumptions during database design.

### Impact
Future tables will follow the same workflow:
Business Understanding → Table Design → Import → Data Profiling → Strengthen schema if required.

**Date:** 15 July 2026

## Decisions Made

### Workflow
- Continued following the established workflow:
  - Business Understanding → Table Creation → Data Import → SQL Data Profiling → Interpretation.

### Geolocation Table Design
- Created the `geolocation` table without defining a PRIMARY KEY because the dataset contains exact duplicate records.
- Deferred `NOT NULL` constraints until after profiling, following the evidence-based design approach adopted throughout the project.
- Chose `DOUBLE PRECISION` for latitude and longitude to accurately store geographical coordinates.

### Data Profiling
- Classified exact duplicate rows as a valid profiling check.
- Excluded duplicate ZIP codes from profiling since multiple records per ZIP code are expected in the dataset.
- Added coordinate range validation using valid Earth latitude and longitude limits.
- Included cross-table ZIP code validation against `customers` and `sellers` to assess dataset completeness.

### SQL Analysis
- Learned that joining `customers` or `sellers` directly with the raw `geolocation` table can produce row multiplication because one ZIP code may correspond to multiple geolocation records.
- Decided to use an aggregated CTE (one row per ZIP code) when validating ZIP code coverage instead of joining the raw table.

### Documentation
- Maintained the practice of documenting every profiling query with its purpose and interpretation immediately after verification.
```