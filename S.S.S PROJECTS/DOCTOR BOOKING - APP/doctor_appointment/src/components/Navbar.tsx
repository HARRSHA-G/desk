import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Heart } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { User } from '@supabase/supabase-js';

const Navbar = () => {
  const [user, setUser] = useState<User | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    checkUser();
  }, []);

  const checkUser = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    setUser(session?.user || null);
  };

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    setUser(null);
    navigate('/');
  };

  return (
    <nav className="bg-blue-500 shadow-lg">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          <Link to="/" className="flex items-center space-x-2">
            <Heart className="h-8 w-8 text-green-600" />
            <span className="text-2xl font-extrabold text-white tracking-wide">Doc<span className="text-green-600">Ease</span></span>
          </Link>
          
          <div className="hidden md:flex items-center space-x-8">
            <Link to="/" className="text-white hover:text-green-200">Patient Care</Link>
            <Link to="/" className="text-white hover:text-green-200">Health Information</Link>
            <Link to="/" className="text-white hover:text-green-200">Locations</Link>
            <Link to="/" className="text-white hover:text-green-200">Contact</Link>
            <Link to="/about" className="text-white hover:text-green-200">About Us</Link>
          </div>

          <div className="flex items-center space-x-4">
            {user ? (
              <button onClick={handleSignOut} className="bg-green-600 text-white px-4 py-2 rounded">
                Sign Out
              </button>
            ) : (
              <Link to="/login" className="bg-green-600 text-white px-4 py-2 rounded">
                Sign In
              </Link>
            )}
            <select className="border rounded px-2 py-1">
              <option>English</option>
              <option>Hindi</option>
              <option>Telugu</option>
            </select>
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;