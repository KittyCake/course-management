import request from './request'

export default {
  prefix: '/api/v1',
  url: '',
  getCourseList() {
    this.url = `${this.prefix}/courses`
    return request.get(this.url)
  },
  createCourse(newCourse) {
    this.url = `${this.prefix}/courses`
    return request.post(this.url, newCourse)
  },
  editCourse(id, newCourse) {
    this.url = `${this.prefix}/courses/${id}`
    return request.patch(this.url, newCourse)
  },
  deleteCourse(id) {
    this.url = `${this.prefix}/courses/${id}`
    return request.delete(this.url)
  },
  getCategoryList() {
    this.url = `${this.prefix}/categories`
    return request.get(this.url)
  },
  getCurrencyList() {
    this.url = `${this.prefix}/courses/currencies`
    return request.get(this.url)
  },
}