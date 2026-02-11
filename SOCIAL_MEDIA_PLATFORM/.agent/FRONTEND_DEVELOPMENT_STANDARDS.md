# 50 Universal Frontend Development Standards

This document outlines the mandatory frontend engineering standards for the SOCIAL_MEDIA_PLATFORM. These rules focus on performance, portability, and long-term maintainability.

### I. Environment & Package Management

1. **Lockfile Integrity:** Always commit your lockfiles (`package-lock.json`, `yarn.lock`, or `pnpm-lock.yaml`) to ensure every developer and the server uses identical dependency versions.
2. **Strict Dependency Audit:** Run `npm audit` or `snyk` weekly. Never ignore high-severity security vulnerabilities in your packages.
3. **Dependency Minimization:** Before adding a library (like `moment.js`), check if the native browser API (like `Intl.DateTimeFormat`) can do the job to keep the bundle small.
4. **Dev-Dependency Separation:** Keep build tools (testing frameworks, linters) in `devDependencies` to prevent them from bloating your production build.
5. **Environment Variable Masking:** Use `.env.example` to document required keys, but never commit the actual `.env` file containing secrets.

### II. Architecture & Structure (DRY)

6. **Atomic Design Pattern:** Structure your UI into **Atoms** (buttons), **Molecules** (search bars), and **Organisms** (navbars) for maximum reusability.
7. **Logic-View Separation:** Keep "Business Logic" (API calls, data filtering) in separate service files. Keep components "dumb" and focused only on the UI.
8. **Strict Folder Separation:** Maintain a clear structure: `/components`, `/services`, `/hooks` (or `/utils`), `/assets`, and `/styles`.
9. **Django-Style Hierarchical Segregation:** Irrespective of the framework, all files must be strictly segregated by their specific responsibility (e.g., helpers in `/utils`, data types in `/models`, API logic in `/services`, interface logic in `/components`). No "Junk Drawer" files.
10. **Feature-Based Modules:** If a project is large, group files by feature (e.g., `/features/auth`) rather than by type, so all related code stays together.
10. **Single Source of Truth:** Use a centralized state management system (Context, Redux, or Store) for global data like "User Profile" or "Theme Settings."

### III. Styling & Theme (A-Z Dark/Light)

11. **CSS Variables (Theming):** Define all colors, spacing, and fonts as variables. Never hardcode hex codes like `#FFFFFF` in individual components.
12. **Native Dark Mode Support:** Use the `prefers-color-scheme` media query to detect OS settings and automatically apply the correct theme.
13. **Fluid Layouts (No Hard Pixels):** Use `%`, `vh`, `vw`, and `rem` instead of `px` to ensure the UI scales perfectly on all screen sizes.
14. **Z-Index Management:** Maintain a centralized list of `z-index` values (e.g., `MODAL: 1000`, `DROPDOWN: 500`) to prevent "Z-Index Wars."
15. **Content-Type Isolation:** Use CSS Modules or "Scoped CSS" to ensure a component's style never leaks out and breaks other parts of the app.

### IV. Asset & Media Optimization

16. **SVG over Icons:** Use SVG files for icons instead of icon fonts (like FontAwesome) to reduce load time and improve sharpness.
17. **Modern Image Formats:** Serve images in `.webp` or `.avif` formats; they are significantly smaller than `.jpg` or `.png`.
18. **Lazy Loading Media:** Use the `loading="lazy"` attribute on images and iframes so they only download when the user scrolls to them.
19. **Icon Sprites/Bundling:** For many small icons, use a sprite sheet or an SVG bundle to reduce the number of HTTP requests.
20. **Font Preloading:** Preload only the most critical fonts to prevent "Layout Shift" where text jumps after the font loads.

### V. Performance & Rendering

21. **Skeleton Loading:** Use pulsing grey placeholders instead of empty screens or loading spinners to improve "Perceived Performance."
22. **Debouncing & Throttling:** Limit how often heavy functions (like window resizing or search-input typing) trigger to save CPU power.
23. **Memoization:** Cache the results of heavy calculations so they don't run again if the input hasn't changed.
24. **Route-Based Code Splitting:** Only load the code needed for the current page. Don't make the user download the "Settings" page code while they are on the "Login" page.
25. **Lighthouse Auditing:** Maintain a score of 90+ in Google Lighthouse for Performance, Accessibility, and SEO before any release.

### VI. Browser & OS Portability

26. **Cross-Browser Prefixing:** Use tools like `Autoprefixer` to ensure CSS features (like Grid or Flexbox) work on older versions of Safari and Firefox.
27. **Path-Library Safety:** Use standardized path-handling to ensure your build scripts work on Windows, macOS, and Linux.
28. **Feature Detection:** Use `if ('serviceWorker' in navigator)` style checks before using modern browser features to prevent crashes on older browsers.
29. **Polyfilling:** Include polyfills for essential features (like `fetch` or `Promise`) if you must support legacy browsers.
30. **Input Agnostic Logic:** Ensure your app responds correctly to Mouse, Touch, and Stylus inputs.

### VII. Security & Data Integrity

31. **XSS Protection:** Always sanitize user-generated HTML before rendering it to the screen.
32. **Content Security Policy (CSP):** Use meta tags to restrict which domains your app is allowed to communicate with.
33. **JWT Storage Safety:** Store sensitive tokens in `HttpOnly` cookies or memory, never in `localStorage` if you are at high risk of XSS.
34. **Form Validation (Double-Check):** Always validate data on the frontend for UX, but assume it is "dirty" until the backend validates it again.
35. **Secure API Communication:** Force `https://` for all API calls and reject any insecure `http://` requests.

### VIII. Testing & Quality

36. **Component Unit Testing:** Every reusable component (Button, Input) must have a test to ensure it renders correctly with different "props."
37. **Integration Testing:** Test the "happy path" (e.g., User clicks Login -> User sees Dashboard) to ensure the frontend and backend handshake works.
38. **Visual Regression Testing:** Use tools to take snapshots of your UI to ensure new code didn't accidentally change a button's color or position.
39. **Console Hygiene:** `console.log` is forbidden in production. Use a professional logging service for real errors.
40. **Error Boundaries:** Wrap your app in a "Catch" component so that if one small piece fails, the user sees a "Try Again" button instead of a white screen.

### IX. Internationalization & SEO

41. **Language Keys (i18n):** Never hardcode text like "Submit." Use keys like `buttons.submit` so the app can be translated into Telugu, Hindi, or Spanish instantly.
42. **RTL Support Readiness:** Design your CSS so that it can support Right-To-Left languages (like Arabic) without rewriting the layout.
43. **Semantic SEO:** Use proper Header tags (`<h1>` to `<h6>`) so search engines and screen readers understand the page structure.
44. **Dynamic Meta Tags:** Every page must update its Title and Description meta tags based on the current content.
45. **Canonical URLs:** Use canonical tags to tell search engines which version of a page is the "Master" version.

### X. Deployment & Maintenance

46. **CI/CD Pipeline:** Automate your frontend deployment. Pushing code to the "Main" branch should automatically run tests and deploy the site.
47. **Cache Busting:** Use unique filenames for your CSS and JS (e.g., `main.a1b2c3.js`) so users always get the latest version after an update.
48. **Source Map Management:** Provide source maps for debugging in staging, but disable them in production to hide your raw code from competitors.
49. **BFF (Backend for Frontend):** Only request the exact data fields you need for the UI to save user mobile data.
50. **Graceful Degradation:** If the internet goes offline, show an "Offline" banner and allow the user to keep browsing cached data.
