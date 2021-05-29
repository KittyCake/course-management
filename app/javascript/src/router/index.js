import Vue from 'vue'
import Router from 'vue-router'

import login from '../views/login.vue'
import course from '../views/course.vue'

Vue.use(Router)

export const constantRoutes = [
  {
    path: `/`,
    redirect: `/login`,
  },
  {
    name: 'Login',
    path: `/login`,
    component: login,
  },
  {
    name: 'CourseList',
    path: `/courses`,
    component: course,
  },
]

const createRouter = () => new Router({
  mode: 'history',
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes,
})

const router = createRouter()

router.beforeEach((to, from, next) => {
  if (to.path === '/login') {
    next();
  } else {
    let token = localStorage.getItem('Authorization')
    let isAdmin = localStorage.getItem('isAdmin')

    if (token === null || token === '') {
      next('/login');
    } else if (token !== null && !isAdmin) {
      window.location.replace("http://localhost:4321/apidoc");
    } else {
      next();
    }
  }
})

// export function resetRouter() {
//   const newRouter = createRouter()
//   router.matcher = newRouter.matcher
// }

export default router