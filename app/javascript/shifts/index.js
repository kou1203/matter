window.addEventListener('load', ()=>{
  const select = document.getElementById('shift-select');
  const checkAll = document.getElementById('check-all');
  const uncheckAll = document.getElementById('uncheck-all');
  const shiftCheck = document.getElementsByName('shift-check');
  let target = [];
  for(let i =0; i<shiftCheck.length; i++){
    let set = "shift-set" + i;
    target[i] = document.getElementById(set);
    // console.log('shift-set'+i)
    console.log(target[i])
  }
  checkAll.onclick = function() {
    for(i = 0; i < shiftCheck.length; i++) {
      shiftCheck[i].checked = true
    }
  }
  uncheckAll.onclick = function() {
    for(i = 0; i < shiftCheck.length; i++) {
      shiftCheck[i].checked = false
    }
  }

  select.onchange = function(){
    for(i = 0; i < shiftCheck.length; i++) {
      if(shiftCheck[i].checked == true) {
        target[i].value = this.value;
        // console.log(target[i].value)
      }
    }
  }
})
