import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
// Vue.use(TurbolinksAdapter)


document.addEventListener('DOMContentLoaded', () => {
  chubu_slmt = window.chubu_slmt
  kansai_slmt = window.kansai_slmt
  kanto_slmt = window.kanto_slmt
  kyushu_slmt = window.kyushu_slmt
  const element = document.getElementById("slmt_per");

  if (element != null) {
    const vueapp = new Vue({
      el: element,
      data: {
        isActive: false,
        baseItems: chubu_slmt,
      },
      methods: {
        baseSlct: function(e) {
          this.val = e.target.value
          if (this.val == 'chubu-slct') {
            return this.baseItems = chubu_slmt
          } else if (this.val == 'kansai-slct') {
            return this.baseItems = kansai_slmt
          } else if (this.val == 'kanto-slct') {
            return this.baseItems = kanto_slmt
          } else if (this.val == 'kyushu-slct') {
            return this.baseItems = kyushu_slmt
          }
        },
      }
      // components: { App }
    });
  }
});