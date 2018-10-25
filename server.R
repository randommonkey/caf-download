confFile <- read_csv('data/dicData.csv')

shinyServer(function(input, output, session){

  output$infoGen <- renderUI({
    
   
    map(1:length(unique(confFile$archivo)), function(z){
      list(
      div(class = "parInf",
      div(class = "InfGen",
      HTML(paste0(
        '<span style ="font-size: 19px; color: #005186;">', confFile$nombre[z], '</span><br/>',
        confFile$detalle[z], '<br/>',
        '<b>Fuente: </b>',confFile$fuente[z] 
      ))),
      #tags$button(id = confFile$archivo[z], 'Descarga los datos', class="bla", type = "button"),
      div(class = "SpaceDat",
      tags$button(id = confFile$archivo[z], onclick="displayResult()", class="needed fa fa-search", type = "button", 'Vista Previa'),
      HTML(paste0('<a target="_blank" href=', paste0('http://data.datos-transporte.org.s3.amazonaws.com/download/',confFile$archivo[z], '.zip'), '>
                  <button type="button" class="bla">
                    <span class="glyphicon glyphicon-cloud-download"></span> Descarga los datos
                  </button>
       </a>'
      )
    )
      )
      )
      )
    })
    
  })
  
  # lapply(1:length(confFile$archivo), function(z) {
  #   input[[confFile$archivo[z]]]})
  
  # observeEvent(
  #   input$accidentes,{
  #   a("www.google.com",target="_blank")
  # })
  
  # 
  # observe({
  #   lapply(1:length(confFile$archivo), function(z) {
  #     output[[confFile$archivo[z]]] <- downloadHandler(
  #       paste0(confFile$archivo[z],'.zip'),
  #       content = function(file) {
  #       if (confFile$extension[z] == 'csv') {
  #         if (confFile$diccionario[z] == 'si') {
  #             dir.create(tmp <- tempfile())
  #             df <- read_csv(paste0('data/allData/',confFile$archivo[z],'_data.csv'))
  #             dic <- read_csv(paste0('data/allData/',confFile$archivo[z],'_dic.csv'))
  #             write_csv(df, file.path(tmp, paste0(confFile$archivo[z],".csv")), na = '')
  #             export(df, file.path(tmp, paste0(confFile$archivo[z], ".xlsx")))
  #             write_csv(dic, file.path(tmp, paste0(confFile$archivo[z],"_dic.csv")), na = '')
  #           } else {
  #             dir.create(tmp <- tempfile())
  #             df <- read_csv(paste0('data/allData/',confFile$archivo[z],'_data.csv'))
  #             export(df, file.path(tmp, paste0(confFile$archivo[z], ".xlsx")))
  #             write_csv(df, file.path(tmp, paste0(confFile$archivo[z], ".csv")), na = '')
  #           }
  #       }
  #     if (confFile$extension[z] == 'json') {
  #         dir.create(tmp <- tempfile())
  #         json_file <- jsonlite::read_json(paste0('data/allData/', confFile$archivo[z],'_data.json'))
  #         json_file <- rjson::toJSON(json_file)
  #         writeLines(json_file, file.path(tmp, paste0(confFile$archivo[z], ".json")))
  #     }
  #     if (confFile$extension[z] == 'N-A') {
  #       if (confFile$diccionario[z] == 'si') {
  #         dir.create(tmp <- tempfile())
  #         df <- read_csv(paste0('data/allData/',confFile$archivo[z],'_data.csv'))
  #         dic <- read_csv(paste0('data/allData/',confFile$archivo[z],'_dic.csv'))
  #         json_file <- jsonlite::read_json(paste0('data/allData/', confFile$archivo[z],'_data.json'))
  #         json_file <- rjson::toJSON(json_file)
  #         writeLines(json_file, file.path(tmp, "data_filter.json"))
  #         write_csv(df, file.path(tmp, "data_filter.csv"), na = '')
  #         export(df, file.path(tmp, "data_filter.xlsx"))
  #         write_csv(dic, file.path(tmp, "dic_filter.csv"), na = '')
  #       } else {
  #         dir.create(tmp <- tempfile())
  #         df <- read_csv(paste0('data/allData/',confFile$archivo[z],'_data.csv'))
  #         json_file <- jsonlite::read_json(paste0('data/allData/', confFile$archivo[z],'_data.json'))
  #         json_file <- rjson::toJSON(json_file)
  #         writeLines(json_file, file.path(tmp, paste0(confFile$archivo[z], ".json")))
  #         export(df, file.path(tmp, paste0(confFile$archivo[z], ".xlsx")))
  #         write_csv(df, file.path(tmp, paste0(confFile$archivo[z], ".csv")), na = '')
  #       }
  #     }
  #         zip(file, tmp)
  #       }
  #     )   
  #   })
  # })
  
  
  output$showData <- renderPrint({#renderTable({
    d_ind <- input$last_btn
    # d_ind <- gsub('[A-z]', '', d_ind)
    # d_info <- read_csv(paste0('data/data', d_ind, '.csv'))
    # d_info
    d_ind
  })  
  
  
  output$tablaFile <- renderTable({
    d_ind <- input$last_btn
    if (is.null(d_ind)) return()
    d_inf <- read_csv(paste0('data/allData/', d_ind,'_data.csv'))
    head(d_inf, 20)
  })
  
  output$mapFile <- renderLeaflet({
    
    d_ind <- input$last_btn
    if (is.null(d_ind)) return()
    leaflet(topojson_read(paste0("data/allData/", d_ind, "_data.json"))) %>%
      addProviderTiles(providers$BasemapAT.basemap) %>%
      setView(lng = -74.09729, lat = 4.530901, zoom = 10)  %>% 
      addPolygons(weight = 1.4,
                  color = "#000",
                  opacity = 1,
                  fillColor = "transparent") 
  })
  
  output$resultado <- renderUI({
    d_ind <- input$last_btn
    if (is.null(d_ind)) return()
    
    if (confFile$vista[confFile$archivo == d_ind] == 'tabla') {
      div(class = 'tabStyle', tableOutput('tablaFile'))
    } else {
      leafletOutput('mapFile')
    }
    
  })
  
  
  observeEvent(input$last_btn, {
    showModal(modalDialog(
      title = '',
      easyClose = TRUE,
      footer = modalButton("Cerrar"), 
      uiOutput('resultado'), 
      br()
    ))
  })

  
})
