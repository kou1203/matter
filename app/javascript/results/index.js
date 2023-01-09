window.addEventListener('load', () => {

  const valChange = document.getElementById('base-val-change');
  const chubuForm = document.getElementById('chubu-form');
  const kansaiForm = document.getElementById('kansai-form');
  const kantoForm = document.getElementById('kanto-form');

  // 基準値
  valChange.addEventListener("change", function(){
    if(this.value == 'chubu-slct'){
      console.log(this.value);
      chubuForm.style.display = "block";
      kansaiForm.style.display = "none";
      kantoForm.style.display = "none";
  }else if(this.value == 'kansai-slct'){
      console.log(this.value);
      chubuForm.style.display = "none";
      kansaiForm.style.display = "block";
      kantoForm.style.display = "none";
  }else if(this.value == 'kanto-slct'){
      console.log(this.value);
      chubuForm.style.display = "none";
      kansaiForm.style.display = "none";
      kantoForm.style.display = "block";
  }else {

  }
  });

  // 決済率（％）を取得
    const priceDmerInput = document.getElementById('slmt-dmer');
    const priceDmer2ndInput = document.getElementById('slmt-dmer2nd');
    const priceAupayInput = document.getElementById('slmt-aupay');

  // 売上を取得
    const priceDmerSlmt = document.getElementById('dmer-slmt-price');
    const priceDmer2ndSlmt = document.getElementById('pias-slmt2nd-price');
    const priceAupaySlmt = document.getElementById('aupay-slmt-price');
    const priceSum = document.getElementById('new-sum');

  // 目標売上
    const newGoal = document.getElementById('new-goal')
    const slmtGoal = document.getElementById('slmt-goal')
    const newSum = document.getElementById('new-sum-now')
    const slmtSum = document.getElementById('slmt-sum-now')
    const newNeed = document.getElementById('new-need')
    const slmtNeed = document.getElementById('slmt-need')
    const newShift = document.getElementById('new-shift')
    const slmtShift = document.getElementById('slmt-shift')
    // 新規目標売上を入力時に発火
    newGoal.addEventListener('input', () => {
      const newGoalVal = newGoal.value;
      const slmtGoalVal = slmtGoal.value;
      const newSumVal = newSum.value;
      const newShiftVal = newShift.value;
      const sumGoal = document.getElementById('sum-goal')
      sumGoal.innerHTML = Math.floor(eval(newGoalVal) + eval(slmtGoalVal)).toLocaleString();
      newNeed.innerHTML = Math.floor((newGoalVal - newSumVal) / newShiftVal).toLocaleString();

    })
    // 決済目標売上を入力時に発火
    slmtGoal.addEventListener('input', () => {
      const newGoalVal = newGoal.value;
      const slmtGoalVal = slmtGoal.value;
      const slmtSumVal = slmtSum.value;
      const slmtShiftVal = slmtShift.value;
      const sumGoal = document.getElementById('sum-goal')
      sumGoal.innerHTML = Math.floor(eval(newGoalVal) + eval(slmtGoalVal)).toLocaleString();
      slmtNeed.innerHTML = Math.floor((slmtGoalVal - slmtSumVal) / slmtShiftVal).toLocaleString();
    })




  // dメル決済率入力時に発火
    priceDmerInput.addEventListener('input', () => {
      const inputDmerValue = priceDmerInput.value;
      const inputDmer2ndValue = priceDmer2ndInput.value;
      const inputAupayValue = priceAupayInput.value;
      const inputDmerSlmt = priceDmerSlmt.value;
      const inputDmer2ndSlmt = priceDmer2ndSlmt.value;
      const inputAupaySlmt = priceAupaySlmt.value;
      const inputSum = priceSum.value;

      const slmtSum = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputDmer2ndSlmt * 0.01 * inputDmer2ndValue + inputAupaySlmt * 0.01 * inputAupayValue );
      console.log(slmtSum)
      const profitDom = document.getElementById('slmt-profit');
      profitDom.innerHTML = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputDmer2ndSlmt * 0.01 * inputDmer2ndValue  + inputAupaySlmt * 0.01 * inputAupayValue).toLocaleString();
      const sumProfit = document.getElementById('sum-profit');
      sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum));
    })

    priceDmer2ndInput.addEventListener('input', () => {
      const inputDmerValue = priceDmerInput.value;
      const inputDmer2ndValue = priceDmer2ndInput.value;
      const inputAupayValue = priceAupayInput.value;
      const inputDmerSlmt = priceDmerSlmt.value;
      const inputDmer2ndSlmt = priceDmer2ndSlmt.value;
      const inputAupaySlmt = priceAupaySlmt.value;
      const inputSum = priceSum.value;

      const slmtSum = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputDmer2ndSlmt * 0.01 * inputDmer2ndValue + inputAupaySlmt * 0.01 * inputAupayValue );
      console.log(slmtSum)
      const profitDom = document.getElementById('slmt-profit');
      profitDom.innerHTML = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputDmer2ndSlmt * 0.01 * inputDmer2ndValue  + inputAupaySlmt * 0.01 * inputAupayValue).toLocaleString();
      const sumProfit = document.getElementById('sum-profit');
      sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum)).toLocaleString();
    })

    priceAupayInput.addEventListener('input', () => {
      const inputDmerValue = priceDmerInput.value;
      const inputDmer2ndValue = priceDmer2ndInput.value;
      const inputAupayValue = priceAupayInput.value;
      const inputDmerSlmt = priceDmerSlmt.value;
      const inputDmer2ndSlmt = priceDmer2ndSlmt.value;
      const inputAupaySlmt = priceAupaySlmt.value;
      const inputSum = priceSum.value;

      const slmtSum = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputDmer2ndSlmt * 0.01 * inputDmer2ndValue + inputAupaySlmt * 0.01 * inputAupayValue );
      console.log(slmtSum)
      const profitDom = document.getElementById('slmt-profit');
      profitDom.innerHTML = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputDmer2ndSlmt * 0.01 * inputDmer2ndValue  + inputAupaySlmt * 0.01 * inputAupayValue).toLocaleString();
      const sumProfit = document.getElementById('sum-profit');
      sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum)).toLocaleString();
    })
})