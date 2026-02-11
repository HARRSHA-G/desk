import React from 'react';
import { motion } from 'framer-motion';
import { Card } from '@mui/joy';

const RevealCard = ({ children, delay = 0, sx = {}, ...props }) => {
    return (
        <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
            <Card sx={{ height: '100%', ...sx }} {...props}>
                {children}
            </Card>
        </div>
    );
};

export default RevealCard;
