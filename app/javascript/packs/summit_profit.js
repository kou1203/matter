
import Vue from 'vue'
import App from '../summit_profit.vue'
document.addEventListener('DOMContentLoaded', () => {
  const chubu_ary = window.chubu_ary
  const kansai_ary = window.kansai_ary
  const kanto_ary = window.kanto_ary
  const partner_ary = window.partner_ary
  const other_ary = window.other_ary
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})