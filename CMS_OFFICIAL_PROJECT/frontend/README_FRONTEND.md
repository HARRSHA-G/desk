# Frontend - QuickGeo (React)

## 🚀 Overview
Professional Construction Management UI built with MUI Joy and React.

## 📁 Structure
- `src/components`: Reusable UI elements (Layout, PageHeader, Sidebar).
- `src/pages`: Feature-specific page components.
- `src/api.js`: Centralized Axios configuration with versioning support.
- `src/i18n.js`: Internationalization readiness mapping.

## 🛡️ Key Standards Followed
- **Rule 25**: i18n Readiness (No hardcoded strings).
- **Rule 29**: Lazy Loading using `React.lazy` and `Suspense`.
- **Rule 46**: Universal Access using Semantic HTML tags.
- **Rule 43**: Environment-driven API URLs.
- **Rule 8**: Large touch targets (min 44px) for mobile-first design.

## 🔄 Workflow
1. Users navigate via the persistent `Sidebar`.
2. Pages load asynchronously (Lazy Loading).
3. Data is fetched using the versioned `/api/v1` prefix.
4. Smooth micro-animations enhance the premium feel.
