import React from 'react';
import { motion } from 'framer-motion';

const pageVariants = {
    initial: {
        opacity: 0,
        y: 20, // Subtle slide up
        filter: 'blur(5px)' // Cross dissolve feel
    },
    enter: {
        opacity: 1,
        y: 0,
        filter: 'blur(0px)',
        transition: {
            duration: 0.5, // 500ms
            ease: "easeInOut",
        },
    },
    exit: {
        opacity: 0,
        y: -10, // Slight upward drift on exit
        filter: 'blur(5px)',
        transition: {
            duration: 0.3,
            ease: "easeInOut",
        },
    },
};

const PageTransition = ({ children }) => {
    return (
        <div style={{ width: '100%', height: '100%' }}>
            {children}
        </div>
    );
};

export default PageTransition;
