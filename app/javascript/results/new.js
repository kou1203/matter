window.addEventListener('turbolinks:load', function(){
  // メモ
  const memoButton = document.getElementById("memo-button")
  const memoPage = document.getElementById("memo-page")
  const shiftSlct = document.getElementById("shift-slct")
  const basicForm = document.getElementById("basic-form")
  const cashLabel1 = document.getElementById("cash-label1")
  const cashLabel2 = document.getElementById("cash-label2")
  const cashLabel3 = document.getElementById("cash-label3")
  const cashLabel4 = document.getElementById("cash-label4")
  const cashVal1 = document.getElementById("cash-val1")
  const cashVal2 = document.getElementById("cash-val2")
  const cashForm1 = document.getElementById("cash-form1")
  const summitLabel1 = document.getElementById("summit-label1")
  const summitLabel2 = document.getElementById("summit-label2")
  const summitLabel3 = document.getElementById("summit-label3")
  const summitLabel4 = document.getElementById("summit-label4")
  const summitVal1 = document.getElementById("summit-val1")
  const summitVal2 = document.getElementById("summit-val2")
  const summitForm1 = document.getElementById("summit-form1")

  // シフト
  shiftSlct.addEventListener('change',function(){
    console.log(this.value)
    if(this.value == "キャッシュレス新規") {
      basicForm.style.display = "block";
      // キャッシュレス
      cashLabel1.style.display = "inline";
      cashLabel2.style.display = "inline";
      cashLabel3.style.display = "inline";
      cashLabel4.style.display = "inline";
      cashVal1.style.display = "inline";
      cashVal2.style.display = "inline";
      cashForm1.style.display = "block";
      // サミット
      summitLabel1.style.display = "none";
      summitLabel2.style.display = "none";
      summitLabel3.style.display = "none";
      summitLabel4.style.display = "none";
      summitVal1.style.display = "none";
      summitVal2.style.display = "none";
      summitForm1.style.display = "none";
    }else if(this.value == "サミット") {
      basicForm.style.display = "block";
      // キャッシュレス
      cashLabel1.style.display = "none";
      cashLabel2.style.display = "none";
      cashLabel3.style.display = "none";
      cashLabel4.style.display = "none";
      cashVal1.style.display = "none";
      cashVal2.style.display = "none";
      cashForm1.style.display = "none";
      // サミット
      summitLabel1.style.display = "inline";
      summitLabel2.style.display = "inline";
      summitLabel3.style.display = "inline";
      summitLabel4.style.display = "inline";
      summitVal1.style.display = "inline";
      summitVal2.style.display = "inline";
      summitForm1.style.display = "inline";
    }else {
      basicForm.style.display = "none";
    }
  })
  // 商材別
  memoButton.addEventListener('click', function(){
    if (memoPage.getAttribute("style") == "display:block;") {
      memoPage.removeAttribute("style", "display:block;")
      memoButton.removeAttribute("style", "background: #74828F;")
    } else {
      memoPage.setAttribute("style", "display:block;")
      memoButton.setAttribute("style", "background: #74828F;")
    }
  })

})
