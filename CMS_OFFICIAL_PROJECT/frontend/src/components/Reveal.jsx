import React from 'react';
import { motion } from 'framer-motion';

const Reveal = ({ children, delay = 0, y = 30 }) => {
    return (
        <div>
            {children}
        </div>
    );
};

export default Reveal;
