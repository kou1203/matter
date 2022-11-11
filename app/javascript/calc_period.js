window.addEventListener('turbolinks:load', function(){
  const name = document.getElementById('name')
  const category = document.getElementById('category')
  const price = document.getElementById('price')
  const bonus1Len = document.getElementById('bonus1-len')
  const bonus2Len = document.getElementById('bonus2-len')
  const bonus1Price = document.getElementById('bonus1-price')
  const bonus2Price = document.getElementById('bonus2-price')
  const thisMonthPer = document.getElementById('this_month_per')
  const prevMonthPer = document.getElementById('prev_month_per')
  const formCheckBtn = document.getElementById('form-check-btn')
  // 獲得期間
  const today = new Date()
  const startDateMonth = document.getElementById('start-date-month')
  const startDateMonthVal = document.getElementById('start-date-month-val')
  const startDateDay = document.getElementById('start-date-day')
  const startDateDayVal = document.getElementById('start-date-day-val')
  const endDateMonth = document.getElementById('end-date-month')
  const endDateMonthVal = document.getElementById('end-date-month-val')
  const endDateDay = document.getElementById('end-date-day')
  const endDateDayVal = document.getElementById('end-date-day-val')
  // 締め日
  const closingDateMonth = document.getElementById('closing-date-month')
  const closingDateMonthVal = document.getElementById('closing-date-month-val')
  const closingDateDay = document.getElementById('closing-date-day')
  const closingDateDayVal = document.getElementById('closing-date-day-val')
  // 名前
  name.addEventListener('change', function(){
    if (name.value != '') {name.style.backgroundColor = '#ffffff';}
  })
  category.addEventListener('change', function(){
    if (category.value != '') {category.style.backgroundColor = '#ffffff';}
  })
  thisMonthPer.addEventListener('change', function(){
    if (thisMonthPer.value != '') {thisMonthPer.style.backgroundColor = '#ffffff';}
  })
  prevMonthPer.addEventListener('change', function(){
    if (prevMonthPer.value != '') {prevMonthPer.style.backgroundColor = '#ffffff';}
  })
  price.addEventListener('change', function(){
    if (price.value != '') {price.style.backgroundColor = '#ffffff';}
  })
  bonus1Len.addEventListener('change', function(){
    if (bonus1Len.value != '') {bonus1Len.style.backgroundColor = '#ffffff';}
  })
  bonus1Price.addEventListener('change', function(){
    if (bonus1Price.value != '') {bonus1Price.style.backgroundColor = '#ffffff';}
  })
  bonus2Len.addEventListener('change', function(){
    if (bonus2Len.value != '') {bonus2Len.style.backgroundColor = '#ffffff';}
  })
  bonus2Price.addEventListener('change', function(){
    if (bonus2Price.value != '') {bonus2Price.style.backgroundColor = '#ffffff';}
  })
  // 獲得期間（始）
  startDateMonth.addEventListener('change', function(){
    if (startDateMonth.value == -1) {
      startDateMonth.style.backgroundColor = '#ffffff';
      (startDateMonthVal.innerHTML = today.getMonth()+ "月") ;
    } else if (startDateMonth.value == 0) {
      startDateMonth.style.backgroundColor = '#ffffff';
      (startDateMonthVal.innerHTML = today.getMonth() + 1+ "月") ;
    } else if (startDateMonth.value == 1) {
      startDateMonth.style.backgroundColor = '#ffffff';
      (startDateMonthVal.innerHTML = today.getMonth() + 2+ "月");
    } else if (startDateMonth.value == '') {
      startDateMonth.style.backgroundColor = '#ff0000';
      startDateMonthVal.innerHTML = '';
    }
  })

  startDateDay.addEventListener('input', function(){
    if (this.value == 0) {
      startDateDay.style.backgroundColor = '#ffffff';
      (startDateDayVal.innerHTML = "末日〜");
    } else {
      startDateDay.style.backgroundColor = '#ffffff';
      (startDateDayVal.innerHTML = this.value  + "日〜");
    }
  })
  // 獲得期間（終）
  endDateMonth.addEventListener('change', function(){
    if (endDateMonth.value == -1) {
      endDateMonth.style.backgroundColor = '#ffffff';
      (endDateMonthVal.innerHTML = today.getMonth()+ "月") ;
    } else if (endDateMonth.value == 0) {
      endDateMonth.style.backgroundColor = '#ffffff';
      (endDateMonthVal.innerHTML = today.getMonth() + 1+ "月") ;
    } else if (endDateMonth.value == 1) {
      endDateMonth.style.backgroundColor = '#ffffff';
      (endDateMonthVal.innerHTML = today.getMonth() + 2+ "月");
    } else {
      endDateMonth.style.backgroundColor = '#ff0000';
      endDateMonthVal.innerHTML = '';
    }
  })

  endDateDay.addEventListener('input', function(){
    if (this.value == 0) {
      endDateDay.style.backgroundColor = '#ffffff';
      (endDateDayVal.innerHTML = "末日");
    } else {
      endDateDay.style.backgroundColor = '#ffffff';
      (endDateDayVal.innerHTML = this.value  + "日");
    }
  })

  // 締め日
  closingDateMonth.addEventListener('change', function(){
    if (closingDateMonth.value == -1) {
      closingDateMonth.style.backgroundColor = '#ffffff';
      (closingDateMonthVal.innerHTML = today.getMonth()+ "月") ;
    } else if (closingDateMonth.value == 0) {
      closingDateMonth.style.backgroundColor = '#ffffff';
      (closingDateMonthVal.innerHTML = today.getMonth() + 1+ "月") ;
    } else if (closingDateMonth.value == 1) {
      closingDateMonth.style.backgroundColor = '#ffffff';
      (closingDateMonthVal.innerHTML = today.getMonth() + 2+ "月");
    } else {
      closingDateMonthVal.innerHTML = '';
    }
  })

  closingDateDay.addEventListener('input', function(){
    if (this.value == 0) {
      closingDateDay.style.backgroundColor = '#ffffff';
      (closingDateDayVal.innerHTML = "末日");
    } else {
      closingDateDay.style.backgroundColor = '#ffffff';
      (closingDateDayVal.innerHTML = this.value  + "日");
    }
  })

  formCheckBtn.addEventListener('click', function(){
    if (!name.value) {
      alert('商材名の入力がないため登録ができません。');
    } else if (!category.value) {
      alert('売上区分の入力がないため登録ができません。');
    } else if (!startDateMonth.value || !startDateDay.value || !endDateMonth.value || !endDateDay.value) {
      alert('獲得期間で入力されていない項目があります。確認してください。');
    } else if (!closingDateMonth.value || !closingDateDay.value) {
      alert('締め日で入力されていない項目があります。確認してください。');
    } else if (!thisMonthPer.value) {
      alert('当月成果率(獲得期間内)の入力がないため0%で登録します。');
    } else if (!prevMonthPer.value) {
      alert('過去月成果率(獲得期間前)の入力がないため0%で登録します。');
    }
  })

})