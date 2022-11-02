import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
Vue.use(TurbolinksAdapter)


document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById("slmt_per");

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        btnText: "絞り込み内容表示",
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