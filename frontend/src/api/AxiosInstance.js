import axios from 'axios';

const AxiosInstance = axios.create({}); //axios instance

axios.defaults.withCredentials = true;

AxiosInstance.interceptors.request.use(
  (config) => {
    console.log(config);
    return config;
  },
  (error) => {
    console.log(error);
    return Promise.reject(error);
  },
);

AxiosInstance.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    return Promise.reject(error);
  },
);

export default AxiosInstance;
