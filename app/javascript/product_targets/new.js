window.addEventListener('turbolinks:load', function(){
  const baseTargetChange = document.getElementById('base-target-change')
  const dateTargetChange = document.getElementById('date-target-change')
  const selectBase = document.getElementById('select-base')
  const selectDate = document.getElementById('select-date')
  target_base = [];
  target_date = [];
  for(let i =0; i < 4; i++){
    let selectBase = "select-base" + i;
    let selectDate = "select-date" + i;
    target_base[i] = document.getElementById(selectBase);
    target_date[i] = document.getElementById(selectDate);
    // console.log(target_base[i].value)
  }
  baseTargetChange.addEventListener('change', function() {
    for(let i =0; i < 4; i++){
      target_base[i].value = this.value;
      // console.log(target_base[i].value)
    }
  })


  dateTargetChange.addEventListener('blur', function() {
    for(let i =0; i < 4; i++){
      target_date[i].value = this.value;
      console.log(target_date[i].value)
    }
  })
})