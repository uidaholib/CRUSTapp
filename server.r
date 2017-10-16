library(shiny)
library(data.table)
library(ggplot2)

library(caTools)
library(data.table)
library(permute)
library(matrixStats)
library(MCMCpack)

#############
## PATHS
#############
baseDir <- "C:/Users/jbech/Dropbox/Reproducibility/WebApp(Current)"
baseDir <- "/data/workspace/cmci/CRUSTapp"
scriptDir <- paste0(baseDir, "/functions")


#############
## FUNCTIONS
#############
source(paste0(scriptDir, "/analysis.R"))
source(paste0(scriptDir, "/calculateDet.R"))
source(paste0(scriptDir, "/calculateDistance.R"))
source(paste0(scriptDir, "/compareModels.R"))
source(paste0(scriptDir, "/constants.R"))
source(paste0(scriptDir, "/convertBinary.R"))
source(paste0(scriptDir, "/generateBetas.R"))
source(paste0(scriptDir, "/generateModels.R"))
source(paste0(scriptDir, "/generateXSet.R"))
source(paste0(scriptDir, "/generateY.R"))
source(paste0(scriptDir, "/getBetas.R"))
source(paste0(scriptDir, "/getPredictors.R"))
source(paste0(scriptDir, "/go.R"))
source(paste0(scriptDir, "/modelBySimilarity.R"))
source(paste0(scriptDir, "/modelToStr.R"))
source(paste0(scriptDir, "/searchModel.R"))
source(paste0(scriptDir, "/strToModel.R"))

shinyServer(function(input, output, session) {
  
  inParam <- list()
  inParam$timesteps <- 0
  inParam$freqModel <- vector(mode = "integer", length = 14)
  inParam$distance <- data.table(step = 0, value = 1)

  start <- 0
  
  vals <- reactiveValues(running = FALSE, step = 0, run = 1, label = "Start",
                         plot1 = NULL, plot2 = NULL)
  
  output$Intro <- renderText({
    "CRUST is a R-Shiny based web app open to public. Using an analogy for the
     user interface, CRUST teaches the notion of reproducibility with real time
     simulations. The analogy will use the process of bread baking without an
     exact recipe to represent the process of scientific discovery without
     knowing the truth. The true model is represented by a secret recipe that no
     one has direct access to. To simulate scientists' research efforts to
     uncover the truth, bakers will experiment with their own bread recipes by
     trying to improve upon the recipes tested by previous bakers. The aim of
     the community of bakers is to uncover the secret true recipe."
  })
  
  toggleLabel <- function() {
    if(vals$label %in% c("Start", "Resume")){
      vals$label <- "Stop"
    } else{
      vals$label <- "Resume"
    }
    vals$label
  }
  
  observeEvent(input$setup, {
    ## Length of the simulation
    timesteps <- input$timesteps
    
    ## Number of factors
    k <- 3
    
    ## Sigma (Error variance)
    sigma <- input$sigma
    
    ## Sample size
    sampleSize <- 100
    
    ## Generate all possible linear regression models with k number of factors
    models <- generateModels(k)
    
    ## Generate Betas
    betas <- generateBetas(models)
    
    ## True model
    tModel <- models[[as.numeric(as.character(input$tModel)) + 1]]
    
    ## Correlation
    correlation <- input$correlation
    
    ## Number of replicators
    nRay <- input$nRay

    ## Number of robusts (add or removes terms)
    nRob <- input$nRob

    ## Number of robusts (add interactions)
    nCara <- input$nCara

    ## Number of novel (random select a model)
    nNell <- input$nNell

    ## Model comparison
    modelCompare <- as.numeric(as.character(input$modelCompare))
    
    ## Generate Xset and deterministic value of the linear regression
    Xset <- generateXSet(sampleSize, k, correlation)
    tModelBetas <- getBetas(tModel, betas, sigma)
    deterministic <- calculateDet(tModel, Xset, tModelBetas)
    
    ## Select randomly Global Model and previous Global Model
    gModel <- models[[as.integer(runif(1, min=1, max=length(models) + 1))]]
    
    model1 <- models[[as.integer(runif(1, min=1, max=length(models) + 1))]]
    model2 <- gModel
    
    ## Initialize agents
    N <- c(rep(RAY, nRay), rep(ROB, nRob), rep(CARA, nCara), rep(NELL, nNell))
    N <- N[shuffle(length(N))]
    
    agentTypes <- N[as.integer(runif(timesteps, min=1,
                                     max=(nRay + nRob + nCara + nNell + 1)))]
    
    vals$running <- FALSE
    vals$step <- 0
    vals$run <- 1
    vals$label <- "Start"
    updateActionButton(session, "run", label = vals$label)
    
    inParam$timesteps <<- timesteps
    inParam$agentTypes <<- agentTypes
    inParam$agentType <<- agentTypes[1]
    inParam$model1 <<- model1
    inParam$model2 <<- model2
    inParam$gModel <<- gModel
    inParam$models <<- models
    inParam$nModels <<- length(models)
    inParam$deterministic <<- deterministic
    inParam$sigma <<- sigma
    inParam$Xset <<- Xset
    inParam$betas <<- betas
    inParam$tModelBetas <<- tModelBetas
    inParam$modelCompare <<- modelCompare
    
    inParam$freqModel <<- vector(mode = "integer", length = 14)
    
    vals$plot1 <- ggplot(data = data.table(model = seq(1, 14),
                                           value = inParam$freqModel),
                         aes(x = as.factor(model), y = value)) +
      geom_bar(stat = "identity") +
      ylim(0, 10) +
      xlab("Bread") +
      ylab("Frequency") +
      scale_x_discrete(breaks = 1:14,
                       labels = c("1", "2", "3", "4", "5", "6", "7", "8", "9",
                                  "10", "11", "12", "13", "14")) +
      theme(axis.title.x = element_text(color='black', size=14, face='bold',
                                        margin=margin(t=0.2, unit = "cm")),
            axis.title.y = element_text(color='black', size=16, face='bold',
                                        margin=margin(r=0.5, unit = "cm")),
            axis.text.x = element_text(color='black', size=16, face='bold'),
            axis.text.y = element_text(color='black', size=16, face='bold'),
            axis.line.x = element_line(color='black', size=1, linetype='solid'),
            axis.line.y = element_line(color='black', size=1, linetype='solid'),
            panel.background = element_rect(fill="transparent", color=NA),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_blank(),
            plot.margin = unit(c(0.5, 1, 0.5, 1), "cm"),
            #legend.position = "none",
            legend.title = element_text(color="black", size=14, face="bold"),
            legend.text = element_text(color="black", size=12, face="bold"),
            legend.key = element_rect(fill = "white"))
    
    inParam$distance <<- data.table(step = 0, value = 1)
    
    vals$plot2 <- ggplot(data = inParam$distance,
                         aes(x = step, y = value)) +
      xlab("Step") +
      ylab("Distance") +
      theme(axis.title.x = element_text(color='black', size=14, face='bold',
                                        margin=margin(t=0.2, unit = "cm")),
            axis.title.y = element_text(color='black', size=16, face='bold',
                                        margin=margin(r=0.5, unit = "cm")),
            axis.text.x = element_text(color='black', size=16, face='bold'),
            axis.text.y = element_text(color='black', size=16, face='bold'),
            axis.line.x = element_line(color='black', size=1, linetype='solid'),
            axis.line.y = element_line(color='black', size=1, linetype='solid'),
            panel.background = element_rect(fill="transparent", color=NA),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_blank(),
            plot.margin = unit(c(0.5, 1, 0.5, 1), "cm"),
            #legend.position = "none",
            legend.title = element_text(color="black", size=14, face="bold"),
            legend.text = element_text(color="black", size=12, face="bold"),
            legend.key = element_rect(fill = "white"))
  })
  
  observe({
    req(input$run)
    
    isolate({
      # update label when the button is clicked and stop/resume computation
      if (input$run != vals$run) {
        updateActionButton(session, "run", label = toggleLabel())
        vals$run <<- input$run
        vals$running <<- !vals$running
      }
      
      # update label and vals$running the first time around only
      if (vals$label == "Start") {
        updateActionButton(session, "run", label = toggleLabel())
        vals$running <- TRUE
      }
      updateTabsetPanel(session, "tabpanel", selected = "Plot")
    })
    
    # If we're not done yet, then schedule this block to execute again ASAP.
    # Note that we can be interrupted by other reactive updates to, for
    # instance, update a text output.
    if (isolate({ (vals$step < inParam$timesteps) && vals$running })) {
      isolate({
      for (iter in 1:min(10, inParam$timesteps - vals$step)) {
        m <- go(inParam)
        
        inParam$model1 <<- m[[1]]
        inParam$model2 <<- m[[2]]
        
        ## Increment the number of times a model is chosen as Global Model
        inParam$freqModel[m[[3]]] <<- inParam$freqModel[m[[3]]] + 1
        
        ## Update the distance plot
        inParam$distance <<- rbind(inParam$distance,
                                   cbind(step = isolate(vals$step),
                                         value = m[[4]]))
        
        ## Update step
        vals$step <- isolate(vals$step) + 1
        inParam$agentType <<- inParam$agentTypes[vals$step]
      }
      })
      
      vals$plot1 <- ggplot(data = data.table(model = seq(1, 14),
                                             value = inParam$freqModel),
                           aes(x = as.factor(model), y = value)) +
        geom_bar(stat = "identity") +
        ylim(0, NA) +
        xlab("Bread") +
        ylab("Frequency") +
        scale_x_discrete(breaks = 1:14,
                         labels = c("1", "2", "3", "4", "5", "6", "7", "8", "9",
                                    "10", "11", "12", "13", "14")) +
        theme(axis.title.x = element_text(color='black', size=14, face='bold',
                                          margin=margin(t=0.2, unit = "cm")),
              axis.title.y = element_text(color='black', size=16, face='bold',
                                          margin=margin(r=0.5, unit = "cm")),
              axis.text.x = element_text(color='black', size=16, face='bold'),
              axis.text.y = element_text(color='black', size=16, face='bold'),
              axis.line.x = element_line(color='black', size=1, linetype='solid'),
              axis.line.y = element_line(color='black', size=1, linetype='solid'),
              panel.background = element_rect(fill="transparent", color=NA),
              panel.grid.minor = element_blank(),
              panel.grid.major = element_blank(),
              plot.margin = unit(c(0.5, 1, 0.5, 1), "cm"),
              #legend.position = "none",
              legend.title = element_text(color="black", size=14, face="bold"),
              legend.text = element_text(color="black", size=12, face="bold"),
              legend.key = element_rect(fill = "white"))
      
      vals$plot2 <- ggplot(data = inParam$distance,
                           aes(x = step, y = value)) +
        geom_line() +
        xlab("Step") +
        ylab("Distance") +
        theme(axis.title.x = element_text(color='black', size=14, face='bold',
                                          margin=margin(t=0.2, unit = "cm")),
              axis.title.y = element_text(color='black', size=16, face='bold',
                                          margin=margin(r=0.5, unit = "cm")),
              axis.text.x = element_text(color='black', size=16, face='bold'),
              axis.text.y = element_text(color='black', size=16, face='bold'),
              axis.line.x = element_line(color='black', size=1, linetype='solid'),
              axis.line.y = element_line(color='black', size=1, linetype='solid'),
              panel.background = element_rect(fill="transparent", color=NA),
              panel.grid.minor = element_blank(),
              panel.grid.major = element_blank(),
              plot.margin = unit(c(0.5, 1, 0.5, 1), "cm"),
              #legend.position = "none",
              legend.title = element_text(color="black", size=14, face="bold"),
              legend.text = element_text(color="black", size=12, face="bold"),
              legend.key = element_rect(fill = "white"))
      
      print(input$tModel)
      invalidateLater(0, session)
    }
  })
  
  output$Model <- renderText({
    paste("You're on iteration number:", vals$step)
  })
  
  output$Plot1 <- renderPlot({ vals$plot1 })
  
  output$Plot2 <- renderPlot({ vals$plot2 })
  
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Help!", #Title of modal area
      "This is helping!", #body of modal area
      easyClose = TRUE
    ))
  })
})
