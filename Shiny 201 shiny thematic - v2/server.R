# server

function(input, output,session) {

################################################################################
  
  #Mostrar year
  output$text_y <- renderText({ paste("A nivel nacional, en el año ",input$year_m) })
  
  # Datos anuales con filtro estal
  df_shape_y <- reactive({
    df_shape_y <- df_shape %>% filter(years == input$year_m & ENTIDAD %in% input$state_m) 
    
  })
  
  # Datos anuales
  df_shape_y_t <- reactive({
      df_shape_y_t <- df_shape %>% filter(years == input$year_m) 
      
    })
  
  # Datos totales
  df_shape_t <- reactive({
    df_shape_t <- df_shape %>%
      filter(years == input$year_m & ENTIDAD %in% input$state_m) %>%
      mutate(valor_10mil = value/10000)
    
  })
  
################################################################################
    output$mp3_leaflet <- renderLeaflet({
      
      
      #Escala de color
      palnumeric <- colorNumeric("magma", domain = df_shape_y()$value)
      
      #Popup
      popup <- paste0(
        "<b>","Estado: ",   "</b>",   as.character(df_shape_y()$ENTIDAD) ,        "<br>",                     
        "<b>", "Capital: ",        "</b>",   as.character(df_shape_y()$CAPITAL)   ,      "<br>",                   
        "<b>", "Número de casos: ",           "</b>",   round(df_shape_y()$value,3) ,      "<br>")
      
      #Mapa (-117.12776, 14.5388286402, -86.811982388, 32.72083)
      mp <- leaflet(df_shape_y(),
                    options = leafletOptions(
                      zoomControl = T, 
                      dragging = T,
                      minZoom = 4, 
                      maxZoom = 10, 
                      attributionControl = FALSE)) %>%
        addProviderTiles("CartoDB.PositronNoLabels") %>% # Añadir el fondo
        # Funcion para agregar poligonos
        addPolygons(color = "#444444" ,
                    weight = 1, 
                    smoothFactor = 0.5,
                    opacity = 1.0,
                    fillOpacity = 0.5,
                    fillColor = ~palnumeric(df_shape_y()$value),    # Color de llenado
                    layerId = ~df_shape_y()$CVE_EDO,                  
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE), 
                    label = ~df_shape_y()$ENTIDAD ,                                  
                    labelOptions = labelOptions(direction = "auto"),
                    popup = popup ) %>%                                       
        setMaxBounds(lng1 =-117.12776,
                     lat1 = 14.5388286402,
                     lng2 = -86.811982388,
                     lat2 = 32.72083)         %>%
        addLegend(position = "bottomleft", pal = palnumeric, values = ~df_shape_y()$value,
                  title = "Número de casos")
      mp
  }) 

################################################################################
    
    output$gr3_plotly <- renderPlotly({
      
      gr3 <- ggplot(df_shape_t(), aes(x=reorder(ENTIDAD, valor_10mil),y=valor_10mil, fill=valor_10mil,
                                    text = paste(
                                      "Estado: ", ENTIDAD,
                                      "\nAño: ", years,
                                      "\nNúm. de casos: ", valor_10mil*10000),
                                    )
                    ) + 
        geom_bar(stat="identity") +
        xlab("") +
        ylab("") +
        ggtitle(" ") + 
        coord_flip() + 
        scale_fill_viridis_c(option = "magma",name = "10,000 \ncasos") +
        theme(
          panel.background = element_rect(fill='transparent'),
          plot.background = element_rect(fill='transparent', color=NA),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.background = element_rect(fill='transparent'),
          legend.box.background = element_rect(fill='transparent')
        )
        # scale_fill_viridis_c(option = "magma",name = "Delitos \n(1000 casos)")
        #labs(fill='Estados') +
        # theme_classic() #+
        #scale_fill_gdocs()
      gr3 <- ggplotly(gr3,tooltip = "text") %>% 
        layout(showlegend = F) #
      gr3 
    }) 

################################################################################
    
    output$text_box_1 <- renderText({ paste("El total de casos fueron: ",sum(df_shape_y_t()$value)) })
    
    output$text_box_2 <- renderText({ paste("En promedio, por estado fueron: ",round(mean(df_shape_y_t()$value),0)) })
    
    observe({
      # Make sure theme is kept current with desired
      session$setCurrentTheme(
        bs_theme_update(my_theme, bootswatch = input$current_theme)
      )
    })
     
}