window.addEventListener('load', () => {

  const graphChange = document.getElementById('graph-change');
  const finGraph = document.getElementById('fin-graph');
  const currentGraph = document.getElementById('current-graph');
  const currentPieGraph1 = document.getElementById('current-pie-graph1');
  const currentPieGraph2 = document.getElementById('current-pie-graph2');
  const result1Graph = document.getElementById('result1-graph');
  const result2Graph = document.getElementById('result2-graph');
  const result3Graph = document.getElementById('result3-graph');


  graphChange.addEventListener("change", function(){
    if(this.value == '終着売上推移'){
      finGraph.style.display = "block";
      currentGraph.style.display = "none";
      currentPieGraph1.style.display = "none";
      currentPieGraph2.style.display = "none";
      result1Graph.style.display = "none";
      result2Graph.style.display = "none";
      result3Graph.style.display = "none";
    }else if(this.value == '現状実売推移'){
        finGraph.style.display = "none";
        currentGraph.style.display = "block";
        currentPieGraph1.style.display = "block";
        currentPieGraph2.style.display = "block";
        result1Graph.style.display = "none";
        result2Graph.style.display = "none";
        result3Graph.style.display = "none";
    }else if(this.value == '一次成果推移'){
      finGraph.style.display = "none";
      currentGraph.style.display = "none";
      result1Graph.style.display = "block";
      result2Graph.style.display = "none";
      result3Graph.style.display = "none";
    }else if(this.value == '二次成果推移'){
      finGraph.style.display = "none";
      currentGraph.style.display = "none";
      result1Graph.style.display = "none";
      result2Graph.style.display = "block";
      result3Graph.style.display = "none";
    }else if(this.value == '三次成果推移'){
      finGraph.style.display = "none";
      currentGraph.style.display = "none";
      result1Graph.style.display = "none";
      result2Graph.style.display = "none";
      result3Graph.style.display = "block";
    }
  });
});