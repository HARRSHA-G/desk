/*
  # Initial Schema for MediSync

  1. New Tables
    - `doctors`
      - `id` (uuid, primary key)
      - `name` (text)
      - `specialization` (text)
      - `age` (integer)
      - `experience` (integer)
      - `languages_spoken` (text[])
      - `hospital` (text)
      - `morning_slots` (text[])
      - `afternoon_slots` (text[])
      - `evening_slots` (text[])
      - `available_slots` (text[])
      - `created_at` (timestamp)
      
    - `appointments`
      - `id` (uuid, primary key)
      - `doctor_id` (uuid, foreign key)
      - `patient_name` (text)
      - `patient_email` (text)
      - `appointment_date` (date)
      - `appointment_time` (time)
      - `status` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on both tables
    - Add policies for public read access to doctors
    - Add policies for authenticated users to create appointments
*/

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  specialization text NOT NULL,
  age integer NOT NULL,
  experience integer NOT NULL,
  languages_spoken text[] NOT NULL DEFAULT '{}',
  hospital text NOT NULL,
  morning_slots text[] NOT NULL DEFAULT '{}',
  afternoon_slots text[] NOT NULL DEFAULT '{}',
  evening_slots text[] NOT NULL DEFAULT '{}',
  available_slots text[] NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  doctor_id uuid REFERENCES doctors(id) ON DELETE CASCADE,
  patient_name text NOT NULL,
  patient_email text NOT NULL,
  appointment_date date NOT NULL,
  appointment_time time NOT NULL,
  status text NOT NULL CHECK (status IN ('Booked', 'Completed', 'Cancelled')),
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Policies for doctors table
CREATE POLICY "Allow public read access to doctors"
  ON doctors
  FOR SELECT
  TO public
  USING (true);

-- Policies for appointments table
CREATE POLICY "Allow authenticated users to create appointments"
  ON appointments
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow users to view their own appointments"
  ON appointments
  FOR SELECT
  TO authenticated
  USING (patient_email = auth.email());

-- Insert dummy doctors data
INSERT INTO doctors (name, specialization, age, experience, languages_spoken, hospital, morning_slots, afternoon_slots, evening_slots, available_slots)
VALUES
  ('Dr. John Doe', 'Cardiology', 50, 25, ARRAY['English'], 'City Hospital', ARRAY['08:00 AM', '09:00 AM', '10:00 AM'], ARRAY['01:00 PM', '02:00 PM'], ARRAY['05:00 PM', '06:00 PM'], ARRAY['08:00 AM', '01:00 PM', '05:00 PM']),
  ('Dr. Jane Smith', 'Dermatology', 40, 18, ARRAY['English', 'Spanish'], 'General Hospital', ARRAY['09:00 AM', '10:00 AM', '11:00 AM'], ARRAY['12:00 PM', '01:00 PM', '02:00 PM'], ARRAY['04:00 PM', '05:00 PM', '06:00 PM'], ARRAY['09:00 AM', '12:00 PM', '04:00 PM']);