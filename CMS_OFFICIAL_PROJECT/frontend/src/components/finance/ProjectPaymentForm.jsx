import React from 'react';
import { Button, FormControl, FormLabel, Input, Option, Select, Stack, Textarea } from '@mui/joy';

const ProjectPaymentForm = ({ payment, onChange, onSubmit }) => {
    return (
        <form onSubmit={onSubmit}>
            <Stack spacing={2}>
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
                    <FormLabel>Payment Type</FormLabel>
                    <Select
                        value={payment.payment_type}
                        onChange={(e, val) => onChange({ ...payment, payment_type: val })}
                    >
                        <Option value="Advance">Advance</Option>
                        <Option value="Installment">Installment</Option>
                        <Option value="Full">Full</Option>
                    </Select>
                </FormControl>
                <FormControl>
                    <FormLabel>Description</FormLabel>
                    <Textarea
                        minRows={3}
                        value={payment.description}
                        onChange={(e) => onChange({ ...payment, description: e.target.value })}
                    />
                </FormControl>
                <Button type="submit" size="lg" sx={{ mt: 2 }}>
                    Record Project Payment
                </Button>
            </Stack>
        </form>
    );
};

export default ProjectPaymentForm;
