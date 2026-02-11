import axios from 'axios';

// Get CSRF token from cookies (Django specific)
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

const api = axios.create({
    baseURL: import.meta.env.VITE_API_URL || '/api/v1', // Rule 43: Use Environment Variables for URLs
    withCredentials: true,
    headers: {
        'Content-Type': 'application/json',
    }
});

// Add CSRF token to requests
api.interceptors.request.use((config) => {
    const csrftoken = getCookie('csrftoken');
    if (csrftoken) {
        config.headers['X-CSRFToken'] = csrftoken;
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

// Response interceptor for error handling
api.interceptors.response.use((response) => {
    return response;
}, (error) => {
    // Handle 401 Unauthorized (redirect to login if needed, or just let component handle it)
    if (error.response && error.response.status === 401) {
        // window.location.href = '/login'; // Or handle via React Router
        console.warn('Unauthorized access');
    }
    return Promise.reject(error);
});

export default api;
