import axios from 'axios';

const api = axios.create({
    baseURL: 'http://time-manager.io:4000/api/',
    headers: {
        'Content-Type': 'application/json',
    },
});

export default api;