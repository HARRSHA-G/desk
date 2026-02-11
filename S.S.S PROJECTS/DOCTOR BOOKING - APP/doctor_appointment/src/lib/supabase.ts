import { createClient } from '@supabase/supabase-js';
import { Database } from './database.types';

// Provide default values for development - these will be overwritten by actual values when connected
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'http://localhost:54321';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'placeholder-key';

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);