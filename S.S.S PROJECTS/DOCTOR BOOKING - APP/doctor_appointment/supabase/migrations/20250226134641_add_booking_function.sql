-- Create a function for atomic booking operations
CREATE OR REPLACE FUNCTION book_appointment(
  p_doctor_id UUID,
  p_patient_name TEXT,
  p_patient_email TEXT,
  p_appointment_date DATE,
  p_appointment_time TIME
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if slot is already booked (with row lock)
  IF EXISTS (
    SELECT 1
    FROM appointments
    WHERE doctor_id = p_doctor_id
    AND appointment_date = p_appointment_date
    AND appointment_time = p_appointment_time
    AND status = 'Booked'
    FOR UPDATE SKIP LOCKED
  ) THEN
    RAISE EXCEPTION 'Slot already booked';
  END IF;

  -- Insert new appointment
  INSERT INTO appointments (
    doctor_id,
    patient_name,
    patient_email,
    appointment_date,
    appointment_time,
    status
  ) VALUES (
    p_doctor_id,
    p_patient_name,
    p_patient_email,
    p_appointment_date,
    p_appointment_time,
    'Booked'
  );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION book_appointment TO authenticated;
