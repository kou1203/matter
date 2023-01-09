window.addEventListener('load', () => {

  const summitGraphChange = document.getElementById('summit-graph-change');
  const commissionGraph = document.getElementById('commission-graph');
  const meteredGraph = document.getElementById('metered-graph');
  const lowVoltageGraph = document.getElementById('low-voltage-graph');

  summitGraphChange.addEventListener("change", function(){
    if(this.value == '手数料'){
      commissionGraph.style.display = "block";
      meteredGraph.style.display = "none";
      lowVoltageGraph.style.display = "none";
  }else if(this.value == '従量電灯（件数）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "block";
    lowVoltageGraph.style.display = "none";
  }else if(this.value == '低圧電灯（件数）'){
    commissionGraph.style.display = "none";
    meteredGraph.style.display = "none";
    lowVoltageGraph.style.display = "block";
  }
  });
});