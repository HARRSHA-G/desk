import React from 'react';
import { Button, FormControl, FormLabel, Grid, Input, Option, Select, Stack } from '@mui/joy';

const FlatPaymentForm = ({ payment, onChange, onSubmit, blockOptions, floorOptions, unitOptions }) => {
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
                <Grid container spacing={2}>
                    <Grid xs={6}>
                        <FormControl disabled={!blockOptions.length}>
                            <FormLabel>Block</FormLabel>
                            <Select
                                value={payment.block}
                                onChange={(e, val) => onChange({ ...payment, block: val, floor: '', unit: '' })}
                            >
                                {blockOptions.map((b) => (
                                    <Option key={b.value} value={b.value}>
                                        {b.label}
                                    </Option>
                                ))}
                            </Select>
                        </FormControl>
                    </Grid>
                    <Grid xs={6}>
                        <FormControl disabled={!floorOptions.length}>
                            <FormLabel>Floor</FormLabel>
                            <Select
                                value={payment.floor}
                                onChange={(e, val) => onChange({ ...payment, floor: val, unit: '' })}
                            >
                                {floorOptions.map((f) => (
                                    <Option key={f.value} value={f.value}>
                                        {f.label}
                                    </Option>
                                ))}
                            </Select>
                        </FormControl>
                    </Grid>
                </Grid>
                <FormControl required disabled={!unitOptions.length}>
                    <FormLabel>Flat Unit</FormLabel>
                    <Select
                        value={payment.unit}
                        onChange={(e, val) => onChange({ ...payment, unit: val })}
                    >
                        {unitOptions.map((u) => (
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
                <FormControl>
                    <FormLabel>Stage</FormLabel>
                    <Select
                        value={payment.payment_stage}
                        onChange={(e, val) => onChange({ ...payment, payment_stage: val })}
                    >
                        <Option value="advance">Advance</Option>
                        <Option value="installment">Installment</Option>
                        <Option value="final">Final</Option>
                    </Select>
                </FormControl>
                <Button type="submit" size="lg" sx={{ mt: 2 }}>
                    Record Flat Payment
                </Button>
            </Stack>
        </form>
    );
};

export default FlatPaymentForm;
