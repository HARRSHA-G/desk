# 60 Universal Backend & Infrastructure Standards

This document outlines the mandatory backend engineering and infrastructure standards for the SOCIAL_MEDIA_PLATFORM. These rules focus on reliability, security, scalability, and maintainability.

#### **I. Environment & Dependency Management**

1. **Strict Dependency Versioning:** Use a lockfile (`requirements.txt`, `package.json`). Pin exact versions to prevent "Update Drift."
2. **Environment Isolation:** Use Virtual Environments or Docker to keep project libraries separate from the OS.
3. **The .env Rule:** Hardcoding credentials is a "High-Risk" failure. All secrets must live in a `.env` file that is never committed to Git.
4. **Production vs. Development Config:** Use an `ENVIRONMENT` variable to toggle security/debug settings.
5. **Global Port Management:** Define server ports in `.env` to avoid conflicts.
6. **Dependency Auditing:** Run vulnerability scans daily to catch insecure libraries.

#### **II. Database & Migration Standards**

7. **Versioned Migrations:** Never modify a DB table manually. Every change must be a versioned script.
8. **Database Normalization (3NF):** Design schemas to minimize redundancy.
9. **Strict Indexing:** Index every column used in `WHERE`, `ORDER BY`, or `JOIN` clauses.
10. **Soft Deletes:** Use `is_deleted` flags to preserve audit trails and data recovery.
11. **Transactional Integrity:** Use "Atomic Transactions" for multi-step logic (All or Nothing).
12. **Connection Pooling:** Reuse DB connections to prevent server lockouts.
13. **Migration Rollbacks:** Every migration must have a "Down" script to revert changes in case of failure.

#### **III. Offline-to-Online Sync (Synchronization Logic)**

14. **Timestamp Versioning:** Every record must have a `last_updated_at` (UTC) to determine which data is newer during a sync.
15. **UUID Generation:** Generate IDs (UUIDs) on the **Frontend** during offline mode so they are unique when pushed to the backend.
16. **Idempotency Keys:** Use unique keys for offline sync requests so that if a user pushes the same data twice, the backend doesn't create duplicates.
17. **Conflict Resolution Strategy:** Implement "Last Write Wins" or "Manual Review" logic for cases where data was changed in two places at once.
18. **Atomic Sync Batches:** Process offline updates in batches to ensure the database remains consistent even if the connection drops mid-sync.
19. **Sync Status Tracking:** Maintain a `synced` flag to differentiate between local-only and server-validated data.

#### **IV. Algorithm & Logic Simplicity (KISS - Keep It Simple)**

20. **Complexity Ceiling:** Always choose the simplest algorithm that solves the problem. Avoid "Over-Engineering."
21. **Early Return Pattern:** Exit functions early if conditions aren't met to avoid deeply nested "if-else" blocks.
22. **Pure Functions:** Where possible, write functions that take an input and return an output without changing global variables.
23. **Linear Logic:** Design data flows to move in one direction (A -> B -> C) rather than circular loops.
24. **No Logic in Database:** Avoid Triggers or Stored Procedures. Keep the "Brain" in the code for easier debugging.
25. **Strict Hierarchical Segregation (The Django Rule):** Irrespective of the backend technology, code must be strictly divided by layer: `/models` (Data schema), `/serializers` (Data formatting), `/views` or `/controllers` (Request handling), `/services` (Business logic), and `/utils` (Shared helpers).

#### **V. API Design & Communication**

25. **Stateless Architecture:** Use JWT for security so the server doesn't store session state.
26. **API Versioning:** Use `/api/v1/` to support older clients.
27. **Standardized Response:** Every API must return the same JSON structure: `{ data, error, message }`.
28. **Proper HTTP Verbs:** GET (Read), POST (Create), PUT (Update), DELETE (Remove).
29. **Meaningful Status Codes:** 200 (OK), 201 (Created), 400 (Client Error), 500 (Server Error).
30. **Stateless Logic:** Don't store user data in server RAM; use a database or cache.

#### **VI. Security & Protection**

31. **Input Sanitization:** Assume all user input is malicious. Encode strings to prevent SQL/XSS attacks.
32. **Secure Password Hashing:** Use Argon2 or BCrypt. Never store plain text.
33. **Rate Limiting:** Protect against DDoS by limiting requests per IP/User.
34. **CORS Whitelisting:** Strictly allow only your specific frontend domain.
35. **Payload Size Limits:** Restrict the size of incoming JSON or files to prevent memory-exhaustion attacks.
36. **Zero-Trust Encoding:** Encode data before it hits the DB and decode only for authorized users.

#### **VII. Microservices & Scalability**

37. **Single Responsibility:** One microservice = One business function.
38. **Database Isolation:** Microservices must never share a database; they talk only via API.
39. **Health Check Routes:** Provide `/health` for monitoring.
40. **Asynchronous Task Queues:** Move heavy tasks (Email/PDFs) to background workers.
41. **Graceful Shutdown:** Finish current DB operations before the server stops.

#### **VIII. Reliability & Monitoring**

42. **Structured JSON Logging:** Logs must be machine-readable (Time, UserID, Route, Error).
43. **Centralized Error Handling:** One "Global Catch" to format all server errors.
44. **Correlation IDs:** Trace a single request across all microservices via a unique ID.
45. **Fail-Fast Logic:** If a required variable is missing, stop immediately with a clear error.

#### **IX. Performance Optimization**

46. **N+1 Query Prevention:** Use "Eager Loading" (Joins) to fetch data in one trip.
47. **Caching Layer (Redis):** Cache frequently accessed data to save DB hits.
48. **CDN Integration:** Serve assets from a CDN for global speed.
49. **Pagination:** Never return "All Records." Use `limit` and `offset`.

#### **X. Maintenance & Engineering Standards**

50. **Infrastructure as Code:** Document server setups in files (Docker/Nginx).
51. **Zero-Downtime Deployment:** Use "Blue-Green" or "Rolling" updates.
52. **Log Rotation:** Automatically delete/archive old logs to save space.
53. **Uptime Alerts:** Set up notifications for server downtime.
54. **Swagger/OpenAPI:** Automatically generate API documentation.
55. **Unit & Integration Testing:** Test individual logic and full API flows automatically.
56. **ISO 27001 Readiness:** Align data handling with international security standards.
57. **GDPR/Privacy:** Provide "Right to be Forgotten" (Data deletion) functionality.
58. **UTC Time Standard:** Always store dates in UTC.
59. **Lightweight Payloads:** Strip unnecessary data from responses to save user bandwidth.
60. **Audit Trails:** Record who changed what and when in a dedicated `audit_logs` table.
