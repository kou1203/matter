
import Vue from 'vue'
import App from '../visit_items.vue'
document.addEventListener('DOMContentLoaded', () => {
  const users = window.users
  const visit_items_chubu = window.results_chubu
  const visit_items_kansai = window.results_kansai
  const visit_items_kanto = window.results_kanto
  const days = ["日", "月", "火", "水", "木", "金", "土"]
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})


