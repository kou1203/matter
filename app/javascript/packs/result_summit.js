import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("result-summit");
  const result_summit_only = window.result_summit_only
  const result_summit_and_put = window.result_summit_and_put

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        shiftItem: result_summit_only,
        val: "電気"
      },
      methods: {
        shiftSlct: function(e) {
          this.val = e.target.value
          if (this.val == "電気") {
            return this.shiftItem = result_summit_only;
          } else if (this.val == "設置電気") {
            return this.shiftItem = result_summit_and_put;
          } else {}
        }
      }
      // components: { App }
    });
  }
});