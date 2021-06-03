<template>
  <div id="app">
    <el-container>
      <el-header v-if="!isLogin">
        <h2 id="app-title">課程管理系統</h2>
      </el-header>
      <el-main>
        <el-button type='warning' @click="logoutBtn" style="float: right;">
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
    isLogin() {
      console.log(this.$route.path)
      return this.$route.path === '/login'
    },
  },
  methods: {
    ...mapMutations(['userLogout']),
    logoutBtn() {
      let _this = this;
      _this.userLogout()
      userFunc.logout(this.userId).then(res => {
        _this.$router.go('/login'); 
      }).catch(error => {
        console.log(error);
      });
    },
  }
}
</script>

<style lang="scss" scoped>
#app-title {
  text-align: center;
}
</style>
