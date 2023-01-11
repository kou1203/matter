window.addEventListener('load', () => {

  const summitGraphChange = document.getElementById('summit-graph-change');
  const commissionGraph = document.getElementById('commission-graph');
  const meteredGraph = document.getElementById('metered-graph');
  const lowVoltageGraph = document.getElementById('low-voltage-graph');
  const commissionAveGraph = document.getElementById('commission-ave-graph');
  const meteredBillingsAveGraph = document.getElementById('metered-billings-ave-graph');
  const totalUseAveGraph = document.getElementById('total-use-ave-graph');

  summitGraphChange.addEventListener("change", function(){
    if(this.value == '手数料'){
      commissionGraph.style.display = "block";
      meteredGraph.style.display = "none";
      lowVoltageGraph.style.display = "none";
      commissionAveGraph.style.display = "none";
      meteredBillingsAveGraph.style.display = "none";
      totalUseAveGraph.style.display = "none";
  }else if(this.value == '従量電灯（件数）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "block";
    lowVoltageGraph.style.display = "none";
    commissionAveGraph.style.display = "none";
    meteredBillingsAveGraph.style.display = "none";
    totalUseAveGraph.style.display = "none";
  }else if(this.value == '低圧電灯（件数）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "none";
    lowVoltageGraph.style.display = "block";
    commissionAveGraph.style.display = "none";
    meteredBillingsAveGraph.style.display = "none";
    totalUseAveGraph.style.display = "none";
  }else if(this.value == '従量電灯手数料（平均）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "none";
    lowVoltageGraph.style.display = "none";
    commissionAveGraph.style.display = "block";
    meteredBillingsAveGraph.style.display = "none";
    totalUseAveGraph.style.display = "none";
  }else if(this.value == '請求額（平均）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "none";
    lowVoltageGraph.style.display = "none";
    commissionAveGraph.style.display = "none";
    meteredBillingsAveGraph.style.display = "block";
    totalUseAveGraph.style.display = "none";
  }else if(this.value == '従量電灯使用量（平均）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "none";
    lowVoltageGraph.style.display = "none";
    commissionAveGraph.style.display = "none";
    meteredBillingsAveGraph.style.display = "none";
    totalUseAveGraph.style.display = "block";
  }
  });
});

{/* <option value="従量電灯手数料（平均）">従量電灯手数料（平均）</option>
<option value="請求額（平均）">請求額（平均）</option>
<option value="従量電灯使用量（平均）">従量電灯使用量（平均）</option> */}