<template>
  <div id="app">
    <!-- 拠点基準値 -->
      <h2>
        拠点基準値
        <!-- 内容切り替えるボタン -->
        <select @change="itemsChange" class="standard-val" >
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
              <th rowspan="2" class="total-th">喫茶・カフェ</th>
              <th class="total-th">訪問</th>
              <td class="total-td">{{ cafeVisitSum }}</td>
              <td class="total-td"></td>
              <td class="total-td">-</td>
            </tr>
            <tr>
              <th class="total-th">成約</th>
              <td class="total-td">{{  }}</td>
              <td class="total-td"></td>
              <td class="total-td"></td>
            </tr>
            <tr>
              <th rowspan="5" class="total-th">合計</th>
              <th class="total-th">訪問</th>
              <td class="total-td">{{  }}</td>
              <td class="total-td">{{  }}</td>
              <td class="total-td">{{  }}</td>
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
      items: results_chubu,
      // shift_digestion: shift_digestion_chubu
    }
  },
  methods: {
    itemsChange: function(e) {
      this.val = e.target.value
      if (this.val == '中部SS') {
        return this.items = results_chubu
      } else if(this.val == '関西SS') {
        return this.items = results_kansai
      } else {
        return this.items = results_kanto
      }
    }
  },
  computed: {
    cafeVisitSum(){
      const cafe_visit = this.items
      return cafe_visit.reduce(function(sum, items){return sum + items.cafe_visit;}, 0)
    }
  }
}
</script>

<style scoped>

</style>