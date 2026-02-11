# AI Agent Project Life Cycle (Standard Operating Procedure)

This document defines the mandatory step-by-step workflow that every AI agent must follow when assigned a task for the **SOCIAL_MEDIA_PLATFORM** project.

## 🔄 The 7-Step Life Cycle

### Step 1: Plain Language Confirmation (The Understanding)
Before writing any code, the agent must summarize what they understood about the task in **plain, simple language** (no technical jargon).
- **Goal**: Ensure the AI and the User are on the same page.
- **Action**: Wait for user approval before moving to Step 2.

### Step 2: Design & UI Preparation
Once approved, the agent must focus on the visuals first.
- **Goal**: Define the premium aesthetics and UX flow.
- **Action**: Create/Update CSS, design tokens, and layout wireframes in accordance with `UX_DESIGN_RULES.md`.

### Step 3: Frontend Implementation
Build the interactive interface.
- **Goal**: Create responsive, accessible components.
- **Action**: Follow `FRONTEND_DEVELOPMENT_STANDARDS.md` and ensure the "Django-Style" hierarchical structure.

### Step 4: Backend Integration
Connect the logic and data.
- **Goal**: Ensure reliable data flow and security.
- **Action**: Implement services, models, and controllers following `BACKEND_INFRASTRUCTURE_STANDARDS.md` and `SECURITY_DATA_ENCODING_STANDARDS.md`.

### Step 5: The "Anti-Gravity" Test Voltage
Every task must undergo rigorous testing before being considered "done."
- **Unit Testing**: Check the specific task functions.
- **Impact Analysis**: The agent must proactively check if the new changes broke any existing features or violated any international rules.
- **Resolution**: If errors occur, the agent must loop back to the relevant step and fix them before proceeding.

### Step 6: Total Documentation Lifecycle (A-Z Update)
A task is NOT finished until every relevant document in the `/Documentation` vault is updated.
- **Goal**: Maintain the "Master Vault" and ensure the project is stakeholder-ready for "seniors."
- **Full Scope**: This includes Technical Specs (SRS/STS), User Stories, Test Logs, and **Presentations** (Demo Slides/Pitch Decks in `09_Presentations`).
- **Feature Mapping (What/Where)**: If a new feature is added, you MUST document "what is what" and "where is where" (a map of new files and their roles) within the documentation.
- **Commentary**: All code must include mandatory comments explaining the "why" for future collaborators.
- **Action**: Verify that all 9 documentation categories have been checked and updated as needed.

### Step 7: Final Presentation & Delivery
Present the results to the user with a confirmation of all checks passed.
- **Goal**: Gentle and professional handoff.
- **Action**: Confirm that all steps (Design -> Front -> Back -> Test -> Docs) are completed.

---

## 🛠️ Universal Coding & Collaboration Standards
*These apply to every step of the Life Cycle:*

1. **Collaborator-First Writing**: Write code as if the person who will maintain it is a senior who is in a hurry.
2. **The "Why" Rule**: Every complex logic block must have a comment explaining the rationale.
3. **Strict Hierarchical Segregation (The Django Rule)**: Keep the project organized. No "Junk Drawer" files.
4. **A-Z Traceability**: Every code change must be traceable back to a requirement in the Documentation.
5. **Descriptive Over Concise**: Clarity is more important than saving characters in naming.

---
*Failure to follow this lifecycle is a violation of project standards.*
