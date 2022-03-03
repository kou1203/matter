window.addEventListener('load', () => {
  const priceDmerInput = document.getElementById('slmt-dmer');
  const priceAupayInput = document.getElementById('slmt-aupay');
  const priceDmerSlmt = document.getElementById('dmer-slmt-price');
  const priceAupaySlmt = document.getElementById('aupay-slmt-price');
  const priceSum = document.getElementById('new-sum');
  priceDmerInput.addEventListener('input', () => {
    const inputDmerValue = priceDmerInput.value;
    const inputAupayValue = priceAupayInput.value;
    const inputDmerSlmt = priceDmerSlmt.value;
    const inputAupaySlmt = priceAupaySlmt.value;
    const inputSum = priceSum.value;
    const slmtSum = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputAupaySlmt * 0.01 * inputAupayValue);
    // console.log(slmtSum)
    const profitDom = document.getElementById('slmt-profit');
    profitDom.innerHTML = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputAupaySlmt * 0.01 * inputAupayValue).toLocaleString();
    const sumProfit = document.getElementById('sum-profit');
    sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum));
  })
  priceAupayInput.addEventListener('input', () => {
    const inputDmerValue = priceDmerInput.value;
    const inputAupayValue = priceAupayInput.value;
    const inputDmerSlmt = priceDmerSlmt.value;
    const inputAupaySlmt = priceAupaySlmt.value;
    const inputSum = priceSum.value;
    const slmtSum = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputAupaySlmt * 0.01 * inputAupayValue);
    console.log(slmtSum)
    const profitDom = document.getElementById('slmt-profit');
    profitDom.innerHTML = Math.floor(inputDmerSlmt * 0.01 * inputDmerValue + inputAupaySlmt * 0.01 * inputAupayValue).toLocaleString();
    const sumProfit = document.getElementById('sum-profit');
    sumProfit.innerHTML = Math.floor(eval(inputSum) + eval(slmtSum));
  })
})