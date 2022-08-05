window.addEventListener('turbolinks:load', function(){

  
  // 基準値
  const standardValChange = document.getElementById('standard-val-change');
  const chubuStandardForm = document.getElementById('chubu-standard-form');
  const kansaiStandardForm = document.getElementById('kansai-standard-form');
  const kantoStandardForm = document.getElementById('kanto-standard-form');
  // 店舗別基準値
  const storeValChange = document.getElementById('store-val-change');
  const chubuStoreForm = document.getElementById('chubu-store-form');
  const kansaiStoreForm = document.getElementById('kansai-store-form');
  const kantoStoreForm = document.getElementById('kanto-store-form');
  // 切り返し
  const outValChange = document.getElementById('out-val-change');
  const chubuOutForm = document.getElementById('chubu-out-form');
  const kansaiOutForm = document.getElementById('kansai-out-form');
  const kantoOutForm = document.getElementById('kanto-out-form');
  // 時間別基準値
  const timesValChange = document.getElementById('times-val-change');
  const chubuTimesForm = document.getElementById('chubu-times-form');
  const kansaiTimesForm = document.getElementById('kansai-times-form');
  const kantoTimesForm = document.getElementById('kanto-times-form');


  // 基準値
  standardValChange.addEventListener("change", function(){
    if(this.value == 'chubu-slct'){
      console.log(this.value);
      chubuStandardForm.style.display = "block";
      kansaiStandardForm.style.display = "none";
      kantoStandardForm.style.display = "none";
  }else if(this.value == 'kansai-slct'){
      console.log(this.value);
      chubuStandardForm.style.display = "none";
      kansaiStandardForm.style.display = "block";
      kantoStandardForm.style.display = "none";
  }else if(this.value == 'kanto-slct'){
      console.log(this.value);
      chubuStandardForm.style.display = "none";
      kansaiStandardForm.style.display = "none";
      kantoStandardForm.style.display = "block";
  }
  });

  // 店舗別基準値
  storeValChange.addEventListener("change", function(){
    if(this.value == 'store-chubu-slct'){
      console.log(this.value);
      chubuStoreForm.style.display = "block";
      kansaiStoreForm.style.display = "none";
      kantoStoreForm.style.display = "none";
  }else if(this.value == 'store-kansai-slct'){
      console.log(this.value);
      chubuStoreForm.style.display = "none";
      kansaiStoreForm.style.display = "block";
      kantoStoreForm.style.display = "none";
  }else if(this.value == 'store-kanto-slct'){
      console.log(this.value);
      chubuStoreForm.style.display = "none";
      kansaiStoreForm.style.display = "none";
      kantoStoreForm.style.display = "block";
  }
  });

  // 切り返し基準値
  outValChange.addEventListener("change", function(){
    if(this.value == 'out-chubu-slct'){
      console.log(this.value);
      chubuOutForm.style.display = "block";
      kansaiOutForm.style.display = "none";
      kantoOutForm.style.display = "none";
  }else if(this.value == 'out-kansai-slct'){
      console.log(this.value);
      chubuOutForm.style.display = "none";
      kansaiOutForm.style.display = "block";
      kantoOutForm.style.display = "none";
  }else if(this.value == 'out-kanto-slct'){
      console.log(this.value);
      chubuOutForm.style.display = "none";
      kansaiOutForm.style.display = "none";
      kantoOutForm.style.display = "block";
  }
  });

  // 時間別基準値
  timesValChange.addEventListener("change", function(){
    if(this.value == 'times-chubu-slct'){
      console.log(this.value);
      chubuTimesForm.style.display = "block";
      kansaiTimesForm.style.display = "none";
      kantoTimesForm.style.display = "none";
  }else if(this.value == 'times-kansai-slct'){
      console.log(this.value);
      chubuTimesForm.style.display = "none";
      kansaiTimesForm.style.display = "block";
      kantoTimesForm.style.display = "none";
  }else if(this.value == 'times-kanto-slct'){
      console.log(this.value);
      chubuTimesForm.style.display = "none";
      kansaiTimesForm.style.display = "none";
      kantoTimesForm.style.display = "block";
  }
  });

  // standardValChange
  // 決済
  const slmtPageButton = document.getElementById("slmt-button")
  const slmtPage = document.getElementById("slmt-page")
  // 不備
  const defPageButton = document.getElementById("def-button")
  const defPage = document.getElementById("def-page")
  // 月毎のデータ
  const monthPageButton = document.getElementById("month-button")
  const monthPage = document.getElementById("month-page")
  const resultPageButton = document.getElementById("result-button")
  const resultPage = document.getElementById("result-page")
  const valuationPageButton = document.getElementById("valuation-button")
  const valuationPage = document.getElementById("valuation-page")
  const outcomePageButton = document.getElementById("outcome-button")
  const outcomePage = document.getElementById("outcome-page")
  // マイページボタンの切り替え
  slmtPageButton.addEventListener('click', function(){
    if (slmtPage.getAttribute("style") == "display:block;") {
      slmtPage.removeAttribute("style", "display:block;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      slmtPage.setAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      resultPage.removeAttribute("style", "display:block;")
      valuationPage.removeAttribute("style", "display:block;")
      outcomePage.removeAttribute("style", "display:block;")
      slmtPageButton.setAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
      resultPageButton.removeAttribute("style", "background: #74828F;")
      valuationPageButton.removeAttribute("style", "background: #74828F;")
      outcomePageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  defPageButton.addEventListener('click', function(){
    if (defPage.getAttribute("style") == "display:block;") {
      defPage.removeAttribute("style", "display:block;")
      defPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      defPage.setAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      resultPage.removeAttribute("style", "display:block;")
      valuationPage.removeAttribute("style", "display:block;")
      outcomePage.removeAttribute("style", "display:block;")
      defPageButton.setAttribute("style", "background: #74828F;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      resultPageButton.removeAttribute("style", "background: #74828F;")
      valuationPageButton.removeAttribute("style", "background: #74828F;")
      outcomePageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  monthPageButton.addEventListener('click', function(){
    if (monthPage.getAttribute("style") == "display:block;") {
      monthPage.removeAttribute("style", "display:block;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      monthPage.setAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      resultPage.removeAttribute("style", "display:block;")
      valuationPage.removeAttribute("style", "display:block;")
      outcomePage.removeAttribute("style", "display:block;")
      monthPageButton.setAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
      resultPageButton.removeAttribute("style", "background: #74828F;")
      valuationPageButton.removeAttribute("style", "background: #74828F;")
      outcomePageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  resultPageButton.addEventListener('click', function(){
    if (resultPage.getAttribute("style") == "display:block;") {
      resultPage.removeAttribute("style", "display:block;")
      resultPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      resultPage.setAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      valuationPage.removeAttribute("style", "display:block;")
      outcomePage.removeAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      resultPageButton.setAttribute("style", "background: #74828F;")
      valuationPageButton.removeAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
      outcomePageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  valuationPageButton.addEventListener('click', function(){
    if (valuationPage.getAttribute("style") == "display:block;") {
      valuationPage.removeAttribute("style", "display:block;")
      valuationPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      valuationPage.setAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      resultPage.removeAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      outcomePage.removeAttribute("style", "display:block;")
      valuationPageButton.setAttribute("style", "background: #74828F;")
      outcomePageButton.setAttribute("style", "background: #74828F;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      resultPageButton.removeAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
      outcomePageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  outcomePageButton.addEventListener('click', function(){
    if (outcomePage.getAttribute("style") == "display:block;") {
      outcomePage.removeAttribute("style", "display:block;")
      outcomePageButton.removeAttribute("style", "background: #74828F;")
    } else {
      outcomePage.setAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      resultPage.removeAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      valuationPage.removeAttribute("style", "display:block;")
      outcomePageButton.setAttribute("style", "background: #74828F;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      resultPageButton.removeAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
      valuationPageButton.removeAttribute("style", "background: #74828F;")
    }


    standard.onchange = function() {
      console.log(this.value);

    }

    
  })

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
