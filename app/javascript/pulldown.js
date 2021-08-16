window.addEventListener('turbolinks:load', function(){
  const pullDownButton1 = document.getElementById("lists1")
  const pullDownParents1 = document.getElementById("pull-down1")
  const pullDownButton2 = document.getElementById("lists2")
  const pullDownParents2 = document.getElementById("pull-down2")
  const pullDownButton3 = document.getElementById("lists3")
  const pullDownParents3 = document.getElementById("pull-down3")

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
})