
import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);
 
const store = new Vuex.Store({
  state: {
    userId: localStorage.getItem('userId') ? localStorage.getItem('userId') : '',
    Authorization: localStorage.getItem('Authorization') ? localStorage.getItem('Authorization') : '',
    isAdmin: localStorage.getItem('isAdmin') ? localStorage.getItem('isAdmin') : '',
  },
  mutations: {
    userLogin(state, user) {
      state.userId = user.userId;
      state.Authorization = user.Authorization;
      state.isAdmin = user.isAdmin;
      localStorage.setItem('userId', user.userId);
      localStorage.setItem('Authorization', user.Authorization);
      localStorage.setItem('isAdmin', user.isAdmin);
    },
    userLogout(state) {
      localStorage.removeItem('userId');
      localStorage.removeItem('Authorization');
      localStorage.removeItem('isAdmin');
    }
  }
});

export default store;