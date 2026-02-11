# Global Security & Data Encoding Standards

This document outlines the mandatory security and data protection standards for the SOCIAL_MEDIA_PLATFORM. These rules focus on achieving Zero-Trust architecture and international compliance (ISO 27001, SOC 2).

### **I. Data State Security**

1. **Encryption at Rest (AES-256):** All data stored on the hard drive or database must be encrypted using the Advanced Encryption Standard (AES-256). This is the global bank-grade standard.
2. **Encryption in Transit (TLS 1.3):** Use only HTTPS with the latest TLS 1.3 protocol. Disable older, hackable versions like SSL and TLS 1.0.
3. **End-to-End Encryption (E2EE):** For private messages, the backend should only store a "scrambled" version. Only the sender and receiver should have the keys to "unscramble" (decode) the content.

### **II. Encoding vs. Decoding (The Data Guard)**

4. **Zero-Trust Encoding Middleware:** Implement a "Security Gate" between your logic and your database. Every piece of sensitive data (Phone numbers, emails, addresses) must be **encoded** before it touches the disk.
5. **Context-Specific Decoding:** Data should only be **decoded** at the very last millisecond before being sent to an authorized user's screen.
6. **Salted Hashing (Passwords):** Never "encode" passwords (because anything encoded can be decoded). Instead, **Hash** them using **Argon2id** or **BCrypt** with a unique "Salt" for every user.

### III. Injection & Attack Prevention

7. **Parameterized Queries:** Never put user input directly into a database query. Use "Parameters" to prevent **SQL Injection**—the #1 cause of data theft worldwide.
8. **Output Encoding:** When sending data back to the frontend, "Encode" it for the browser (HTML Entity Encoding). This prevents **XSS (Cross-Site Scripting)** attacks where hackers inject malicious scripts into your pages.
9. **JWT Secret Rotation:** If you use JSON Web Tokens, the "Secret Key" used to sign them must be rotated every 30 days and stored in a Hardware Security Module (HSM).

### IV. Access & Masking

10. **PII Masking (Personally Identifiable Information):** Even for your "Admin" or "Staff" users, mask data. They should see `XXXX-XXXX-1234` instead of the full credit card or phone number.
11. **Granular Scoping:** Don't give one "Master Key" to the whole app. Use **Scopes**. A "Post Service" should only have the key to read posts, not the key to read user bank details.
12. **Blind Indexing:** If you need to search for an encrypted email, use a "Blind Index" (a separate hashed version). This allows you to find the user without ever "decoding" their real email in the search query.

### V. Audit & Recovery

13. **Immutable Security Logs:** Maintain an `audit_log` table that can only be "Appended." No one, not even the Admin, should be able to edit or delete a log that says "User X changed their password."
14. **Tamper Detection:** Use **Digital Signatures (HMAC)** for data packets moving between your microservices. If even one bit of data is changed by a hacker in the middle, the signature will fail, and the request will be rejected.
15. **Automatic Session Kill:** If the backend detects a suspicious change (like an IP address jumping from India to Russia in 5 minutes), it must immediately **revoke all tokens** and force a re-login.
