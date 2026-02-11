import React from 'react';
import { Box, Button } from '@mui/joy';

const ExportButtons = ({ onExportExcel, onExportPDF }) => {
    return (
        <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 2, mt: 3, printColorAdjust: 'exact' }}>
            <Button
                startDecorator={<i className="ri-file-excel-2-line" />}
                color="success"
                variant="solid"
                onClick={onExportExcel}
                sx={{ '@media print': { display: 'none' } }}
            >
                Export Excel
            </Button>
            <Button
                startDecorator={<i className="ri-file-pdf-line" />}
                variant="outlined"
                color="danger"
                onClick={onExportPDF}
                sx={{ '@media print': { display: 'none' } }}
            >
                Export PDF
            </Button>
        </Box>
    );
};

export default ExportButtons;
