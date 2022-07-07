import Vue from 'vue'
import App from '../person_profit.vue'

document.addEventListener('DOMContentLoaded', () => {
  const users = window.users
  const days = ["日", "月", "火", "水", "木", "金", "土"]
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})
