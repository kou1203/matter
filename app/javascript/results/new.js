window.addEventListener('load', () => {
  // 決済率（％）を取得
  const priceDmerInput = document.getElementById('slmt-dmer');
  const priceDmer2ndInput = document.getElementById('slmt-dmer2nd');
  const priceAupayInput = document.getElementById('slmt-aupay');

  // 売上を取得
  const priceDmerSlmt = document.getElementById('dmer-slmt-price');
  const priceDmer2ndSlmt = document.getElementById('pias-slmt2nd-price');
  const priceAupaySlmt = document.getElementById('aupay-slmt-price');
  const priceSum = document.getElementById('new-sum');

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
    sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum));
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
    sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum));
  })
})