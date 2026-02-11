import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import Login from './Login';
import { User } from '@supabase/supabase-js';

interface Doctor {
  id: string;
  name: string;
  specialization: string;
  hospital: string;
  profile_image: string;
  city: string;
}

const DoctorList = () => {
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [specializationFilter, setSpecializationFilter] = useState<string[]>([]);
  const [locationFilter, setLocationFilter] = useState<string[]>([]);
  const [hospitalFilter, setHospitalFilter] = useState<string[]>([]);
  const [user, setUser] = useState<User | null>(null);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const [selectedDoctorId, setSelectedDoctorId] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    fetchDoctors();
    checkUser();
  }, []);

  const fetchDoctors = async () => {
    const { data, error } = await supabase.from('doctors').select('id, name, specialization, hospital, profile_image, city');
    if (error) {
      console.error('Error fetching doctors:', error);
    } else {
      setDoctors(data);
    }
  };

  const checkUser = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    setUser(session?.user || null);
  };

  const handleBookAppointment = (doctorId: string) => {
    if (!user) {
      setSelectedDoctorId(doctorId);
      setShowLoginModal(true);
    } else {
      navigate(`/doctor/${doctorId}`);
    }
  };

  const handleLoginSuccess = () => {
    setShowLoginModal(false);
    checkUser();
    if (selectedDoctorId) {
      navigate(`/doctor/${selectedDoctorId}`);
    }
  };

  const handleFilterChange = (filterType: string, value: string) => {
    let updatedFilter;
    if (filterType === 'specialization') {
      updatedFilter = specializationFilter.includes(value)
        ? specializationFilter.filter(item => item !== value)
        : [...specializationFilter, value];
      setSpecializationFilter(updatedFilter);
    } else if (filterType === 'location') {
      updatedFilter = locationFilter.includes(value)
        ? locationFilter.filter(item => item !== value)
        : [...locationFilter, value];
      setLocationFilter(updatedFilter);
    } else if (filterType === 'hospital') {
      updatedFilter = hospitalFilter.includes(value)
        ? hospitalFilter.filter(item => item !== value)
        : [...hospitalFilter, value];
      setHospitalFilter(updatedFilter);
    }
  };

  const filteredDoctors = doctors.filter(doctor =>
    (doctor.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    doctor.specialization.toLowerCase().includes(searchTerm.toLowerCase()) ||
    doctor.city.toLowerCase().includes(searchTerm.toLowerCase())) &&
    (specializationFilter.length === 0 || specializationFilter.includes(doctor.specialization)) &&
    (locationFilter.length === 0 || locationFilter.includes(doctor.city)) &&
    (hospitalFilter.length === 0 || hospitalFilter.includes(doctor.hospital))
  );

  const specializations = [...new Set(doctors.map(doctor => doctor.specialization))];
  const locations = [...new Set(doctors.map(doctor => doctor.city))];
  const hospitals = [...new Set(doctors.map(doctor => doctor.hospital))];

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-8 text-center">Select a DocEase Doctor</h1>
      
      <div className="flex">
        <div className="w-1/4 pr-4">
          <h2 className="text-xl font-semibold mb-4">Filters</h2>
          <div className="mb-4">
            <label className="block text-gray-700 mb-2 font-semibold">Specialization</label>
            {specializations.map(specialization => (
              <div key={specialization} className="flex items-center mb-2">
                <input
                  type="checkbox"
                  id={`specialization-${specialization}`}
                  value={specialization}
                  checked={specializationFilter.includes(specialization)}
                  onChange={() => handleFilterChange('specialization', specialization)}
                  className="mr-2"
                />
                <label htmlFor={`specialization-${specialization}`} className="text-gray-700">{specialization}</label>
              </div>
            ))}
          </div>
          <div className="mb-4">
            <label className="block text-gray-700 mb-2 font-semibold">Location</label>
            {locations.map(location => (
              <div key={location} className="flex items-center mb-2">
                <input
                  type="checkbox"
                  id={`location-${location}`}
                  value={location}
                  checked={locationFilter.includes(location)}
                  onChange={() => handleFilterChange('location', location)}
                  className="mr-2"
                />
                <label htmlFor={`location-${location}`} className="text-gray-700">{location}</label>
              </div>
            ))}
          </div>
          <div className="mb-4">
            <label className="block text-gray-700 mb-2 font-semibold">Hospital</label>
            {hospitals.map(hospital => (
              <div key={hospital} className="flex items-center mb-2">
                <input
                  type="checkbox"
                  id={`hospital-${hospital}`}
                  value={hospital}
                  checked={hospitalFilter.includes(hospital)}
                  onChange={() => handleFilterChange('hospital', hospital)}
                  className="mr-2"
                />
                <label htmlFor={`hospital-${hospital}`} className="text-gray-700">{hospital}</label>
              </div>
            ))}
          </div>
        </div>
        <div className="w-3/4">
          <div className="mb-8">
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Search by name, specialization, or city"
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredDoctors.length > 0 ? (
              filteredDoctors.map((doctor) => (
                <div key={doctor.id} className="bg-white rounded-xl shadow-md hover:shadow-xl transition-shadow duration-300 overflow-hidden flex flex-col h-full border border-gray-100">
                  <div className="relative">
                    <div className="absolute inset-0 bg-gradient-to-t from-gray-900/50 to-transparent z-10"></div>
                    <img
                      src={doctor.profile_image}
                      alt={doctor.name}
                      className="w-full h-48 object-cover"
                    />
                  </div>
                  
                  <div className="p-6 flex-grow flex flex-col">
                    <div className="flex-grow">
                      <h2 className="text-xl font-bold text-gray-900 mb-2">{doctor.name}</h2>
                      <div className="flex items-center mb-3">
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-sm font-medium bg-teal-100 text-teal-800">
                          {doctor.specialization}
                        </span>
                      </div>
                      
                      <div className="space-y-2 text-gray-600">
                        <div className="flex items-center">
                          <svg className="w-5 h-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 10a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1h-4a1 1 0 01-1-1v-4z"/>
                          </svg>
                          <span>{doctor.hospital}</span>
                        </div>
                        
                        <div className="flex items-center">
                          <svg className="w-5 h-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                          </svg>
                          <span>{doctor.city}</span>
                        </div>
                      </div>
                    </div>

                    <button
                      onClick={() => handleBookAppointment(doctor.id)}
                      className="mt-6 w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-3 rounded-lg hover:from-blue-700 hover:to-blue-800 transition-all duration-300 flex items-center justify-center space-x-2 font-medium"
                    >
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                      </svg>
                      <span>Book Appointment</span>
                    </button>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center text-gray-600 col-span-full py-12">
                <svg className="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <p className="text-xl font-medium">No doctors found</p>
                <p className="text-gray-500">Try adjusting your search filters</p>
              </div>
            )}
          </div>
        </div>
      </div>

      {showLoginModal && (
        <>
          {/* Semi-transparent overlay */}
          <div className="fixed inset-0 bg-black/30 backdrop-blur-sm z-40" 
               onClick={() => setShowLoginModal(false)}
          />
          {/* Modal content */}
          <div className="fixed inset-0 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-xl shadow-lg p-6 max-w-md w-full">
              <div className="flex justify-between items-center mb-4">
                <h2 className="text-xl font-semibold">Please sign in to book an appointment</h2>
                <button 
                  onClick={() => setShowLoginModal(false)}
                  className="text-gray-400 hover:text-gray-600"
                >
                  ✕
                </button>
              </div>
              <Login onLoginSuccess={handleLoginSuccess} />
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default DoctorList;
