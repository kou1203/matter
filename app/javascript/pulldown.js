window.addEventListener('turbolinks:load', function(){
  // サイドバーの変数
  const pullDownButton1 = document.getElementById("lists1")
  const pullDownParents1 = document.getElementById("pull-down1")
  const pullDownButton2 = document.getElementById("lists2")
  const pullDownParents2 = document.getElementById("pull-down2")
  const pullDownButton3 = document.getElementById("lists3")
  const pullDownParents3 = document.getElementById("pull-down3")
  const pullDownButton4 = document.getElementById("lists4")
  const pullDownParents4 = document.getElementById("pull-down4")
  // 拠点別の絞り込み用変数
  const chubuPageButton = document.getElementById("chubu-button")
  const kansaiPageButton = document.getElementById("kansai-button")
  const kantoPageButton = document.getElementById("kanto-button")
  const chubuPage = document.getElementById("chubu-page")
  const kansaiPage = document.getElementById("kansai-page")
  const kantoPage = document.getElementById("kanto-page")



  // サイドバーの関数
  pullDownButton1.addEventListener('click', function(){
    if (pullDownParents1.getAttribute("style") == "display:block;") {
      pullDownParents1.removeAttribute("style", "display:block;")
    } else {
      pullDownParents1.setAttribute("style", "display:block;")
    }
  })

  pullDownButton2.addEventListener('click', function(){
    if (pullDownParents2.getAttribute("style") == "display:block;") {
      pullDownParents2.removeAttribute("style", "display:block;")
    } else {
      pullDownParents2.setAttribute("style", "display:block;")
    }
  })

  pullDownButton3.addEventListener('click', function(){
    if (pullDownParents3.getAttribute("style") == "display:block;") {
      pullDownParents3.removeAttribute("style", "display:block;")
    } else {
      pullDownParents3.setAttribute("style", "display:block;")
    }
  })
  
  pullDownButton4.addEventListener('click', function(){
    if (pullDownParents4.getAttribute("style") == "display:block;") {
      pullDownParents4.removeAttribute("style", "display:block;")
    } else {
      pullDownParents4.setAttribute("style", "display:block;")
    }
  })


  // 拠点別絞り込み関数
  chubuPageButton.addEventListener('click', function(){
    if (chubuPage.getAttribute("style") == "display:block;") {
      chubuPage.removeAttribute("style", "display:block;")
      chubuPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      chubuPage.setAttribute("style", "display:block;")
      kansaiPage.removeAttribute("style", "display:block;")
      kantoPage.removeAttribute("style", "display:block;")
      chubuPageButton.setAttribute("style", "background: #74828F;")
      kansaiPageButton.removeAttribute("style", "background: #74828F;")
      kantoPageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  kansaiPageButton.addEventListener('click', function(){
    if (kansaiPage.getAttribute("style") == "display:block;") {
      kansaiPage.removeAttribute("style", "display:block;")
      kansaiPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      kansaiPage.setAttribute("style", "display:block;")
      chubuPage.removeAttribute("style", "display:block;")
      kantoPage.removeAttribute("style", "display:block;")
      kansaiPageButton.setAttribute("style", "background: #74828F;")
      chubuPageButton.removeAttribute("style", "background: #74828F;")
      kantoPageButton.removeAttribute("style", "background: #74828F;")
    }
  })
  kantoPageButton.addEventListener('click', function(){
    if (kantoPage.getAttribute("style") == "display:block;") {
      kantoPage.removeAttribute("style", "display:block;")
      kantoPageButton.removeAttribute("style", "background: #74828F;")
    } else {
      kantoPage.setAttribute("style", "display:block;")
      chubuPage.removeAttribute("style", "display:block;")
      kansaiPage.removeAttribute("style", "display:block;")
      kantoPageButton.setAttribute("style", "background: #74828F;")
      chubuPageButton.removeAttribute("style", "background: #74828F;")
      kansaiPageButton.removeAttribute("style", "background: #74828F;")
    }
  })


  

})