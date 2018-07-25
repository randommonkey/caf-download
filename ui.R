
styles <- "

@import url('https://fonts.googleapis.com/css?family=Open+Sans');

/*.shiny-output-error {
  visibility: hidden; 
}*/
  
*:before,
*:after {
  box-sixing: border-box;
  outline: none;
}

body {
  font-family: 'Open Sans', sans-serif;
  display: flex;
  flex-direction: column;
}

.SpaceDat {
  margin-top: 7%;
  margin-bottom: 3%;
  display: flex;
}

.parInf {
 display: grid;
 grid-template-columns: 50% 50%;
}

.InfGen {
  margin-bottom: 3%;
}

.btn-default {
  height: 30px;
  background: transparent;
  border: 1px solid #005186;
  border-radius: 2px;
  margin-left: 3%;
}

.btn-default:hover {
    color: #fff;
    background-color: #005186;
}

button, input, select, textarea {
    margin-left: 3%;
    height: 30px;
    background: transparent;
    border: 1px solid #005186;
    border-radius: 2px;
}

button:hover {
    color: #fff;
    background-color: #005186;
}

.tabStyle {
  overflow-x: auto;
  overflow-y: auto;
  width: 100%;
  height: 403px;
}

.leaflet-container.leaflet-touch-drag.leaflet-touch-zoom {
 background: white !important;
}

.loadmessage {
  position: fixed;
  width: 5%;
  top: 35%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 10000;
}

.bla{
  width: max-content;
color: #000;
}
"


shinyUI(
  fluidPage(
    useShinyjs(),
    conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                     tags$img(src = 'Cargando.gif', class="loadmessage")),
    tags$head(
      includeScript("js/iframeSizer.contentWindow.min.js"),
      tags$script(HTML("$(document).on('click', '.needed', function () {
                                Shiny.onInputChange('last_btn',this.id);
                             });"))),
    inlineCSS(styles),
    uiOutput('infoGen')
  )
)