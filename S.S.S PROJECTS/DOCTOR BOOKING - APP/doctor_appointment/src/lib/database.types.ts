export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      doctors: {
        Row: {
          id: string
          name: string
          specialization: string
          qualification: string
          age: number
          experience: number
          languages_spoken: string[]
          hospital: string
          morning_slots: string[]
          afternoon_slots: string[]
          evening_slots: string[]
          available_slots: string[]
          profile_image: string
          bio: string
          created_at: string
          city: string // Added city column
        }
        Insert: {
          id?: string
          name: string
          specialization: string
          qualification: string
          age: number
          experience: number
          languages_spoken?: string[]
          hospital: string
          morning_slots?: string[]
          afternoon_slots?: string[]
          evening_slots?: string[]
          available_slots?: string[]
          profile_image: string
          bio: string
          created_at?: string
          city: string // Added city column
        }
        Update: {
          id?: string
          name?: string
          specialization?: string
          qualification?: string
          age?: number
          experience?: number
          languages_spoken?: string[]
          hospital?: string
          morning_slots?: string[]
          afternoon_slots?: string[]
          evening_slots?: string[]
          available_slots?: string[]
          profile_image?: string
          bio?: string
          created_at?: string
          city?: string // Added city column
        }
      }
      appointments: {
        Row: {
          id: string
          doctor_id: string
          patient_name: string
          patient_email: string
          patient_mobile: string // Changed to VARCHAR
          appointment_date: string
          appointment_time: string
          status: string
          created_at: string
        }
        Insert: {
          id?: string
          doctor_id: string
          patient_name: string
          patient_email: string
          patient_mobile: string // Changed to VARCHAR
          appointment_date: string
          appointment_time: string
          status: string
          created_at?: string
        }
        Update: {
          id?: string
          doctor_id?: string
          patient_name?: string
          patient_email?: string
          patient_mobile?: string // Changed to VARCHAR
          appointment_date?: string
          appointment_time?: string
          status?: string
          created_at?: string
        }
      }
      profiles: {
        Row: {
          id: string
          username: string
          mobile: string
        }
        Insert: {
          id: string
          username: string
          mobile: string
        }
        Update: {
          id?: string
          username?: string
          mobile?: string
        }
      }
    }
  }
}