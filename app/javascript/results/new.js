window.addEventListener('turbolinks:load', function(){
  // メモ
  const memoButton = document.getElementById("memo-button")
  const memoPage = document.getElementById("memo-page")

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
