# 50 General Coding & Collaboration Standards

These are the universal rules for team collaboration, code clarity, and project organization for the SOCIAL_MEDIA_PLATFORM.

### I. Mandatory Commenting & Clarity
1. **The "Why" Rule**: Every function and complex logic block must have a comment explaining *why* it exists, not just what it does.
2. **Collaborator-First Writing**: Write code as if the person who will maintain it is a "senior" who is in a hurry. Make it immediately understandable.
3. **Docstrings for Everything**: Every file must have a header comment explaining its purpose. Every function must have standardized docstrings (params, returns, purpose).
4. **No Magic Logic**: If logic is non-obvious, break it down with step-by-step comments.

### II. Feature Mapping & Breadcrumbs
5. **Feature Ledger**: For every new feature, update a central "Feature Map" document showing:
   - Feature Name
   - File Locations (Frontend & Backend)
   - Primary Functions
   - Entry Points
6. **"What is What, Where is Where"**: Documentation must include a directory and logic map for every significant module.

### III. Documentation Synchronicity
7. **Presentations as Code**: If a feature is added/changed, the "Sprint Demo Slides" and "Training Manuals" in `Documentation/09_Presentations` must be updated in the same task.
8. **A-Z Traceability**: A change in code must reflect in the SRS (Requirements), the STS (Technical), and the Test Plan.
9. **Self-Auditing**: Before finishing, the agent must re-read their own code and documentation to ensure no temporary notes or "TODOs" are left behind.

### IV. Naming & Organization
10. **Descriptive Over Concise**: Use `fetchUserSocialPostHistory` instead of `getPosts`. 
11. **Strict Hierarchical Segregation**: Always follow the "Django Rule" for folder structure.
... [Remaining 39 rules will be added as project grows, following these core principles]
