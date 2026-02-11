import React, { useEffect } from 'react';

/**
 * PageHeader Hook/Component (Rule 29: Unique Page Titles)
 * Automatically updates the document title and provides a standard heading structure.
 */
const PageHeader = ({ title, description }) => {
    useEffect(() => {
        if (title) {
            document.title = `${title} | ConstructFlow`;
        }
    }, [title]);

    return null; // This is a logic-only component primarily for title updates
};

export default PageHeader;
