import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("result-cash");
  const result_chubu = window.result_chubu
  const result_kansai = window.result_kansai
  const result_kanto = window.result_kanto
  const result_kyushu = window.result_kyushu
  const result_partner = window.result_partner
  const result_cash_chubu = window.result_cash_chubu
  const result_cash_kansai = window.result_cash_kansai
  const result_cash_kanto = window.result_cash_kanto
  const result_cash_kyushu = window.result_cash_kyushu
  const result_cash_partner = window.result_cash_partner
  const hour_visit_chubu = window.hour_visit_chubu
  const hour_get_chubu = window.hour_get_chubu
  const hour_visit_kansai = window.hour_visit_kansai
  const hour_get_kansai = window.hour_get_kansai
  const hour_visit_kanto = window.hour_visit_kanto
  const hour_get_kanto = window.hour_get_kanto
  const hour_visit_kyushu = window.hour_visit_kyushu
  const hour_get_kyushu = window.hour_get_kyushu
  const hour_visit_partner = window.hour_visit_partner
  const hour_get_partner = window.hour_get_partner

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        shiftItem: result_chubu,
        out: result_cash_chubu,
        hourVisit: hour_visit_chubu,
        hourGet: hour_get_chubu,
        val: "中部SS"
      },
      methods: {
        shiftSlct: function(e) {
          this.val = e.target.value
          if (this.val == "中部SS") {
            return this.shiftItem = result_chubu, this.out = result_cash_chubu, this.hourVisit = hour_visit_chubu, this.hourGet = hour_get_chubu;
          } else if (this.val == "関西SS") {
            return this.shiftItem = result_kansai, this.out = result_cash_kansai, this.hourVisit = hour_visit_kansai, this.hourGet = hour_get_kansai;
          } else if (this.val == "関東SS") {
            return this.shiftItem = result_kanto, this.out = result_cash_kanto, this.hourVisit = hour_visit_kanto, this.hourGet = hour_get_kanto;
          } else if (this.val == "九州SS") {
            return this.shiftItem = result_kyushu , this.out = result_cash_kyushu, this.hourVisit = hour_visit_kyushu, this.hourGet = hour_get_kyushu;
          } else if (this.val == "2次店") {
            return this.shiftItem = result_partner, this.out = result_cash_partner, this.hourVisit = hour_visit_partner, this.hourGet = hour_get_partner;
          } else {}
        }
      }
      // components: { App }
    });
  }
});