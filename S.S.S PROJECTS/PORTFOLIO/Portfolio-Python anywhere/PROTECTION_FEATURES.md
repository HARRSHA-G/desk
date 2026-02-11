# 🛡️ Portfolio Security & Protection Features

This document outlines the security measures implemented to protect the portfolio's code, design, and content from unauthorized copying, inspection, and recording.

## 🚫 1. Content Interaction Barriers
These measures prevent users from physically interacting with the content in ways that facilitate theft.

*   **Right-Click Disabled**: The context menu is globally blocked, preventing "Save Image As", "Inspect Element", and other context-dependent actions.
*   **Text Selection Disabled**: Users cannot highlight or select any text on the page (`user-select: none`).
*   **Drag & Drop Blocked**: Images and elements cannot be dragged to the desktop or other tabs to save them (`user-drag: none`).

## 📋 2. Clipboard Protection
Measures to stop content from being moved to the system clipboard.

*   **Copy Disabled**: `Ctrl+C` and the copy event are intercepted and blocked.
*   **Cut Disabled**: `Ctrl+X` and the cut event are blocked.
*   **Paste Disabled**: `Ctrl+V` and the paste event are blocked to prevent "inception" or injecting code.

## 🎥 3. Anti-Screenshot & Anti-Recording ("Inception Mode")
Advanced behavioral triggers to frustrate screen capture attempts.

*   **Blur-on-Lose-Focus**:
    *   **Mechanism**: The instant the browser window loses focus (e.g., user clicks `Alt+Tab`, clicks a Snipping Tool, or opens screen recording software controls), the **entire website turns 100% transparent/invisible**.
    *   **Effect**: The screenshot or recording usually captures a blank/black screen instead of the content.
*   **Paranoid Mode (Win+Shift+S Defense)**:
    *   **Mechanism**: Listens for the `Windows (Meta)`, `Alt`, or `PrintScreen` keys being pressed.
    *   **Effect**: Instantly hides the content *before* the screenshot tool overlay can appear. The content remains hidden until the keys are released.
*   **Mouse-Leave Protection**:
    *   **Mechanism**: If the mouse cursor leaves the browser window (e.g., to click the taskbar or a second monitor), the content immediately vanishes.

## 🕵️ 4. Anti-Inspection (Developer Tools)
Measures to prevent casual users from viewing the source code.

*   **Shortcuts Blocked**:
    *   `F12` (Open DevTools)
    *   `Ctrl+Shift+I` (Inspect Element)
    *   `Ctrl+Shift+J` (Console)
    *   `Ctrl+Shift+C` (Element Selector)
    *   `Ctrl+U` (View Page Source)
*   **Save & Print Blocked**:
    *   `Ctrl+S` (Save Page As)
    *   `Ctrl+P` (Print Page)

## 📱 5. Device & OS Compatibility Report

| Feature | Windows | Mac (macOS) | Mobile (iOS/Android) |
| :--- | :--- | :--- | :--- |
| **Design / Layout** | ✅ Perfect | ✅ Perfect | ✅ Perfect (Responsive) |
| **Right-Click Block** | ✅ Blocked | ✅ Blocked | ✅ Blocked (Long Press) |
| **Copy/Paste Block** | ✅ Blocked | ✅ Blocked (Cmd+C/V) | ✅ Blocked (Selection Disabled) |
| **PrintScreen Block** | ✅ Blocked | ⚠️ Partial (Cmd+Shift+3) | ❌ **OS Limitation** (Hardware Buttons) |
| **Win+Shift+S Block** | ✅ Blocked (Watermark Fallback) | N/A | N/A |
| **Blur-on-Focus** | ✅ Active | ✅ Active | ⚠️ App Switching Only |

> **Mobile Note**: On mobile devices, screenshots are taken using hardware buttons (Power + Volume). Browsers **cannot** detect or block these owing to OS security policies. However, text selection and image saving via long-press are successfully blocked.
