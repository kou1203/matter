window.addEventListener('turbolinks:load', function(){
  // 決済
  const slmtPageButton = document.getElementById("slmt-button")
  const slmtPage = document.getElementById("slmt-page")
  // 不備
  const defPageButton = document.getElementById("def-button")
  const defPage = document.getElementById("def-page")
  // 月毎のデータ
  const monthPageButton = document.getElementById("month-button")
  const monthPage = document.getElementById("month-page")


  // 拠点別絞り込み関数
  slmtPageButton.addEventListener('click', function(){
    if (slmtPage.getAttribute("style") == "display:block;") {
      slmtPage.removeAttribute("style", "display:block;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      slmtPage.setAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      slmtPageButton.setAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  defPageButton.addEventListener('click', function(){
    if (defPage.getAttribute("style") == "display:block;") {
      defPage.removeAttribute("style", "display:block;")
      defPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      defPage.setAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      monthPage.removeAttribute("style", "display:block;")
      defPageButton.setAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  monthPageButton.addEventListener('click', function(){
    if (monthPage.getAttribute("style") == "display:block;") {
      monthPage.removeAttribute("style", "display:block;")
      monthPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      monthPage.setAttribute("style", "display:block;")
      slmtPage.removeAttribute("style", "display:block;")
      defPage.removeAttribute("style", "display:block;")
      monthPageButton.setAttribute("style", "background: #74828F;")
      slmtPageButton.removeAttribute("style", "background: #74828F;")
      defPageButton.removeAttribute("style", "background: #74828F;")
    }
  })
})
