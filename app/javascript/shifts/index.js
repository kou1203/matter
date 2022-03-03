window.addEventListener('load', ()=>{
  const select = document.getElementById('shift-select');
  
  select.onchange = function(){
    console.log(this.value);
    document.getElementById('shift-set').value = this.value;
    
  }
})
