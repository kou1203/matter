import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("store-show");

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        btnText: "自社情報",
        isActive: false
      },
      methods: {
        active: function () {
            this.isActive = !this.isActive;
        }
      }
      // components: { App }
    });
  }
});