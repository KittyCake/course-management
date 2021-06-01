<template>
  <div id="app">
    <el-container>
      <el-header v-if="userId">
        <el-button type='primary' @click="logoutBtn">
          登出
        </el-button>
      </el-header>
      <el-main>
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
    userId() {
      console.log(this.$store.state.userId)
      return this.$store.state.userId
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

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
