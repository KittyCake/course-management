import request from './request'

export default {
  prefix: '/api/v1',
  url: '',
  login(loginForm) {
    this.url = `${this.prefix}/users/login`
    return request.post(this.url, loginForm)
  },
  logout(id) {
    this.url = `${this.prefix}/users/logout`
    const params = { id: id }
    return request.post(this.url, params)
  },
}