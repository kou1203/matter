
import Vue from 'vue'
import App from '../profit_person.vue'
document.addEventListener('DOMContentLoaded', () => {
  const chubu_base = window.chubu_base
  const kansai_base = window.kansai_base
  const kanto_base = window.kanto_base
  const partner_base = window.partner_base
  const femto_base = window.femto_base
  const all_base = window.all_base
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})