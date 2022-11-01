
<template>
  <div id="app">
    <hr>
      <div class="title-form">
        <label class="sub-title">実売内訳</label>
        <select @change="baseSlct" class="base-slcter">
          <option value="全拠点">全拠点</option>
          <option value="中部SS">中部SS</option>
          <option value="関西SS">関西SS</option>
          <option value="関東SS">関東SS</option>
          <option value="2次店">２次店</option>
          <option value="フェムト">フェムト</option>
          <option value="サミット">サミット</option>
          <option value="その他">その他</option>
        </select>
        <label class="base-slct-label">こちらから拠点を選択してください</label>
      </div>
        <table><!-- 拠点情報 -->
          <thead>
            <tr>
              <th class="base-head-th" colspan="4"></th>
              <th class="base-head-th" colspan="3">現状売上</th>
              <th class="base-head-th" colspan="3">終着売上</th>
              <th class="base-head-th" colspan="3">予定シフト</th>
              <th class="base-head-th" colspan="3">消化シフト</th>
              <th class="base-head-th" colspan=""></th>
              <th class="base-head-th" colspan="10">商材別成果になった件数</th>
            </tr>
            <tr>
              <th class="base-th">拠点</th>
              <th class="base-th">ユーザー</th>
              <th class="base-th">役職</th>
              <th class="base-th">キャッシュ1日Ave</th>
              <th class="base-th">新規売上</th>
              <th class="base-th">決済売上</th>
              <th class="base-th">合計売上</th>
              <th class="base-th">新規終着</th>
              <th class="base-th">決済終着</th>
              <th class="base-th">合計終着</th>
              <th class="base-th">合計</th>
              <th class="base-th">新規</th>
              <th class="base-th">決済</th>
              <th class="base-th">消化</th>
              <th class="base-th">新規</th>
              <th class="base-th">決済</th>
              <th class="base-th">残シフト</th>
              <th class="base-th">dメル<br>（審査完了+決済）</th>
              <th class="base-th">dメル<br>（アクセプタンス通過）</th>
              <th class="base-th">dメル<br>（2回目決済）</th>
              <th class="base-th">auPay<br>（アクセプタンス通過）</th>
              <th class="base-th">PayPay<br>（審査通過）</th>
              <th class="base-th">楽天ペイ<br>（審査通過）</th>
              <th class="base-th">AirPay<br>（審査通過）</th>
              <th class="base-th">auステッカー<br>（獲得）</th>
              <th class="base-th">出前館<br>（初回CS締結）</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in baseItems" :key="item" class="body-tr">
              <td class="base-td">{{ item["拠点"] }}</td>
              <td class="base-td">{{ item["名前"] }}</td>
              <td class="base-td">{{ item["役職"] }}</td>
              <td class="base-td">{{ Math.round(item["合計終着"] / item["予定シフト"]).toLocaleString() }}</td>
              <td class="base-td">{{ item["新規現状売上"].toLocaleString() }}</td>
              <td class="base-td">{{ item["決済現状売上"].toLocaleString() }}</td>
              <td class="base-td">{{ item["合計現状売上"].toLocaleString() }}</td>
              <td class="base-td">{{ item["新規終着"].toLocaleString() }}</td>
              <td class="base-td">{{ item["決済終着"].toLocaleString() }}</td>
              <td class="base-td">{{ item["合計終着"].toLocaleString() }}</td>
              <td class="base-td">{{ item["予定シフト"] }}</td>
              <td class="base-td">{{ item["予定新規シフト"] }}</td>
              <td class="base-td">{{ item["予定決済シフト"] }}</td>
              <td class="base-td">{{ item["消化シフト"] }}</td>
              <td class="base-td">{{ item["消化新規シフト"] }}</td>
              <td class="base-td">{{ item["消化決済シフト"] }}</td>
              <td class="base-td">{{ item["予定シフト"] - item["消化シフト"] }}</td>
              <td class="base-td">{{ item["dメル第一成果件数"] }}</td>
              <td class="base-td">{{ item["dメル第二成果件数"] }}</td>
              <td class="base-td">{{ item["dメル第三成果件数"] }}</td>
              <td class="base-td">{{ item["auPay第一成果件数"] }}</td>
              <td class="base-td">{{ item["PayPay第一成果件数"] }}</td>
              <td class="base-td">{{ item["楽天ペイ第一成果件数"] }}</td>
              <td class="base-td">{{ item["AirPay第一成果件数"] }}</td>
              <td class="base-td">{{ item["auステッカー第一成果件数"] }}</td>
              <td class="base-td">{{ item["出前館第一成果件数"] }}</td>
            </tr>
          </tbody>
        </table><!-- /拠点情報 -->
      <hr>
      <div class="base-flex"><!-- 基準値と商材情報 -->
        <div><!-- 基準値 -->
          <div class="title-form">
            <label class="sub-title">基準値</label>
          </div>
          <table>
            <thead>
              <tr>
                <th class="base-th">ユーザー</th>
                <th class="base-th">役職</th>
                <th class="base-th">訪問</th>
                <th class="base-th">応答</th>
                <th class="base-th">応答率</th>
                <th class="base-th">対面</th>
                <th class="base-th">対面率</th>
                <th class="base-th">フル</th>
                <th class="base-th">フル率</th>
                <th class="base-th">成約</th>
                <th class="base-th">成約率</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in baseItems" :key="item" class="body-tr">
                <td class="base-td">{{ item["名前"] }}</td>
                <td class="base-td">{{ item["役職"] }}</td>
                <td class="base-td">{{ item["訪問"] }}</td>
                <td class="base-td">{{ item["応答"] }}</td>
                <td class="base-td">{{ (item["応答"] / item["訪問"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
                <td class="base-td">{{ item["対面"] }}</td>
                <td class="base-td">{{ (item["対面"] / item["応答"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
                <td class="base-td">{{ item["フル"] }}</td>
                <td class="base-td">{{ (item["フル"] / item["対面"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
                <td class="base-td">{{ item["獲得"] }}</td>
                <td class="base-td">{{ (item["獲得"] / item["フル"]).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}</td>
              </tr>
            </tbody>
          </table>
        </div><!-- /基準値 -->
        <div><!-- /商材情報 -->
          <div class="title-form">
            <label class="sub-title">商材</label>
            <select @change="productSlct" class="base-slcter">
              <option value="">商材を選択してください</option>
              <option value="dメル">dメル</option>
              <option value="auPay">auPay</option>
              <option value="PayPay">PayPay</option>
              <option value="楽天ペイ">楽天ペイ</option>
              <option value="AirPay">AirPay</option>
              <option value="出前館">出前館</option>
              <option value="auステッカー">auステッカー</option>
            </select>
            <label class="base-slct-label">こちらから商材を選択してください</label>
          </div>
          <div v-if="productVal == 'dメル'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th"></th>
                  <th class="base-head-th"></th>
                  <th class="base-head-th" colspan="4">現状実売</th>
                  <th class="base-head-th" colspan="4">終着実売</th>
                  <th class="base-head-th" colspan="3">成果になった件数</th>
                </tr>
                <tr>
                  <th class="base-th">ユーザー</th>
                  <th class="base-th">役職</th>
                  <th class="base-th">審査完了+決済</th>
                  <th class="base-th">アクセプタンス</th>
                  <th class="base-th">2回目決済</th>
                  <th class="base-th">合計</th>
                  <th class="base-th">審査完了+決済</th>
                  <th class="base-th">アクセプタンス</th>
                  <th class="base-th">2回目決済</th>
                  <th class="base-th">合計</th>
                  <th class="base-th">審査完了+決済</th>
                  <th class="base-th">アクセプタンス</th>
                  <th class="base-th">2回目決済</th>
                </tr>
                
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["dメル現状売上1"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["dメル現状売上2"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["dメル現状売上3"].toLocaleString() }}</td>
                  <td class="base-td">{{ (item["dメル現状売上1"] + item["dメル現状売上2"] + item["dメル現状売上3"]).toLocaleString()}}</td>
                  <td class="base-td">{{ item["dメル一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["dメル二次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["dメル三次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ (item["dメル一次成果終着"] + item["dメル二次成果終着"] + item["dメル三次成果終着"]).toLocaleString()}}</td>
                  <td class="base-td">{{ item["dメル第一成果件数"] }}</td>
                  <td class="base-td">{{ item["dメル第二成果件数"] }}</td>
                  <td class="base-td">{{ item["dメル第三成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else-if="productVal == 'auPay'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th">ユーザー</th>
                  <th class="base-head-th">役職</th>
                  <th class="base-head-th" colspan="">現状実売</th>
                  <th class="base-head-th" colspan="">終着実売</th>
                  <th class="base-head-th" colspan="">成果になった件数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["auPay現状売上1"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["auPay一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["auPay第一成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else-if="productVal == 'PayPay'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th">ユーザー</th>
                  <th class="base-head-th">役職</th>
                  <th class="base-head-th" colspan="">現状実売</th>
                  <th class="base-head-th" colspan="">終着実売</th>
                  <th class="base-head-th" colspan="">成果になった件数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["PayPay現状売上"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["PayPay一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["PayPay第一成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else-if="productVal == '楽天ペイ'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th">ユーザー</th>
                  <th class="base-head-th">役職</th>
                  <th class="base-head-th" colspan="">現状実売</th>
                  <th class="base-head-th" colspan="">終着実売</th>
                  <th class="base-head-th" colspan="">成果になった件数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["楽天ペイ現状売上"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["楽天ペイ一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["楽天ペイ第一成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else-if="productVal == 'AirPay'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th">ユーザー</th>
                  <th class="base-head-th">役職</th>
                  <th class="base-head-th" colspan="">現状実売</th>
                  <th class="base-head-th" colspan="">終着実売</th>
                  <th class="base-head-th" colspan="">獲得数</th>
                  <th class="base-head-th" colspan="">成果になった件数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["AirPay現状売上"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["AirPay一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["AirPay獲得数"] }}</td>
                  <td class="base-td">{{ item["AirPay第一成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else-if="productVal == 'auステッカー'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th">ユーザー</th>
                  <th class="base-head-th">役職</th>
                  <th class="base-head-th" colspan="">現状実売</th>
                  <th class="base-head-th" colspan="">終着実売</th>
                  <th class="base-head-th" colspan="">成果になった件数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["auステッカー現状売上"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["auステッカー一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["auステッカー第一成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else-if="productVal == '出前館'">
            <table>
              <thead>
                <tr>
                  <th class="base-head-th">ユーザー</th>
                  <th class="base-head-th">役職</th>
                  <th class="base-head-th" colspan="">現状実売</th>
                  <th class="base-head-th" colspan="">終着実売</th>
                  <th class="base-head-th" colspan="">成果になった件数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in baseItems" :key="item" class="body-tr">
                  <td class="base-td">{{item["名前"]}}</td>
                  <td class="base-td">{{item["役職"]}}</td>
                  <td class="base-td">{{ item["出前館現状売上"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["出前館一次成果終着"].toLocaleString() }}</td>
                  <td class="base-td">{{ item["出前館第一成果件数"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else>
          </div>
        </div><!-- /商材情報 -->
      </div><!-- /基準値と商材情報 -->
  </div><!-- /id=app -->
</template>

<script>
export default {
  data: function () {
    return {
      val: '',
      baseItems: all_base,
      productVal: ''
    }
  },
  methods: {
    baseSlct: function(e) {
      this.val = e.target.value
      if (this.val == '中部SS') {
        return this.baseItems = chubu_base
      } else if (this.val == '関西SS') {
        return this.baseItems = kansai_base
      } else if (this.val == '関東SS') {
        return this.baseItems = kanto_base
      } else if (this.val == '2次店') {
        return this.baseItems = partner_base
      } else if (this.val == 'フェムト') {
        return this.baseItems = femto_base
      } else if (this.val == 'サミット') {
        return this.baseItems = summit_base
      } else if (this.val == 'その他') {
        return this.baseItems = retire_base
      } else {
        return this.baseItems = all_base
      }
    },
    productSlct: function(e) {
      this.productVal = e.target.value
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