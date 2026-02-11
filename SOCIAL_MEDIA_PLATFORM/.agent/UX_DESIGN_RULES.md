# 50 Universal Design & UI/UX Standards

This document outlines the mandatory design standards and accessibility rules to ensure a "Gentle, Universal, and Professional" experience for the SOCIAL_MEDIA_PLATFORM.

### I. Accessibility & Inclusivity (A11y)

1. **WCAG 2.2 Compliance:** Every page must meet the Web Content Accessibility Guidelines (Level AA) to be legally compliant globally.
2. **Full Keyboard Navigability:** 100% of interactive elements (buttons, links) must be operable using only a keyboard (Tab, Enter, Space).
3. **Visible Focus Indicators:** The "active" element must have a clear, high-contrast outline so keyboard users never lose their place.
4. **Color-Agnostic Meaning:** Never use color alone to show status (e.g., don't just use a red border for an error; add an "Error" icon or text label).
5. **High Contrast Ratios:** Text must have a contrast ratio of at least 4.5:1 against its background for readability by low-vision users.
6. **Screen Reader Optimization:** Use semantic HTML (`<main>`, `<nav>`, `<button>`) and ARIA labels so blind users hear a logical description of the UI.
7. **Alt-Text for Images:** Provide descriptive text for every meaningful image; use `alt=""` for purely decorative elements.
8. **Skip Navigation:** Provide a "Skip to Main Content" link at the top of every page for keyboard and screen reader users.
9. **No Keyboard Traps:** Users must always be able to move focus *out* of an element using the same keyboard method used to enter it.
10. **Seizure Prevention:** No content should flash more than three times per second to prevent photosensitive seizures.

### II. Mobile & Ergonomic Design (The "Thumb" Rule)

11. **The Thumb Zone Layout:** Place the most frequent actions (Home, Search, Post) in the bottom 33% of the screen for natural one-handed use.
12. **Large Touch Targets:** Every clickable area must be at least **44x44 pixels** (Apple) or **48x48 pixels** (Google) to prevent "Fat Finger" errors.
13. **Safe Gutter Spacing:** Maintain at least 8px of "dead space" between buttons so users don't accidentally click the wrong action.
14. **Haptic & Visual Feedback:** Every tap must result in a subtle change (color shift or gentle vibration) to confirm the system received the command.
15. **Avoid Complex Gestures:** Never hide a main feature behind a "triple-swipe" or "long-press." Always provide a simple button alternative.
16. **Orientation Agnostic:** The UI must work perfectly in both Portrait and Landscape modes without losing functionality.
17. **Safe Area Observance:** Ensure UI elements do not overlap with device notches, "pill" indicators, or home bars.

### III. Typography & Content (International Readability)

18. **Fluid Typography:** Use a base font size of at least **16px** (1rem). Text must scale proportionally if the user changes their OS font size.
19. **Golden Line Height:** Set line spacing to **1.5x** the font size to prevent "text walls" and reduce eye strain.
20. **Simple English (i18n):** Use "Plain Language" (Grade 6 level). Avoid jargon so the app is easy for non-native speakers and international users.
21. **Scanning over Reading:** Use bold headings and bullet points. Users scan in an F-pattern; they rarely read every single word.
22. **Visual Hierarchy:** Use only 2 font weights (Regular/Bold) and 3 sizes to guide the eye to the most important info first.
23. **Readable Width:** Limit text blocks to 70–80 characters per line to maintain focus and prevent neck fatigue on wide monitors.
24. **Unique Page Titles:** Every page must have a unique browser title that describes exactly what is on that page.

### IV. The "Gentle" Aesthetic (Calm & Professional)

25. **Whitespace for Focus:** Use generous padding and margins. Whitespace is a tool to prevent "Cognitive Overload."
26. **Physics-Based Motion:** Animations should mimic real-world objects. They should start slow, speed up, and end with a "soft landing."
27. **Calm Color Palettes:** Use neutral bases (white/grey/navy) and reserve your "Brand Color" only for primary actions (CTAs).
28. **Soft Corners:** Use rounded corners (8px to 16px) for cards and buttons. Sharp corners feel aggressive; rounded ones feel friendly.
29. **Skeleton Loading:** Use pulsing placeholders to show where content *will* appear. This makes the app feel faster and smoother than a spinner.

### V. Logic & System Behavior

30. **Visibility of Status:** Users should always know what is happening. Use progress bars or status messages for any process longer than 1 second.
31. **Tolerance for Error:** Always include an "Undo" or "Cancel" option. Users should never feel "trapped" after a mistake.
32. **Predictable Navigation:** Standard icons (Home, Settings, Back) must stay in the same place on every page.
33. **Progressive Disclosure:** Show only the info the user needs *right now*. Use "Advanced" or "Show More" tags to hide complexity.
34. **Meaningful Empty States:** When there is no data, show a gentle illustration and a clear "Next Step" button (e.g., "Create your first task").
35. **Error Identification:** Clearly mark which field has an error and describe *how* to fix it in simple text.
36. **Error Suggestion:** If a user types the wrong format, suggest the correct one (e.g., "Example: name@domain.com").
37. **Context-Sensitive Help:** Place "Help" or "Info" icons exactly where a user might get confused by a complex feature.
38. **Standardized Icons:** Use familiar icons (Gear = Settings, House = Home) so users don't have to learn new symbols.
39. **Pointer Cancellation:** Actions should trigger when a finger or mouse is *released*, not when it is first pressed (prevents accidental actions).
40. **Individualization:** Allow users to toggle between Light and Dark modes and adjust their view preferences.
41. **Non-Visual Cues:** Avoid instructions like "Click the red button"; use text labels like "Click the Save button."
42. **Status Messages (Live Regions):** Screen readers must announce when a process is "Finished" or "Successful."
43. **Consistent Labeling:** Use the exact same name for a feature throughout the entire application.
44. **Predictive UI:** Anticipate user needs (e.g., showing a "Save" button only after a change is detected).
45. **No Images of Text:** Use actual fonts rather than images of words so text remains searchable, resizable, and accessible.
46. **Reflow Compatibility:** The UI must fit in a single vertical column at 400% zoom with no horizontal scrolling required.
47. **System Fonts First:** Use native system fonts (San Francisco, Roboto) for the fastest load times and maximum familiarity.
48. **Data Minimization:** Only ask for the user data absolutely necessary for the task at hand.
49. **Sustainability:** Optimize all assets to reduce data usage and battery consumption for the user's device.
50. **Conformity with Expectations:** Place common buttons (Logout, Profile) where users globally expect to find them (Top Right or Settings).
