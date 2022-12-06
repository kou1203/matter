
<template>
  <div id="app">
    <hr>
      <div class="title-form">
        <label class="sub-title">内訳</label>
        <select @change="baseSlct" class="base-slcter">
          <option value="中部SS">中部SS</option>
          <option value="関西SS">関西SS</option>
          <option value="関東SS">関東SS</option>
          <option value="2次店">２次店</option>
          <option value="その他">その他</option>
        </select>
        <label class="base-slct-label">こちらから拠点を選択してください</label>
      </div>
        <table><!-- 拠点情報 -->
          <thead>
            <tr>
              <th class="base-head-th" colspan="3"></th>
              <th class="base-head-th" colspan="3">獲得</th>
              <th class="base-head-th" colspan="2">当月</th>
              <th class="base-head-th" colspan="3">前月累計分</th>
              <th class="base-head-th" colspan="4">シフト</th>
            </tr>
            <tr>
              <th class="base-th">拠点</th>
              <th class="base-th">ユーザー</th>
              <th class="base-th">役職</th>
              <th class="base-th">現状獲得数</th>
              <th class="base-th">現状予想売上</th>
              <th class="base-th">1日獲得Ave</th>
              <th class="base-th">終着獲得見込</th>
              <th class="base-th">終着売上見込</th>
              <th class="base-th">切換完了済み</th>
              <th class="base-th">平均単価</th>
              <th class="base-th">当月売上</th>
              <th class="base-th">予定シフト</th>
              <th class="base-th">消化シフト</th>
              <th class="base-th">残シフト</th>
              <th class="base-th">帯同シフト</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in baseItems" :key="item" class="body-tr">
                <td class="base-td">{{ item["拠点"] }}</td>
                <td class="base-td">{{ item["名前"] }}</td>
                <td class="base-td">{{ item["役職"] }}</td>
                <td class="base-td">{{ item["従量獲得"] }}</td>
                <td class="base-td"></td>
                <td class="base-td">{{ item["従量獲得Ave"] }}</td>
                <td class="base-td">{{ item["従量獲得終着見込"] }}</td>
                <td class="base-td">{{  }}</td>
                <td class="base-td">{{ item["切換完了済み"] }}</td>
                <td class="base-td">{{ item["first数"] }}</td>
                <td class="base-td">{{ item["last数"] }}</td>
                <td class="base-td">{{ item["予定シフト"] }}</td>
                <td class="base-td">{{ item["消化シフト"] }}</td>
                <td class="base-td">{{ item["予定シフト"] - item["消化シフト"] }}</td>
                <td class="base-td">{{ item["帯同シフト"] }}</td>
            </tr>
            <tr>
              <td class="base-td"></td>
              <td class="base-td">合計</td>
              <td class="base-td"></td>
              <td class="base-td">{{ 
                baseItems.reduce((sum, i) => sum + i["従量獲得"], 0)
              }}</td>
              <td class="base-td"></td>
              <td class="base-td">{{
                Math.round(
                  baseItems.reduce((sum, i) => sum + i["従量獲得"], 0) / 
                baseItems.reduce((sum, i) => sum + i["消化シフト"], 0) * 100
                ) / 100
              }}</td>
              <td class="base-td">{{
                Math.round(
                  baseItems.reduce((sum, i) => sum + i["従量獲得"], 0) / 
                baseItems.reduce((sum, i) => sum + i["消化シフト"], 0) * 
                baseItems.reduce((sum, i) => sum + i["予定シフト"], 0)
                )
              }}</td>
              <td class="base-td">{{  }}</td>
              <td class="base-td">{{  }}</td>
              <td class="base-td">{{  }}</td>
              <td class="base-td">{{  }}</td>
              <td class="base-td">{{ baseItems.reduce((sum, i) => sum + i["予定シフト"], 0) }}</td>
              <td class="base-td">{{ baseItems.reduce((sum, i) => sum + i["消化シフト"], 0) }}</td>
              <td class="base-td">{{ 
                baseItems.reduce((sum, i) => sum + i["予定シフト"], 0) -
                baseItems.reduce((sum, i) => sum + i["消化シフト"], 0) 
              }}</td>
              <td class="base-td">{{ baseItems.reduce((sum, i) => sum + i["帯同シフト"], 0) }}</td>
            </tr>
          </tbody>
        </table><!-- /拠点情報 -->
      <hr>
        <div><!-- /商材情報 -->
        </div><!-- /商材情報 -->
        <div><!-- 基準値 -->
          <div class="title-form">
            <label class="sub-title">基準値</label>
          </div>
          <table>
            <thead>
              <tr>
                <th class="base-head-th" colspan="11"></th>
              </tr>
              <tr>
                <th class="base-th">ユーザー</th>
                <th class="base-th">役職</th>
                <th class="base-th">訪問</th>
                <th class="base-th">対面</th>
                <th class="base-th">対面率</th>
                <th class="base-th">フル①</th>
                <th class="base-th">フル①率</th>
                <th class="base-th">フル②</th>
                <th class="base-th">フル②率</th>
                <th class="base-th">成約</th>
                <th class="base-th">成約率</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in baseItems" :key="item" class="body-tr">
                <td class="base-td">{{ item["名前"] }}</td>
                <td class="base-td">{{ item["役職"] }}</td>
                <td class="base-td">{{ item["訪問"] }}</td>
                <td class="base-td">{{ item["対面"] }}</td>
                <td class="base-td">{{ (item["対面"] / item["訪問"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
                <td class="base-td">{{ item["フル①"] }}</td>
                <td class="base-td">{{ (item["フル①"] / item["対面"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
                <td class="base-td">{{ item["フル②"] }}</td>
                <td class="base-td">{{ (item["フル②"] / item["フル①"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
                <td class="base-td">{{ item["成約"] }}</td>
                <td class="base-td">{{ (item["成約"] / item["フル②"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
              </tr>
            </tbody>
          </table>
        </div><!-- /基準値 -->
  </div><!-- /id=app -->
</template>

<script>
export default {
  data: function () {
    return {
      val: '',
      baseItems: chubu_ary,
      productVal: ''
    }
  },
  methods: {
    baseSlct: function(e) {
      this.val = e.target.value
      if (this.val == '中部SS') {
        return this.baseItems = chubu_ary
      } else if (this.val == '関西SS') {
        return this.baseItems = kansai_ary
      } else if (this.val == '関東SS') {
        return this.baseItems = kanto_ary
      } else if (this.val == '2次店') {
        return this.baseItems = partner_ary
      } else if (this.val == 'その他') {
        return this.baseItems = other_ary
      } else {}
    }
  }
}
</script>

<style scoped>
  table {
    margin: 20px;
    border: 2px solid gray;
  }
  .base-head-th {
    font-size: 6px;
    border-left: 1px solid rgb(70, 69, 69);
    background:  #74828F;
    color: white;
    padding: 3px;
  }
  .base-th {
    font-size: 6px;
    border: 1px solid gray;
    text-align: center;
    color: white;
    background:  #c4c2c2;
    padding: 3px;
  }
  .base-td {
    font-size: 6px;
    border: 1px solid gray;
    padding: 3px;
  }
  .body-tr:nth-child(even) {
  background: #ede5e5;
  }
  .base-slcter {
    margin-left: 20px;
    padding: 3px;
    color: rgb(75, 73, 73);
  }
  .base-slct-label {
    color: rgb(75, 73, 73);
  }
  .base-flex {
    display: flex;
  }
  .sub-title {
    margin-left: 20px;
    font-weight: bold;
    color: rgb(75, 73, 73);
  }
  .title-form {
    height: 20px;
  }
</style>