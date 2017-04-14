library(shiny)

shinyUI(fluidPage(theme = "/source/CSS_file.css",
  tags$head(
    tags$script( type = "text/javascript", src = "http://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"),
    tags$script( type = "text/javascript", src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"),
    tags$script(src = "/source/nouislider.min.js"), #Agent-slider code
    tags$link(rel = "stylesheet", href = "/source/nouislider.min.css"), #agent-slider styling
    tags$link(rel = "stylesheet", href = "/source/stylesheet.css"),
    tags$script(src = "/source/script.js"),
    tags$script(src = "/source/intro.js"),
    tags$meta(name="viewport",content="width=device-width, initial-scale=1"),
    tags$script(HTML("$(document).ready(function(){
                     $('[data-toggle=\"popover\"]').popover();   
                     });"))
    
    #old image resize idea
    #tags$style(".imageclass{height:10vh !important; width:5vw !important;} .bimageclass{height:16vh !important; width:9vw !important;}")
    ),
  #Tittle
  fluidRow(
    column(6,
      tags$img(src = "/images/CRUST.png")
    ),
    column(6,
      br(),  
      actionButton("help", label = "Help", onClick = "javascript:introJs().start();", style="float:right")
    )
    
  ),

  
  #Main grid section 
  
  fluidRow(
    #center column for bread grid
    column(7,
      id= "main",
      fluidRow( column(9,id="bread",
        fluidRow( #Top row of breads
          column(3,tags$img(src = "/images/a.png", height ="50", id = "a"), class = "topBot ring", id ="0", onclick = "Click(this.id)"),
          column(3,tags$img(src = "/images/b.png", height ="50", id = "b"), class = "topBot ring", id ="1", onclick = "Click(this.id)"),
          column(3,tags$img(src = "/images/c.png", height ="50", id = "c"), class = "topBot ring", id ="2", onclick = "Click(this.id)"),
          column(3,tags$img(src = "/images/d.png", height ="50", id = "d"), class = "topBot ring", id ="3", onclick = "Click(this.id)")
        ),
        fluidRow(#middle row of breads
          column(3,
                 fluidRow(#left side of breads 
                   column(12,tags$img(src = "/images/e.png", height ="50", id = "e"), class = "right bot ring", id ="4", onclick = "Click(this.id)")),
                 fluidRow(
                   column(12,tags$img(src = "/images/g.png", height ="50", id = "g"), class = "right ring", id ="5", onclick = "Click(this.id)")),
                 fluidRow(column(12,tags$img(src = "/images/i.png", height ="50", id = "i"), class = "right top ring", id ="6", onclick = "Click(this.id)")
)
                 ),
          column(6, id="centerbread", tags$h4("Select a Target Bread",id="centertext",style = "text-align: center")), # middle big bread image
          
          column(3,
                 fluidRow(#right side of breads
                   column(12,tags$img(src = "/images/f.png", height ="50", id = "f"), class = "left bot ring", id ="7", onclick = "Click(this.id)")
                 ),
                 fluidRow(
                   column(12,tags$img(src = "/images/h.png", height ="50", id = "h"), class = "left ring", id ="8", onclick = "Click(this.id)")
            
                ),
                fluidRow(
                  column(12,tags$img(src = "/images/j.png", height ="50", id = "j"), class = "left top ring", id ="9", onclick = "Click(this.id)")
                  
                )
          )
   
        ),
  
        fluidRow(
          column(3,tags$img(src = "/images/k.png", height ="50", id = "k"), class = "topBot ring", id ="10", onclick = "Click(this.id)"),
          column(3,tags$img(src = "/images/l.png", height ="50", id = "l"), class = "topBot ring", id ="11", onclick = "Click(this.id)"),
          column(3,tags$img(src = "/images/m.png", height ="50", id = "m"), class = "topBot ring", id ="12", onclick = "Click(this.id)"),
          column(3,tags$img(src = "/images/n.png", height ="50", id = "n"), class = "topBot ring", id ="13", onclick = "Click(this.id)")
        )
    
      
      ),
      #right info div
      column(3,id = "RTB", class = "info", "test")
      
      ),
      fluidRow(
        br(),
        actionButton("run", label = "Start"),
        actionButton("setup", label = "Setup", onclick="setupfunc()"),
        br(),
        column(12,  
               fluidRow(
                 column(4, #left 
                        br(),
                        selectInput("modelCompare", 
                                    label=h5("Model Comparison",HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                                           title=\"Popover Header\"
                                                                           data-content=\"Some content inside the popover\"

                                                                           data-trigger=\"hover\"></img>")),
                                    choices = c("T Statistics" = "1",
                                                "R-Square" = "2",
                                                "Adjusted R-Square" = "3",
                                                "AIC" = "4")),

                        selectInput("tModel", 
                                    label=h5("True Model",HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                                           title=\"Popover Header\"
                                                                           data-content=\"Some content inside the popover\"

                                                                           data-trigger=\"hover\"></img>")),
                                    choices = c("a" = "1",
                                                "b" = "2",
                                                "c" = "3"))
                 ),
                 column(4, #middle 
                        sliderInput("timesteps",
                                    label = h5("Time Steps",HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                                           title=\"Popover Header\"
                                                                           data-content=\"Some content inside the popover\"

                                                                           data-trigger=\"hover\"></img>")), 
                                    value = 100,
                                    min =1,
                                    max=1000,
                                    ticks = FALSE
                        ),
                        sliderInput("sigma",
                                    label = h5("Sigma",HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                                           title=\"Popover Header\"
                                                                           data-content=\"Some content inside the popover\"

                                                                           data-trigger=\"hover\"></img>")),
                                    value = 0.5,
                                    min =0,
                                    max=1,
                                    step = 0.01,
                                    ticks = FALSE
                        )

                 ),
                 column(4, #right
                        sliderInput("correlation",
                                    label = h5("Correlation",HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                                  title=\"Popover Header\"
                                                                  data-content=\"Some content inside the popover\"
                                                                  
                                                                  data-trigger=\"hover\"></img>")),
                                    value = 0.5,
                                    min = 0,
                                    max = 1,
                                    step = 0.01,
                                    ticks = FALSE
                        )

               )#end of top input row
               #second input row

                 
               ),#end of second fluid row
               fluidRow(id = "lastRow"
                        
                        
               )
               
        )#end of outter most column
      )
      
    ),#end main column
    
    #right most column for graph outputs
    column(5,
        tabsetPanel(
          tabPanel("Intro", textOutput("Intro")),
          tabPanel("Plot", textOutput("Status")),
          tabPanel("Summary", textOutput("summary")),
          id="tabpanel"
      )
    )
  )
  
  )
)
