library(shiny)

shinyUI(
  fluidPage(
    theme = "/source/CSS_file.css",
    
    ## Head
    tags$head(
      tags$script(type = "text/javascript",
                  src = "http://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"),
      tags$script(type = "text/javascript",
                  src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"),
      tags$script(src = "/source/nouislider.min.js"),
      tags$link(rel = "stylesheet",
                href = "/source/nouislider.min.css"),
      tags$link(rel = "stylesheet",
                href = "/source/stylesheet.css"),
      tags$script(src = "/source/script.js"),
      tags$script(src = "/source/intro.js"),
      tags$meta(name="viewport",
                content="width=device-width, initial-scale=1"),
      tags$script(HTML("$(document).ready(function(){
                          $('[data-toggle=\"popover\"]').popover();
                       });"))
    ),
    
    ## Title
    fluidRow(
      column(6, tags$img(src = "/images/CRUST.png")),
      column(6, br(), actionButton("help",
                                   label = "Help",
                                   onClick = "javascript:introJs().start();",
                                   style="float:right")
            )
    ),
    
    ## Main grid section
    fluidRow(
      ## Center column for bread grid
      column(7,
             id = "main",
             fluidRow(
               column(9,
                      id = "bread",
                      ## Top row of breads
                      fluidRow(
                        ## Bread A
                        column(3,
                               tags$img(src = "/images/a.png",
                                        height ="50",
                                        id = "a"),
                               class = "topBot ring",
                               id = "0",
                               onclick = "Click(this.id)"
                              ),
                        ## Bread B
                        column(3,
                               tags$img(src = "/images/b.png",
                                        height ="50",
                                        id = "b"),
                               class = "topBot ring",
                               id = "1",
                               onclick = "Click(this.id)"
                              ),
                        ## Bread C
                        column(3,
                               tags$img(src = "/images/c.png",
                                        height ="50",
                                        id = "c"),
                               class = "topBot ring",
                               id = "2",
                               onclick = "Click(this.id)"
                              ),
                        ## Bread D
                        column(3,
                               tags$img(src = "/images/d.png",
                                        height ="50",
                                        id = "d"),
                               class = "topBot ring",
                               id = "3",
                               onclick = "Click(this.id)"
                              )
                      ),
                      ## Middle row of breads
                      fluidRow(
                        ## Left side column of breads
                        column(3,
                               fluidRow(
                                 ## Bread E
                                 column(12,
                                        tags$img(src = "/images/e.png",
                                                 height = "50",
                                                 id = "e"),
                                        class = "right bot ring",
                                        id = "4", onclick = "Click(this.id)")
                                ),
                               fluidRow(
                                 ## Bread G
                                 column(12,
                                        tags$img(src = "/images/g.png",
                                                 height = "50",
                                                 id = "g"),
                                        class = "right ring",
                                        id = "6",
                                        onclick = "Click(this.id)")
                                ),
                               fluidRow(
                                 ## Bread I
                                 column(12,
                                        tags$img(src = "/images/i.png",
                                                 height ="50", id = "i"),
                                        class = "right top ring",
                                        id = "8",
                                        onclick = "Click(this.id)"
                                        )
                                )
                              ),
                        ## Center big bread
                        column(6,
                               id = "centerbread",
                               tags$h4("True Bread",
                                       id = "centertext",
                                       style = "text-align: center"
                                       )
                               ),
                        ## Right side column of breads
                        column(3,
                               fluidRow(
                                 ## Bread F
                                 column(12,
                                        tags$img(src = "/images/f.png",
                                                 height = "50",
                                                 id = "f"),
                                        class = "left bot ring",
                                        id = "5",
                                        onclick = "Click(this.id)"
                                        )
                                ),
                               fluidRow(
                                 ## Bread H
                                 column(12,
                                        tags$img(src = "/images/h.png",
                                                 height = "50",
                                                 id = "h"),
                                        class = "left ring",
                                        id = "7",
                                        onclick = "Click(this.id)"
                                        )
                                 ),
                               fluidRow(
                                 ## Bread J
                                 column(12,
                                        tags$img(src = "/images/j.png",
                                                 height = "50",
                                                 id = "j"),
                                        class = "left top ring",
                                        id = "9",
                                        onclick = "Click(this.id)"
                                        )
                                 )
                               )
                        ),
                      ## Bottom row of breads
                      fluidRow(
                        column(3,
                               tags$img(src = "/images/k.png",
                                        height = "50",
                                        id = "k"),
                               class = "topBot ring",
                               id = "10",
                               onclick = "Click(this.id)"
                               ),
                        column(3,
                               tags$img(src = "/images/l.png",
                                        height = "50",
                                        id = "l"),
                               class = "topBot ring",
                               id = "11",
                               onclick = "Click(this.id)"
                               ),
                        column(3,
                               tags$img(src = "/images/m.png",
                                        height = "50",
                                        id = "m"),
                               class = "topBot ring",
                               id ="12",
                               onclick = "Click(this.id)"
                               ),
                        column(3,
                               tags$img(src = "/images/n.png",
                                        height = "50",
                                        id = "n"),
                               class = "topBot ring",
                               id = "13",
                               onclick = "Click(this.id)"
                               )
                        )
                      ),
      ## Right Information Division
      column(3,
             id = "RTB",
             class = "info", "")
      ),
      fluidRow(
        br(),
        actionButton("run",
                     label = "Start"),
        actionButton("setup",
                     label = "Setup",
                     onclick = "setupfunc()"),
        br(),
        br(),
        column(12,
               fluidRow(
                 column(4,
                        ## Time steps
                        sliderInput("timesteps",
                                    label = h5("Time Steps",
                                               HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                    title=\"Time Steps\"
                                                    data-content=\"Length of the simulation\"
                                                    data-trigger=\"hover\"></img>")),
                                    value = 100,
                                    min = 1,
                                    max = 1000,
                                    ticks = FALSE
                        ),
                        br(),
                        ## Model Comparison
                        selectInput("modelCompare",
                                    label = h5("Comparison Method",
                                               HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                    title=\"Bread Method\"
                                                    data-content=\"Statistics method used to comparing two breads\"
                                                    data-trigger=\"hover\"></img>")
                                               ),
                                    choices = c("T Statistics" = "1",
                                                "R-Square" = "2",
                                                "Adjusted R-Square" = "3",
                                                "AIC" = "4"),
                                    selected = "4"
                                    )
                        ),
                 column(4,
                        ## Correlation
                        sliderInput("correlation",
                                    label = h5("Correlation",
                                               HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                    title=\"Correlation\"
                                                    data-content=\"Data correlation\"
                                                    data-trigger=\"hover\"></img>")),
                                    value = 0.5,
                                    min = 0,
                                    max = 1,
                                    step = 0.01,
                                    ticks = FALSE
                        ),
                        ## Sigma
                        sliderInput("sigma",
                                    label = h5("Sigma",
                                               HTML("<img src=\"/images/information_image.png\" height=\"20\" data-toggle=\"popover\"

                                                    title=\"Sigma\"
                                                    data-content=\"Error variance\"
                                                    data-trigger=\"hover\"></img>")),
                                    value = 0.5,
                                    min = 0,
                                    max = 1,
                                    step = 0.01,
                                    ticks = FALSE
                                    )
                        )
               ),
               br(),
               fluidRow(id = "lastRow"
                        )
               )
        )
      ),
      
    ## Graph outputs
    column(5,
           tabsetPanel(
             tabPanel("Intro",
                      textOutput("Intro")),
             tabPanel("Plot",
                      plotOutput("Plot1"),
                      plotOutput("Plot2")),
             tabPanel("Summary",
                      textOutput("summary")),
             id = "tabpanel"
             )
           )
    )
    )
  )
