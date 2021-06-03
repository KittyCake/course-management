<template>
  <div id="app">
    <el-container>
      <el-main>
        <el-button 
          v-if="!isLoginPage"
          type='warning' 
          @click="logoutBtn" 
          style="float: right;">
          登出
        </el-button>
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script>
import userFunc from 'src/services/user'
import { mapMutations } from 'vuex';

export default {
  computed: {
    isLoginPage() {
      return this.$route.path === '/login'
    },
  },
  methods: {
    ...mapMutations(['userLogout']),
    logoutBtn() {
      let _this = this;
      userFunc.logout(this.userId).then(res => {
        _this.$router.go('/login'); 
        _this.userLogout()
      }).catch(error => {
        console.log(error);
      });
    },
  }
}
</script>
