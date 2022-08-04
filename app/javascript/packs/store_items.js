
import Vue from 'vue'
import App from '../store_items.vue'
document.addEventListener('DOMContentLoaded', () => {
  const results_chubu = window.results_chubu
  const results_kansai = window.results_kansai
  const results_kanto = window.results_kanto
  const shift_digestion_chubu = window.shift_digestion_chubu
  const shift_digestion_kansai = window.shift_digestion_kansai
  const shift_digestion_kanto = window.shift_digestion_kanto
  const days = ["日", "月", "火", "水", "木", "金", "土"]
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})


