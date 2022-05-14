window.addEventListener('turbolinks:load', function(){
  // 商材別
  const cashButton = document.getElementById("cash-button")
  const cashPage = document.getElementById("cash-page")
  // 早見
  const chartButton = document.getElementById("chart-button")
  const chartPage = document.getElementById("chart-page")
  // 個別
  const showButton = document.getElementById("show-button")
  const showPage = document.getElementById("show-page")

  // 商材別
  cashButton.addEventListener('click', function(){
    if (cashPage.getAttribute("style") == "display:block;") {
      cashPage.removeAttribute("style", "display:block;")
      cashButton.removeAttribute("style", "background: #74828F;")
    } else {
      cashPage.setAttribute("style", "display:block;")
      cashButton.setAttribute("style", "background: #74828F;")
    }
  })
  
  // 早見
  chartButton.addEventListener('click', function(){
    if (chartPage.getAttribute("style") == "display:block;") {
      chartPage.removeAttribute("style", "display:block;")
      chartButton.removeAttribute("style", "background: #74828F;")
    } else {
      chartPage.setAttribute("style", "display:block;")
      chartButton.setAttribute("style", "background: #74828F;")
    }
  })
  
  // 個別
  showButton.addEventListener('click', function(){
    if (showPage.getAttribute("style") == "display:block;") {
      showPage.removeAttribute("style", "display:block;")
      showButton.removeAttribute("style", "background: #74828F;")
    } else {
      showPage.setAttribute("style", "display:block;")
      showButton.setAttribute("style", "background: #74828F;")
    }
  })
})
