<template>
  <div class="login-container">
    <el-form 
      ref="loginForm" 
      :model="loginForm" 
      class="login-form" 
      :rules="loginRules"
      autocomplete="on" 
      label-position="left">

      <div class="title-container">
        <h3 class="title">登入頁面</h3>
      </div>

      <el-form-item prop="email">
        <el-input
          ref="email"
          v-model="loginForm.email"
          placeholder="Email"
          prefix-icon="el-icon-message"
          name="email"
          type="text"
          tabindex="1"
          autocomplete="on"
        />
      </el-form-item>

      <el-form-item prop="password">
        <el-input
          key="password"
          ref="password"
          v-model="loginForm.password"
          type="password"
          placeholder="Password"
          prefix-icon="el-icon-lock"
          name="password"
          tabindex="2"
          autocomplete="on" 
          @keyup.enter.native="handleLogin"
        />
      </el-form-item>
      <el-button 
        type="primary" 
        style="width:100%;margin-bottom:30px;" 
        @click.native.prevent="handleLogin">
        登入
      </el-button>
    </el-form>

  </div>
</template>
 
<script>
import { mapMutations } from 'vuex';
import userFunc from '../services/user'

export default {
  data () {
    return {
      loginForm: {
        email: '',
        password: ''
      },
      loginRules: {
        email: [{ required: true, trigger: 'blur' }],
        password: [{ required: true, trigger: 'blur' }]
      },
      userToken: '',
    };
  },
 
  methods: {
    ...mapMutations(['userLogin']),
    handleLogin() {
      let _this = this;
      if (this.loginForm.email === '' || this.loginForm.password === '') {
        alert('帳號或密碼不能為空');
      } else {
        userFunc.login(_this.loginForm).then(res => {
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
<style lang="scss" scoped>
.login-form {
    position: relative;
    width: 520px;
    max-width: 100%;
    padding: 160px 35px 0;
    margin: 0 auto;
    overflow: hidden;
    border-radius: 5px;
    color: #454545;
  }
  .title-container {
    position: relative;

    .title {
      font-size: 26px;
      margin: 0px auto 40px auto;
      text-align: center;
      font-weight: bold;
    }
  }
</style>