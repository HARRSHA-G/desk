import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { format, addDays } from 'date-fns';
import { MapPin, ChevronLeft, Sunrise, Sun, Sunset } from 'lucide-react';
import { supabase } from '../lib/supabase';
import Login from './Login';

interface Doctor {
  id: string;
  name: string;
  specialization: string;
  qualification: string;
  hospital: string;
  experience: number;
  languages_spoken: string[];
  morning_slots: string[];
  afternoon_slots: string[];
  evening_slots: string[];
  available_slots: string[];
  profile_image: string;
}

interface User {
  id: string;
  email?: string;
}

const DoctorProfile = () => {
  const { id } = useParams();
  const [doctor, setDoctor] = useState<Doctor | null>(null);
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [selectedTime, setSelectedTime] = useState<string>('');
  const [bookingStatus, setBookingStatus] = useState<string>('');
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const [bookedSlots, setBookedSlots] = useState<Record<string, string[]>>({});

  useEffect(() => {
    fetchDoctor();
    checkUser();
  }, [id]);

  useEffect(() => {
    if (id && selectedDate) {
      fetchBookedSlots();
    }
  }, [id, selectedDate]);

  const checkUser = async () => {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      setUser(session?.user || null);
    } catch (error) {
      console.error('Error checking user:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchDoctor = async () => {
    if (!id) return;

    const { data, error } = await supabase
      .from('doctors')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      console.error('Error fetching doctor:', error);
      return;
    }

    setDoctor(data);
  };

  const fetchBookedSlots = async () => {
    if (!id) return;

    const formattedDate = format(selectedDate, 'yyyy-MM-dd');
    
    const { data, error } = await supabase
      .from('appointments')
      .select('appointment_time')
      .eq('doctor_id', id)
      .eq('appointment_date', formattedDate)
      .eq('status', 'Booked');

    if (error) {
      console.error('Error fetching booked slots:', error);
      return;
    }

    // Extract the appointment times
    const unavailableTimes = data.map(appointment => appointment.appointment_time);
    
    // Update the booked slots state
    setBookedSlots(prev => ({
      ...prev,
      [formattedDate]: unavailableTimes
    }));
  };

  const isSlotBooked = (slot: string): boolean => {
    const formattedDate = format(selectedDate, 'yyyy-MM-dd');
    return bookedSlots[formattedDate]?.includes(slot) || false;
  };

  const handleBooking = async () => {
    try {
      // First check if user is logged in
      if (!user) {
        setShowLoginModal(true);
        return;
      }

      if (!doctor || !selectedDate || !selectedTime) {
        setBookingStatus('Please select both date and time');
        return;
      }

      const formattedDate = format(selectedDate, 'yyyy-MM-dd');

      // Check if the slot is already booked
      if (isSlotBooked(selectedTime)) {
        setBookingStatus('This slot is no longer available. Please select another time.');
        setSelectedTime('');
        return;
      }

      setBookingStatus('Processing...');

      const { data: profileData, error: profileError } = await supabase
        .from('profiles')
        .select('username, mobile')
        .eq('id', user.id)
        .single();

      if (profileError) {
        console.error('Error fetching profile:', profileError);
        setBookingStatus(`Failed to book appointment: ${profileError.message}`);
        return;
      }

      if (!profileData) {
        setBookingStatus('Profile data not found');
        return;
      }

      const { error } = await supabase
        .from('appointments')
        .insert({
          doctor_id: doctor.id,
          patient_name: profileData.username,
          patient_email: user.email,
          patient_mobile: profileData.mobile,
          appointment_date: formattedDate,
          appointment_time: selectedTime,
          status: 'Booked'
        });

      if (error) {
        console.error('Error booking appointment:', error);
        setBookingStatus(`Failed to book appointment: ${error.message}`);
        return;
      }

      // Update local state to reflect the newly booked slot
      setBookedSlots(prev => ({
        ...prev,
        [formattedDate]: [...(prev[formattedDate] || []), selectedTime]
      }));

      setBookingStatus('Appointment booked successfully!');
      setSelectedTime('');
    } catch (err) {
      console.error('Unexpected error:', err);
      setBookingStatus('An unexpected error occurred');
    }
  };

  const handleLoginSuccess = () => {
    setShowLoginModal(false);
    checkUser();
  };

  // Handler for date selection to refresh booked slots
  const handleDateSelect = (date: Date) => {
    setSelectedDate(date);
    setSelectedTime(''); // Clear the selected time when date changes
  };

  if (loading) {
    return <div className="flex justify-center items-center h-screen">Loading...</div>;
  }

  if (!doctor) {
    return <div className="flex justify-center items-center h-screen">Doctor not found</div>;
  }

  // If the login modal is showing, render it
  if (showLoginModal) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-8">
        <h2 className="text-xl font-semibold mb-6 text-center">Please sign in to book an appointment</h2>
        <Login onLoginSuccess={handleLoginSuccess} />
        <button 
          onClick={() => setShowLoginModal(false)} 
          className="mt-4 w-full text-gray-600 hover:underline"
        >
          Cancel
        </button>
      </div>
    );
  }

  const dates = Array.from({ length: 7 }, (_, i) => addDays(new Date(), i));

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <Link to="/" className="flex items-center text-blue-600 mb-6">
        <ChevronLeft className="h-5 w-5" />
        <span>Back to DocEase Doctors</span>
      </Link>

      <div className="bg-white rounded-lg shadow-md p-6 mb-8">
        <div className="mb-4 flex justify-between items-center">
          <div className="flex items-center gap-2">
            <img
              src={doctor.profile_image}
              alt={doctor.name}
              className="w-32 h-32 rounded-lg object-cover"
            />
            <div>
              <h1 className="text-2xl font-bold text-gray-900 mb-2">{doctor.name}</h1>
              <p className="text-teal-600 mb-2">
                {doctor.experience} years, {doctor.specialization}
              </p>
              <p className="text-gray-600 mb-2">{doctor.qualification}</p>
              <div className="flex items-center text-gray-600">
                <MapPin className="h-4 w-4 mr-1" />
                {doctor.hospital}
              </div>
            </div>
          </div>
        </div>

        <hr className="my-6" />

        <h2 className="text-xl font-semibold mb-6">Schedule Appointment</h2>

        {/* Date Selection */}
        <div className="mb-8">
          <h3 className="text-lg font-medium mb-4">Select Date</h3>
          <div className="flex gap-4 overflow-x-auto pb-4">
            {dates.map((date) => (
              <button
                key={date.toISOString()}
                onClick={() => handleDateSelect(date)}
                className={`flex flex-col items-center min-w-[100px] p-4 rounded-lg border ${
                  format(selectedDate, 'yyyy-MM-dd') === format(date, 'yyyy-MM-dd')
                    ? 'border-blue-600 bg-blue-50'
                    : 'border-gray-200 hover:border-blue-600'
                }`}
              >
                <span className="text-sm text-gray-600">
                  {format(date, 'EEE')}
                </span>
                <span className="text-lg font-semibold">
                  {format(date, 'dd')}
                </span>
                <span className="text-sm text-gray-600">
                  {format(date, 'MMM')}
                </span>
              </button>
            ))}
          </div>
        </div>

        {/* Time Slots */}
        <div className="space-y-6">
          {/* Morning Slots */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <Sunrise className="h-5 w-5 text-orange-500" />
              <h3 className="text-lg font-medium">Morning Slots</h3>
            </div>
            <div className="grid grid-cols-4 gap-3">
              {doctor.morning_slots.map((slot) => {
                const isUnavailable = isSlotBooked(slot);
                return (
                  <button
                    key={slot}
                    onClick={() => !isUnavailable && setSelectedTime(slot)}
                    disabled={isUnavailable}
                    className={`py-2 px-4 rounded-lg border ${
                      isUnavailable 
                        ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed line-through'
                        : selectedTime === slot
                          ? 'border-blue-600 bg-blue-50 text-blue-600'
                          : 'border-gray-200 hover:border-blue-600'
                    }`}
                  >
                    {slot}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Afternoon Slots */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <Sun className="h-5 w-5 text-orange-500" />
              <h3 className="text-lg font-medium">Afternoon Slots</h3>
            </div>
            <div className="grid grid-cols-4 gap-3">
              {doctor.afternoon_slots.map((slot) => {
                const isUnavailable = isSlotBooked(slot);
                return (
                  <button
                    key={slot}
                    onClick={() => !isUnavailable && setSelectedTime(slot)}
                    disabled={isUnavailable}
                    className={`py-2 px-4 rounded-lg border ${
                      isUnavailable 
                        ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed line-through'
                        : selectedTime === slot
                          ? 'border-blue-600 bg-blue-50 text-blue-600'
                          : 'border-gray-200 hover:border-blue-600'
                    }`}
                  >
                    {slot}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Evening Slots */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <Sunset className="h-5 w-5 text-orange-500" />
              <h3 className="text-lg font-medium">Evening Slots</h3>
            </div>
            <div className="grid grid-cols-4 gap-3">
              {doctor.evening_slots.map((slot) => {
                const isUnavailable = isSlotBooked(slot);
                return (
                  <button
                    key={slot}
                    onClick={() => !isUnavailable && setSelectedTime(slot)}
                    disabled={isUnavailable}
                    className={`py-2 px-4 rounded-lg border ${
                      isUnavailable 
                        ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed line-through'
                        : selectedTime === slot
                          ? 'border-blue-600 bg-blue-50 text-blue-600'
                          : 'border-gray-200 hover:border-blue-600'
                    }`}
                  >
                    {slot}
                  </button>
                );
              })}
            </div>
          </div>
        </div>

        {bookingStatus && (
          <div className={`mt-6 p-4 rounded-lg ${
            bookingStatus.includes('success')
              ? 'bg-green-100 text-green-700'
              : bookingStatus === 'Processing...'
              ? 'bg-blue-100 text-blue-700'
              : 'bg-red-100 text-red-700'
          }`}>
            {bookingStatus}
          </div>
        )}

        <button
          onClick={handleBooking}
          className={`mt-8 w-full py-3 rounded-lg transition-colors ${
            user && selectedTime 
              ? 'bg-orange-500 text-white hover:bg-orange-600' 
              : 'bg-gray-300 text-gray-700 cursor-not-allowed'
          }`}
          disabled={!user || !selectedTime}
        >
          {!user ? 'Sign in to Book' : !selectedTime ? 'Select a time slot' : 'Book Appointment'}
        </button>
      </div>
    </div>
  );
};

export default DoctorProfile;