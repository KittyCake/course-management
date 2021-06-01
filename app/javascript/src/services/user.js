import request from './request'

export default {
  prefix: '/api/v1',
  url: '',
  logout(id) {
    this.url = `${this.prefix}/users/logout`
    const params = { id: id }
    return request.post(this.url, params)
  },
  logout(id) {
    this.url = `${this.prefix}/users/logout`
    const params = { id: id }
    return request.post(this.url, params)
  },
}