import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("dmer-progress");
  const date_group = window.date_group
  const create_group = window.create_group

  const profit_price1 = window.profit_price1
  const profit_price2 = window.profit_price2
  const profit_price3 = window.profit_price3
  const current_arry = window.current_arry
  const comparison_arry = window.comparison_arry

  const current_progress = window.current_progress
  const current_data_chubu = window.current_data_chubu
  const current_data_kansai = window.current_data_kansai
  const current_data_kanto = window.current_data_kanto
  const current_data_kyushu = window.current_data_kyushu
  const current_data_partner = window.current_data_partner
  const current_data_femto = window.current_data_femto
  const current_data_summit = window.current_data_summit
  const current_data_retire = window.current_data_retire

  const comparison = window.comparison
  const comparison_data_chubu = window.comparison_data_chubu
  const comparison_data_kansai = window.comparison_data_kansai
  const comparison_data_kanto = window.comparison_data_kanto
  const comparison_data_kyushu = window.comparison_data_kyushu
  const comparison_data_partner = window.comparison_data_partner
  const comparison_data_femto = window.comparison_data_femto
  const comparison_data_summit = window.comparison_data_summit
  const comparison_data_retire = window.comparison_data_retire
  const users = window.users
  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        profit_price1: profit_price1,
        profit_price2: profit_price2,
        profit_price3: profit_price3,
        dateGroup: date_group,
        createGroup: create_group,
        currentItems: current_data_chubu,
        comparisonItems: comparison_data_chubu,
        current_arry: current_arry,
        users: users,
        isActive: true,
        isDifActive: true
      },
      methods: {
        baseSlct: function(e) {
          this.val = e.target.value
          if (this.val == '中部SS') {
            return this.currentItems = current_data_chubu, this.comparisonItems = comparison_data_chubu
          } else if (this.val == '関西SS') {
            return this.currentItems = current_data_kansai, this.comparisonItems = comparison_data_kansai
          } else if (this.val == '関東SS') {
            return this.currentItems = current_data_kanto, this.comparisonItems = comparison_data_kanto
          } else if (this.val == '九州SS') {
            return this.currentItems = current_data_kyushu, this.comparisonItems = comparison_data_kyushu
          } else if (this.val == '2次店') {
            return this.currentItems = current_data_partner, this.comparisonItems = comparison_data_partner
          } else if (this.val == 'フェムト') {
            return this.currentItems = current_data_femto, this.comparisonItems = comparison_data_femto
          } else if (this.val == 'サミット') {
            return this.currentItems = current_data_summit, this.comparisonItems = comparison_data_summit
          } else if (this.val == 'その他') {
            return this.currentItems = current_data_retire, this.comparisonItems = comparison_data_retire
          } else {
          }
        },
        graphSlct: function(e) {

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