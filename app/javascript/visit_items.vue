<template>
  <div id="app">
    <!-- 拠点基準値 -->
      <h2>
        拠点基準値
        <!-- 内容切り替えるボタン -->
        <select @change="visitItemsChange" class="standard-val" >
          <option value="中部SS">中部SS</option>
          <option value="関西SS">関西SS</option>
          <option value="関東SS">関東SS</option>
        </select>
        <!-- 内容切り替えるボタン -->
      </h2>
      <!-- 中部 -->
      <p>{{ val }}</p>
        <table class="total-tb">
          <thead>
            <tr>
              <th class="total-th">項目</th>
              <th class="total-th">内訳</th>
              <th class="total-th">合計</th>
              <th class="total-th">平均</th>
              <th class="total-th">比率</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th rowspan="5" class="total-th">合計</th>
              <th class="total-th">訪問</th>
              <td class="total-td">{{ visit_items.length }}</td>
              <td class="total-td">{{ firstVisitSum }}</td>
              <td class="total-td">{{ firstVisitSum / 2 }}</td>
            </tr>
          </tbody>
        </table>
      <!-- 中部 -->
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      val: '中部SS',
      visit_items: visit_items_chubu
    }
  },
  methods: {
    visitItemsChange: function(e) {
      this.val = e.target.value
      if (this.val == '中部SS') {
        return this.visit_items = visit_items_chubu
      } else if(this.val == '関西SS') {
        return this.visit_items = visit_items_kansai
      } else {
        return this.visit_items = visit_items_kanto
      }
    }
  },
  computed: {
    firstVisitSum(){
      const visit_items = this.visit_items
      return visit_items.reduce(function(sum, items){return sum + items.first_visit;}, 0)
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
  color:red;
}
</style>