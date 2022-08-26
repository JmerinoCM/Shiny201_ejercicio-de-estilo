fluidPage(
  theme = my_theme,
  # theme = bslib::bs_theme(
  #   bg = "#002B36", fg = "#EEE8D5", primary = "#2AA198",
  #   # bslib also makes it easy to import CSS fonts
  #   base_font = bslib::font_google("Pacifico"),version = 3
  # ),
  navbarPage(title = list("Shiny 201"
      
  ),
  header = list(radioButtons("current_theme", "Modo:", c("Claro" = "minty", "Oscuro" = "darkly"), inline = T),
  # header = list(radioButtons("current_theme", "Modo:", c("Claro" = "minty", "Oscuro" = "darkly","Quartz" = "quartz","Sketchy"="sketchy"), inline = T), # Temas adicionales
                tags$div(
                  HTML("

<div class='progress'>
  <div class='progress-bar progress-bar-striped progress-bar-animated' role='progressbar' aria-valuenow='75' aria-valuemin='0' aria-valuemax='100' style='width: 100%;'></div>
</div>

")
                )),
# footer = list(
#               tags$div(
#                 HTML("
# <div class='progress'>
#   <div class='progress-bar progress-bar-striped progress-bar-animated bg-success' role='progressbar' aria-valuenow='75' aria-valuemin='0' aria-valuemax='100' style='width: 100%;'></div>
# </div>
# 
# ")
#               )),
             theme = my_theme,
  navbarMenu("Main",
    tabPanel("Delincuencia",
      tabItem(tabName = "mapas",
              fluidRow(
                h1("DELITOS EN MÉXICO", align = "center"),
                column(4,  
                       plotlyOutput("gr3_plotly", height = 600, width = "100%")
                ),
               
                column(5,  
              leafletOutput("mp3_leaflet", height = 550, width = "100%"),
                ),
              column(3, style = "height = 550;",
                     wellPanel(
                       fluidRow(
                         pickerInput("year_m","Año", choices=c(unique(df_shape$years)), 
                                     selected = unique(df_shape$years)[1], options = list(`actions-box` = FALSE),multiple = F)
                       ),
                       fluidRow(
                         pickerInput("state_m","Estado", choices=c(unique(df_shape$ENTIDAD)), 
                                     selected = unique(df_shape$ENTIDAD), options = list(`actions-box` = TRUE),multiple = T)
                       )
                     ),
                     br(""),
                     tags$div(class="card text-white bg-danger mb-3", style="max-width: 100%;",
                              tags$div(class="card-header",textOutput("text_y")),
                              tags$div( class="card-body",h6(textOutput("text_box_1")),h6(textOutput("text_box_2")),)
                     ), 
              ),
              ),
              br(""),
    )
    )
    )
################################################################################
)
)