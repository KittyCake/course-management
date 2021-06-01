import axios from 'axios'
import router from '../router';
import store from '../store';

const service = axios.create({
  baseUrl: process.env.VUE_APP_BASE_URL,
  timeout: 10000,
})

service.interceptors.request.use(
  config => {
    if (localStorage.getItem('Authorization')) {
      config.headers.Authorization = `Bearer ${localStorage.getItem('Authorization')}`;
    }

    return config
  },
  error => {
    return Promise.reject(error);
  }
);

const thisRouter = router

const logout = () => {
  store.dispatch('logout', '');
  router.push('/login');
};

service.interceptors.response.use(
  res => res,
  error => {
    const { response, config } = error;
    if (response && response.status === 401 && thisRouter.currentRoute.name !== 'LogIn') {
      logout();
    }
    return Promise.reject(error);
  },
)

export default service;