import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// import App from '../search.vue'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("dmer-progress");
  const date_group = window.date_group
  const create_group = window.create_group
  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        dateGroup: date_group,
        createGroup: create_group,
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