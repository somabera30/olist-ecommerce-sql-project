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