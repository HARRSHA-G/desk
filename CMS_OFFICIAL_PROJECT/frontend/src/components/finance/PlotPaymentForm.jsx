import React from 'react';
import { Button, FormControl, FormLabel, Input, Option, Select, Stack } from '@mui/joy';

const PlotPaymentForm = ({ payment, onChange, onSubmit, plotOptions }) => {
    return (
        <form onSubmit={onSubmit}>
            <Stack spacing={2}>
                <FormControl required>
                    <FormLabel>Receipt ID</FormLabel>
                    <Input
                        value={payment.receipt_id}
                        onChange={(e) => onChange({ ...payment, receipt_id: e.target.value })}
                    />
                </FormControl>
                <FormControl required disabled={!plotOptions.length}>
                    <FormLabel>Plot Unit</FormLabel>
                    <Select
                        value={payment.unit}
                        onChange={(e, val) => onChange({ ...payment, unit: val })}
                    >
                        {plotOptions.map((u) => (
                            <Option key={u.value} value={u.value}>
                                {u.label}
                            </Option>
                        ))}
                    </Select>
                </FormControl>
                <FormControl required>
                    <FormLabel>Amount</FormLabel>
                    <Input
                        type="number"
                        startDecorator="₹"
                        value={payment.amount}
                        onChange={(e) => onChange({ ...payment, amount: e.target.value })}
                    />
                </FormControl>
                <FormControl required>
                    <FormLabel>Payment Date</FormLabel>
                    <Input
                        type="date"
                        value={payment.payment_date}
                        onChange={(e) => onChange({ ...payment, payment_date: e.target.value })}
                    />
                </FormControl>
                <FormControl>
                    <FormLabel>Stage</FormLabel>
                    <Select
                        value={payment.payment_stage}
                        onChange={(e, val) => onChange({ ...payment, payment_stage: val })}
                    >
                        <Option value="booking">Booking</Option>
                        <Option value="construction_stage">Construction</Option>
                        <Option value="handover">Handover</Option>
                    </Select>
                </FormControl>
                <Button type="submit" size="lg" sx={{ mt: 2 }}>
                    Record Plot Payment
                </Button>
            </Stack>
        </form>
    );
};

export default PlotPaymentForm;
