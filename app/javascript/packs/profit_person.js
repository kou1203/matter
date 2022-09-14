import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("profit_person");

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        baseSlct: ''
      },
      methods: {
        selected: function () {
            this.selectedItem = this.items[this.selectedBase];
        },
      }
      // components: { App }
    });
  }
});