import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("result-cash");
  // 合計
  const sum_total_visit_ave = window.sum_total_visit_ave
  const sum_visit_ave = window.sum_visit_ave
  const sum_interview_ave = window.sum_interview_ave
  const sum_full_talk_ave = window.sum_full_talk_ave
  const sum_full_talk2_ave = window.sum_full_talk2_ave
  const sum_get_ave = window.sum_get_ave
  // 前半
  const sum_total_visit_f_ave = window.sum_total_visit_f_ave
  const sum_visit_f_ave = window.sum_visit_f_ave
  const sum_interview_f_ave = window.sum_interview_f_ave
  const sum_full_talk_f_ave = window.sum_full_talk_f_ave
  const sum_full_talk2_f_ave = window.sum_full_talk2_f_ave
  const sum_get_f_ave = window.sum_get_f_ave
  // 後半
  const sum_total_visit_l_ave = window.sum_total_visit_l_ave
  const sum_visit_l_ave = window.sum_visit_l_ave
  const sum_interview_l_ave = window.sum_interview_l_ave
  const sum_full_talk_l_ave = window.sum_full_talk_l_ave
  const sum_full_talk2_l_ave = window.sum_full_talk2_l_ave
  const sum_get_l_ave = window.sum_get_l_ave

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
  const chubu_len = window.chubu_len
  const kansai_len = window.kansai_len
  const kanto_len = window.kanto_len
  const kyushu_len = window.kyushu_len
  const partner_len = window.partner_len

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        shiftItem: result_chubu,
        out: result_cash_chubu,
        hourVisit: hour_visit_chubu,
        user_len: chubu_len,
        hourGet: hour_get_chubu,
        val: "中部SS",
        sum_total_visit_ave: sum_total_visit_ave,
        sum_visit_ave: sum_visit_ave,
        sum_interview_ave: sum_interview_ave,
        sum_full_talk_ave: sum_full_talk_ave,
        sum_full_talk2_ave: sum_full_talk2_ave,
        sum_get_ave: sum_get_ave,
        sum_total_visit_f_ave: sum_total_visit_f_ave,
        sum_visit_f_ave: sum_visit_f_ave,
        sum_interview_f_ave: sum_interview_f_ave,
        sum_full_talk_f_ave: sum_full_talk_f_ave,
        sum_full_talk2_f_ave: sum_full_talk2_f_ave,
        sum_get_f_ave: sum_get_f_ave,
        sum_total_visit_l_ave: sum_total_visit_l_ave,
        sum_visit_l_ave: sum_visit_l_ave,
        sum_interview_l_ave: sum_interview_l_ave,
        sum_full_talk_l_ave: sum_full_talk_l_ave,
        sum_full_talk2_l_ave: sum_full_talk2_l_ave,
        sum_get_l_ave: sum_get_l_ave
      },
      methods: {
        shiftSlct: function(e) {
          this.val = e.target.value
          if (this.val == "中部SS") {
            return this.shiftItem = result_chubu, this.out = result_cash_chubu, this.hourVisit = hour_visit_chubu, this.hourGet = hour_get_chubu, this.user_len = chubu_len, this.sum_total_visit_ave = sum_total_visit_ave, this.sum_visit_ave = sum_visit_ave, this.sum_interview_ave = sum_interview_ave, this.sum_full_talk_ave = sum_full_talk_ave, this.sum_full_talk2_ave = sum_full_talk2_ave, this.sum_get_ave = sum_get_ave, this.sum_total_visit_f_ave = sum_total_visit_f_ave, this.sum_visit_f_ave = sum_visit_f_ave, this.sum_interview_f_ave = sum_interview_f_ave, this.sum_full_talk_f_ave = sum_full_talk_f_ave, this.sum_full_talk2_f_ave = sum_full_talk2_f_ave, this.sum_get_f_ave = sum_get_f_ave, this.sum_total_visit_l_ave = sum_total_visit_l_ave, this.sum_visit_l_ave = sum_visit_l_ave, this.sum_interview_l_ave = sum_interview_l_ave, this.sum_full_talk_l_ave = sum_full_talk_l_ave, this.sum_full_talk2_l_ave = sum_full_talk2_l_ave, this.sum_get_l_ave = sum_get_l_ave;
          } else if (this.val == "関西SS") {
            return this.shiftItem = result_kansai, this.out = result_cash_kansai, this.hourVisit = hour_visit_kansai, this.hourGet = hour_get_kansai, this.user_len = kansai_len, this.sum_total_visit_ave = sum_total_visit_ave, this.sum_visit_ave = sum_visit_ave, this.sum_interview_ave = sum_interview_ave, this.sum_full_talk_ave = sum_full_talk_ave, this.sum_full_talk2_ave = sum_full_talk2_ave, this.sum_get_ave = sum_get_ave, this.sum_total_visit_f_ave = sum_total_visit_f_ave, this.sum_visit_f_ave = sum_visit_f_ave, this.sum_interview_f_ave = sum_interview_f_ave, this.sum_full_talk_f_ave = sum_full_talk_f_ave, this.sum_full_talk2_f_ave = sum_full_talk2_f_ave, this.sum_get_f_ave = sum_get_f_ave, this.sum_total_visit_l_ave = sum_total_visit_l_ave, this.sum_visit_l_ave = sum_visit_l_ave, this.sum_interview_l_ave = sum_interview_l_ave, this.sum_full_talk_l_ave = sum_full_talk_l_ave, this.sum_full_talk2_l_ave = sum_full_talk2_l_ave, this.sum_get_l_ave = sum_get_l_ave;
          } else if (this.val == "関東SS") {
            return this.shiftItem = result_kanto, this.out = result_cash_kanto, this.hourVisit = hour_visit_kanto, this.hourGet = hour_get_kanto, this.user_len = kanto_len, this.sum_total_visit_ave = sum_total_visit_ave, this.sum_visit_ave = sum_visit_ave, this.sum_interview_ave = sum_interview_ave, this.sum_full_talk_ave = sum_full_talk_ave, this.sum_full_talk2_ave = sum_full_talk2_ave, this.sum_get_ave = sum_get_ave, this.sum_total_visit_f_ave = sum_total_visit_f_ave, this.sum_visit_f_ave = sum_visit_f_ave, this.sum_interview_f_ave = sum_interview_f_ave, this.sum_full_talk_f_ave = sum_full_talk_f_ave, this.sum_full_talk2_f_ave = sum_full_talk2_f_ave, this.sum_get_f_ave = sum_get_f_ave, this.sum_total_visit_l_ave = sum_total_visit_l_ave, this.sum_visit_l_ave = sum_visit_l_ave, this.sum_interview_l_ave = sum_interview_l_ave, this.sum_full_talk_l_ave = sum_full_talk_l_ave, this.sum_full_talk2_l_ave = sum_full_talk2_l_ave, this.sum_get_l_ave = sum_get_l_ave;
          } else if (this.val == "九州SS") {
            return this.shiftItem = result_kyushu , this.out = result_cash_kyushu, this.hourVisit = hour_visit_kyushu, this.hourGet = hour_get_kyushu, this.user_len = kyushu_len, this.sum_total_visit_ave = sum_total_visit_ave, this.sum_visit_ave = sum_visit_ave, this.sum_interview_ave = sum_interview_ave, this.sum_full_talk_ave = sum_full_talk_ave, this.sum_full_talk2_ave = sum_full_talk2_ave, this.sum_get_ave = sum_get_ave, this.sum_total_visit_f_ave = sum_total_visit_f_ave, this.sum_visit_f_ave = sum_visit_f_ave, this.sum_interview_f_ave = sum_interview_f_ave, this.sum_full_talk_f_ave = sum_full_talk_f_ave, this.sum_full_talk2_f_ave = sum_full_talk2_f_ave, this.sum_get_f_ave = sum_get_f_ave, this.sum_total_visit_l_ave = sum_total_visit_l_ave, this.sum_visit_l_ave = sum_visit_l_ave, this.sum_interview_l_ave = sum_interview_l_ave, this.sum_full_talk_l_ave = sum_full_talk_l_ave, this.sum_full_talk2_l_ave = sum_full_talk2_l_ave, this.sum_get_l_ave = sum_get_l_ave;
          } else if (this.val == "2次店") {
            return this.shiftItem = result_partner, this.out = result_cash_partner, this.hourVisit = hour_visit_partner, this.hourGet = hour_get_partner, this.user_len = partner_len, this.sum_total_visit_ave = sum_total_visit_ave, this.sum_visit_ave = sum_visit_ave, this.sum_interview_ave = sum_interview_ave, this.sum_full_talk_ave = sum_full_talk_ave, this.sum_full_talk2_ave = sum_full_talk2_ave, this.sum_get_ave = sum_get_ave, this.sum_total_visit_f_ave = sum_total_visit_f_ave, this.sum_visit_f_ave = sum_visit_f_ave, this.sum_interview_f_ave = sum_interview_f_ave, this.sum_full_talk_f_ave = sum_full_talk_f_ave, this.sum_full_talk2_f_ave = sum_full_talk2_f_ave, this.sum_get_f_ave = sum_get_f_ave, this.sum_total_visit_l_ave = sum_total_visit_l_ave, this.sum_visit_l_ave = sum_visit_l_ave, this.sum_interview_l_ave = sum_interview_l_ave, this.sum_full_talk_l_ave = sum_full_talk_l_ave, this.sum_full_talk2_l_ave = sum_full_talk2_l_ave, this.sum_get_l_ave = sum_get_l_ave;
          } else {}
        }
      }
      // components: { App }
    });
  }
});