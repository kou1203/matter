import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("summit-date-progress");
  // 当月
  const month = window.month
  const billings = window.billings
  const billings_chubu = window.billings_chubu
  const billings_kansai = window.billings_kansai
  const billings_kanto = window.billings_kanto
  const billings_kyushu = window.billings_kyushu
  const current_arry = window.current_arry
  const users = window.users
  const users_all = window.users_all
  const users_chubu = window.users_chubu
  const users_kansai = window.users_kansai
  const users_kanto = window.users_kanto
  const users_kyushu = window.users_kyushu

  // 前月
  const billings_prev = window.billings_prev
  const billings_prev_chubu = window.billings_prev_chubu
  const billings_prev_kansai = window.billings_prev_kansai
  const billings_prev_kanto = window.billings_prev_kanto
  const billings_prev_kyushu = window.billings_prev_kyushu
  const prev_arry = window.prev_arry
  
  const month_metered = window.month_metered

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        month: month,
        billings: billings,
        billingsPrev: billings_prev,
        billingsBase: billings_chubu,
        billingsPrevBase: billings_prev_chubu,
        currentItems: users_chubu,
        current_arry: current_arry,
        prev_arry: prev_arry,
        users: users,
        isActive: true,
        isDifActive: true,
        month_metered: month_metered,
        userId: ''
      },
      methods: {
        baseSlct: function(e) {
          this.val = e.target.value
          if (this.val == '中部SS') {
            return this.currentItems = users_chubu, this.billingsBase = billings_chubu, this.billingsPrevBase = billings_prev_chubu
          } else if (this.val == '関西SS') {
            return this.currentItems = users_kansai, this.billingsBase = billings_kansai, this.billingsPrevBase = billings_prev_kansai
          } else if (this.val == '関東SS') {
            return this.currentItems = users_kanto, this.billingsBase = billings_kanto, this.billingsPrevBase = billings_prev_kanto
          } else if (this.val == '九州SS') {
            return this.currentItems = users_kyushu, this.billingsBase = billings_kyushu, this.billingsPrevBase = billings_prev_kyushu
          }  else {
            return this.currentItems = users_all, this.billingsBase = billings, this.billingsPrevBase = billings_prev
          }
        },

        productSlct: function(e) {
          this.productVal = e.target.value
        },

        active: function() {
          this.isActive = !this.isActive;
        },

        difActive: function() {
          this.isDifActive = !this.isDifActive;
        }

      }
      // components: { App }
    });
  }
});