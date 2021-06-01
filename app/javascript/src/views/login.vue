<template>
  <div>
    <input type="text" v-model="loginForm.email" placeholder="Email"/>
    <input type="text" v-model="loginForm.password" placeholder="Password"/>
    <button @click="login">登入</button>
  </div>
</template>
 
<script>
import { mapMutations } from 'vuex';
import axios from 'axios'

export default {
  data () {
    return {
      loginForm: {
        email: '',
        password: ''
      },
      userToken: ''
    };
  },
 
  methods: {
    ...mapMutations(['userLogin']),
    login () {
      let _this = this;
      if (this.loginForm.email === '' || this.loginForm.password === '') {
        alert('帳號或密碼不能為空');
      } else {
        axios({
          method: 'post',
          url: `http://localhost:4321/api/v1/users/login`,
          data: _this.loginForm
        }).then(res => {
          console.log(res.data);
          const reponse = res.data;
          _this.userToken = reponse.token;
          _this.userLogin({ 
            userId: reponse.id, 
            Authorization: _this.userToken,
            isAdmin: _this.isAdmin,
          });
          _this.$router.push('/courses');
        }).catch(error => {
          alert('帳號或密碼錯誤');
          console.log(error);
        });
      }
    }
  }
};
</script>
