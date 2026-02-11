import { saveAs } from 'file-saver';
import jsPDF from 'jspdf';
import ExcelJS from 'exceljs';

import dayjs from 'dayjs';
export const TODAY_ISO = dayjs().format('YYYY-MM-DD');

export const formatCurrency = (val) => {
    const num = Number(val) || 0;
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    }).format(num);
};

export const formatCurrencyForPdf = (val) => {
    const num = Number(val) || 0;
    return `Rs ${num.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
};

export const PDF_SECTION_CONFIGS = [
    {
        id: 'payments',
        title: 'Payments',
        dataKey: 'payments',
        columns: [
            { label: 'Date', key: 'payment_date', width: 0.18 },
            { label: 'Type', key: 'payment_type', width: 0.2 },
            { label: 'Mode', key: 'payment_mode', width: 0.18 },
            { label: 'Description', key: 'description', width: 0.28 },
            {
                label: 'Amount',
                key: 'amount',
                width: 0.16,
                align: 'right',
                format: (row) => formatCurrencyForPdf(row.amountNum || row.amount || 0),
            },
        ],
    },
    {
        id: 'manpower',
        title: 'Manpower',
        dataKey: 'manpower',
        columns: [
            { label: 'Date', key: 'date', width: 0.2 },
            { label: 'Work Type', key: 'work_type_display', width: 0.32 },
            { label: 'People', key: 'number_of_people', width: 0.15, align: 'center' },
            {
                label: 'Total',
                key: 'total_amount',
                width: 0.33,
                align: 'right',
                format: (row) => formatCurrencyForPdf(row.amountNum || row.total_amount || 0),
            },
        ],
    },
    {
        id: 'material',
        title: 'Material',
        dataKey: 'material',
        columns: [
            { label: 'Date', key: 'date', width: 0.18 },
            { label: 'Item', key: 'custom_item_name', width: 0.32 },
            { label: 'Qty', key: 'quantity', width: 0.1, align: 'center' },
            {
                label: 'Unit Cost',
                key: 'per_unit_cost',
                width: 0.2,
                align: 'right',
                format: (row) => formatCurrencyForPdf(row.per_unit_cost || 0),
            },
            {
                label: 'Total',
                key: 'amountNum',
                width: 0.2,
                align: 'right',
                format: (row) => formatCurrencyForPdf(row.amountNum || 0),
            },
        ],
    },
    {
        id: 'departmental',
        title: 'Departmental',
        dataKey: 'departmental',
        columns: [
            { label: 'Date', key: 'date', width: 0.25 },
            { label: 'Expense', key: 'expense_name', width: 0.45 },
            {
                label: 'Amount',
                key: 'amount',
                width: 0.3,
                align: 'right',
                format: (row) => formatCurrencyForPdf(row.amountNum || row.amount || 0),
            },
        ],
    },
    {
        id: 'administration',
        title: 'Administration',
        dataKey: 'administration',
        columns: [
            { label: 'Date', key: 'date', width: 0.25 },
            { label: 'Expense', key: 'expense_name', width: 0.45 },
            {
                label: 'Amount',
                key: 'amount',
                width: 0.3,
                align: 'right',
                format: (row) => formatCurrencyForPdf(row.amountNum || row.amount || 0),
            },
        ],
    },
];

export const normalizeProject = (p) => ({
    id: p.id,
    name: p.project_name || p.name || 'Project',
    code: p.project_code || p.code || '',
});

export const handleExportExcel = async (payments, manpower, material, departmental, administration, projects, selectedProject, fromDateIso, toDateIso, showBanner) => {
    const clean = (arr) => arr.map(({ id, amountNum, ...rest }) => rest);
    const datasets = [
        { label: 'Payments', rows: clean(payments) },
        { label: 'Manpower', rows: clean(manpower) },
        { label: 'Material', rows: clean(material) },
        { label: 'Departmental', rows: clean(departmental) },
        { label: 'Administration', rows: clean(administration) },
    ];

    if (!datasets.some(({ rows }) => rows.length)) {
        showBanner('No financial data to export.', 'neutral');
        return;
    }

    const toPlainValue = (value) => {
        if (value === undefined || value === null) return '';
        if (typeof value === 'object') return JSON.stringify(value);
        return value;
    };

    const workbook = new ExcelJS.Workbook();
    const appendSheet = (name, rows) => {
        if (!rows.length) return;
        const normalized = rows.map((row) => {
            const result = {};
            Object.entries(row).forEach(([key, value]) => {
                result[key] = toPlainValue(value);
            });
            return result;
        });

        const headers = Array.from(
            normalized.reduce((set, row) => {
                Object.keys(row).forEach((key) => set.add(key));
                return set;
            }, new Set())
        );

        if (!headers.length) return;

        const sheet = workbook.addWorksheet(name);
        sheet.columns = headers.map((header) => ({ header, key: header }));
        normalized.forEach((record) => sheet.addRow(record));
    };

    datasets.forEach(({ label, rows }) => appendSheet(label, rows));

    const projectName = projects.find((p) => p.id === selectedProject)?.name || 'Project';
    const fileName = `Finances_${projectName}_${fromDateIso || 'start'}_${toDateIso || 'end'}.xlsx`;

    try {
        const buffer = await workbook.xlsx.writeBuffer();
        const blob = new Blob([buffer], {
            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        });
        saveAs(blob, fileName);
    } catch (error) {
        console.error('Excel export failed', error);
        showBanner('Could not generate Excel file.', 'danger');
    }
};

export const handleExportPDF = (payments, manpower, material, departmental, administration, projects, selectedProject, fromDateIso, toDateIso, totals, showBanner) => {
    const project = projects.find((p) => p.id === selectedProject);
    const projectName = project?.name || 'Project';
    const projectCode = project?.code || 'N/A';
    const dateRangeText = `${fromDateIso || 'Start'} — ${toDateIso || 'End'}`;
    const doc = new jsPDF('p', 'mm', 'a4');
    const margin = 16;
    const pageWidth = doc.internal.pageSize.getWidth();
    const usableWidth = pageWidth - margin * 2;
    const dataMap = {
        payments,
        manpower,
        material,
        departmental,
        administration,
    };
    const summaryItems = PDF_SECTION_CONFIGS.map((section) => ({
        label: section.title,
        value: totals[section.dataKey],
    }));
    let y = margin;

    const ensureSpace = (height) => {
        const pageHeight = doc.internal.pageSize.getHeight();
        if (y + height > pageHeight - margin) {
            doc.addPage();
            y = margin;
        }
    };

    const drawSection = (section, rows) => {
        ensureSpace(16);
        doc.setFont('helvetica', 'bold');
        doc.setFontSize(12);
        doc.text(section.title, margin, y);
        y += 8;

        const totalWeight = section.columns.reduce((sum, col) => sum + (col.width ?? 1), 0);
        const columnWidths = section.columns.map((col) => ((col.width ?? 1) / totalWeight) * usableWidth);
        const columnPositions = [];
        columnWidths.reduce((acc, width) => {
            columnPositions.push(acc);
            return acc + width;
        }, margin);

        ensureSpace(11);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.setDrawColor(220);
        doc.setFillColor(245);
        doc.rect(margin, y, usableWidth, 9, 'FD');
        section.columns.forEach((col, idx) => {
            doc.text(col.label, columnPositions[idx] + 2, y + 6, {
                maxWidth: columnWidths[idx] - 4,
            });
        });
        y += 11;

        if (!rows.length) {
            ensureSpace(12);
            doc.setFont('helvetica', 'normal');
            doc.text('No records available.', margin, y);
            y += 8;
            return;
        }

        rows.forEach((row) => {
            const columnLines = section.columns.map((col, idx) => {
                const rawValue = col.format ? col.format(row) : row[col.key];
                const textValue =
                    rawValue === null || rawValue === undefined || rawValue === ''
                        ? '-'
                        : typeof rawValue === 'number'
                            ? rawValue.toString()
                            : rawValue;
                return doc.splitTextToSize(String(textValue), columnWidths[idx] - 4);
            });
            const maxLines = columnLines.reduce((max, lines) => Math.max(max, lines.length), 0);
            const lineHeight = 4.2;
            const rowHeight = Math.max(8, maxLines * lineHeight + 2);

            ensureSpace(rowHeight + 4);
            section.columns.forEach((col, idx) => {
                const lines = columnLines[idx].length ? columnLines[idx] : ['-'];
                const align = col.align || 'left';
                const textOptions = {
                    maxWidth: columnWidths[idx] - 4,
                };
                if (align !== 'left') {
                    textOptions.align = align;
                }
                const textX =
                    align === 'right'
                        ? columnPositions[idx] + columnWidths[idx] - 2
                        : align === 'center'
                            ? columnPositions[idx] + columnWidths[idx] / 2
                            : columnPositions[idx] + 2;

                doc.setFont('helvetica', 'normal');
                doc.text(lines, textX, y + 4, textOptions);
            });

            doc.setDrawColor(230);
            doc.line(margin, y + rowHeight, margin + usableWidth, y + rowHeight);
            y += rowHeight;
        });

        y += 6;
    };

    try {
        doc.setFont('helvetica', 'bold');
        doc.setFontSize(16);
        doc.text('Financial Insights Report', margin, y);
        y += 6;
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(10);
        doc.text(`Project: ${projectName}`, margin, y);
        doc.text(`Code: ${projectCode}`, margin + usableWidth / 2, y, { maxWidth: usableWidth / 2 - 8 });
        y += 5;
        doc.text(`Report Range: ${dateRangeText}`, margin, y);
        doc.text(`Generated: ${new Date().toLocaleDateString('en-IN')}`, margin + usableWidth / 2, y, {
            maxWidth: usableWidth / 2 - 8,
        });
        y += 7;
        doc.setDrawColor(180);
        doc.setLineWidth(0.7);
        doc.line(margin, y, margin + usableWidth, y);
        y += 8;

        for (let i = 0; i < summaryItems.length; i += 2) {
            ensureSpace(8);
            const first = summaryItems[i];
            const second = summaryItems[i + 1];
            doc.setFont('helvetica', 'bold');
            doc.text(`${first.label}:`, margin, y);
            doc.setFont('helvetica', 'normal');
            doc.text(formatCurrencyForPdf(first.value), margin + 30, y);
            if (second) {
                const midPoint = margin + usableWidth / 2;
                doc.setFont('helvetica', 'bold');
                doc.text(`${second.label}:`, midPoint, y);
                doc.setFont('helvetica', 'normal');
                doc.text(formatCurrencyForPdf(second.value), midPoint + 30, y);
            }
            y += 6;
        }

        y += 6;

        PDF_SECTION_CONFIGS.forEach((section) => {
            drawSection(section, dataMap[section.dataKey] || []);
        });

        const safeProjectName = projectName.replace(/[^\w\-]/g, '_');
        const safeRange = `${fromDateIso || 'start'}_${toDateIso || 'end'}`.replace(/[^\w\-]/g, '_');
        doc.save(`Financial_Report_${safeProjectName}_${safeRange}.pdf`);
        showBanner('PDF downloaded successfully.', 'success');
    } catch (err) {
        console.error('PDF Export failed', err);
        showBanner('Failed to generate PDF.', 'danger');
    }
};
