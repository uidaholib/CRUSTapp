$(document).ready(function() {
  newSlider();
  resizeImg();
  Shiny.onInputChange("tModel", 0);
});

function hoverOn(x){
  if(document.getElementById(x).style.backgroundColor != "rgb(255, 255, 254)"){
    document.getElementById(x).style.backgroundColor = "rgb(255, 255, 255)";
  }

  var temp = document.getElementById(x);
  var imgSrc = temp.childNodes[1].id;

  var source = document.getElementById(imgSrc).src;
  document.getElementById("RTB").innerHTML = source.substring(source.length - 5);
  
  fillRTB(x);
}

$(window).resize(function() {
 resizeImg();
});

function resizeImg(){
  var ww = window.innerWidth;
  var wh = window.innerHeight;
  var imgH = wh * 0.1;
  var imgW = ww * 0.05;

  document.getElementById("a").width = imgW;
  document.getElementById("a").height = imgH;
  document.getElementById("b").width = imgW;
  document.getElementById("b").height = imgH;
  document.getElementById("c").width = imgW;
  document.getElementById("c").height = imgH;
  document.getElementById("d").width = imgW;
  document.getElementById("d").height = imgH;
  document.getElementById("e").width = imgW;
  document.getElementById("e").height = imgH;
  document.getElementById("f").width = imgW;
  document.getElementById("f").height = imgH;
  document.getElementById("g").width = imgW;
  document.getElementById("g").height = imgH;
  document.getElementById("h").width = imgW;
  document.getElementById("h").height = imgH;
  document.getElementById("i").width = imgW;
  document.getElementById("i").height = imgH;
  document.getElementById("j").width = imgW;
  document.getElementById("j").height = imgH;
  document.getElementById("k").width = imgW;
  document.getElementById("k").height = imgH;
  document.getElementById("l").width = imgW;
  document.getElementById("l").height = imgH;
  document.getElementById("m").width = imgW;
  document.getElementById("m").height = imgH;
  document.getElementById("n").width = imgW;
  document.getElementById("n").height = imgH;
  
  if(document.getElementById("middle")){
    document.getElementById("middle").width = imgW * 3 + 2;
    document.getElementById("middle").height = imgH * 3 - 40;
  }
  
  document.getElementById("RTB").style.height =
  document.getElementById("bread").offsetHeight.toString().concat("px");
}

function fillRTB(x){
  var water = document.createElement("img");
  water.src = "../images/water.png";
  water.width = 50;
  water.height = 50;
  
  var spices = document.createElement("img");
  spices.src = "../images/spices.png";
  spices.width = 50;
  spices.height = 50;
  spices.style.position = "relative";
  spices.style.left = "10px";
  
  //spices.style.float = "right";

  document.getElementById("RTB").append(document.createElement("br"));
  document.getElementById("RTB").append(water);
  document.getElementById("RTB").append(spices);
}

function Click(x){
  var source = document.getElementById(x).childNodes[1].src;
  
  document.getElementById(x).classList.remove("ring");
  document.getElementById(x).classList.add("selected");
  if(document.getElementById("centertext").innerHTML == "True Bread"){
    document.getElementById("centertext").innerHTML = "True Bread";
    var elem = document.createElement("img");
    elem.setAttribute("src", source);
    elem.setAttribute("style", "backGround-Color: rgb(255,255,255)");
    elem.setAttribute("id", "middle")
    elem.setAttribute("class", "center-block")
    elem.setAttribute("height", "100");
    elem.setAttribute("width", "100");
    document.getElementById("centerbread").append(elem);
    resizeImg();
  }
  document.getElementById("middle").src = source;
  
  for(i = 0; i < 14; i++){
    if(document.getElementById(i).classList.contains("selected") && i != x){
      document.getElementById(i).classList.remove("selected");
      document.getElementById(i).classList.add("ring");
    }
  }
  
  Shiny.onInputChange("tModel", x);
}

function newSlider(){
  var last = document.getElementById("lastRow");
  var slider = document.createElement("div");
  
  slider.style.height = "20px";
  slider.style.width = "600px";
  slider.setAttribute("id", "slider");
  last.append(slider);
  var temp = document.getElementById("slider");
  
  noUiSlider.create(temp, {
    start: [25, 50, 75],
    connect: [true, true, true, true],
    range: {
      'min': [0],
      'max': [100]
    }
  });
}

function setupfunc(){
  //runs on setup button press, communicates agent inputs to server
  var nRay = 25;
  var nRob = 25;
  var nCara = 25;
  var nNell = 25;
  var values = document.getElementById("slider").noUiSlider.get();
  
  nRay = Math.round((values[0] - 0));
  nRob = Math.round((values[1] - values[0]));
  nCara = Math.round((values[2] - values[1]));
  nNell = Math.round(Math.abs((values[2] - 100)));
  
  Shiny.onInputChange("nRay", nRay)
  Shiny.onInputChange("nRob", nRob)
  Shiny.onInputChange("nCara", nCara)
  Shiny.onInputChange("nNell", nNell)
}

function newSlider(){
  var last = document.getElementById("lastRow");
  var text1 = document.createElement("div");
  
  text1.setAttribute("id", "sliderText");
  
  var slider = document.createElement("div");
  slider.style.height = "20px";
  slider.style.width = "600px";
  slider.setAttribute("id", "slider");
  last.append(slider);
  var temp = document.getElementById("slider");
  
  noUiSlider.create(temp, {
    start: [25, 50, 75],
    connect: [true, true, true, true],
    range: {
      'min': [0],
      'max': [100]
      }
    });
    last.append(text1);
    
    temp.noUiSlider.on("update", function(){
      sliderText();
      });
}

function sliderText(){
  var last = document.getElementById("lastRow");
  var values = document.getElementById("slider").noUiSlider.get();
  var text = document.getElementById("sliderText");
  text.innerHTML = "";
  
  var temp = document.createElement("p");
  
  temp.innerHTML = "Rey: " + Math.round((values[0] - 0)) + " | Rob: " +
  Math.round((values[1] - values[0])) + " | Cara: " +
  Math.round((values[2] - values[1])) + " | Nell: " +
  Math.round(Math.abs((values[2] - 100)));
  
  text.append(temp);
}
