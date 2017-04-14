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
  
  vals <- reactiveValues(running = FALSE, step = 0, run = 1, label = "Start")
  
  start <- 0
  
  output$Intro <- renderText({
    "CRUST is a R-Shiny based web app open to

    public. Using an analogy for the user
    
    interface, CRUST teaches the notion of
    
    reproducibility with real time simulations.
    
    The analogy will use the process of bread
    
    baking without an exact recipe to represent
    
    the process of scientific discovery without
    
    knowing the truth. The true model is
    
    represented by a secret recipe that
    
    no one has direct access to. To simulate
    
    scientists' research efforts to uncover the
    
    truth, bakers will experiment with their own
    
    bread recipes by trying to improve upon the
    
    recipes tested by previous bakers. The aim
    
    of the community of bakers is to uncover
    
    the secret true recipe."
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
    tModel <- models[[as.numeric(as.character(input$tModel))]]
    
    ## Correlation
    correlation <- input$correlation
    
    ## Number of replicators
    nRay <- input$nRay
    #print(nRay)
    
    ## Number of robusts (add or removes terms)
    nRob <- input$nRob
    #print(nRob)
    
    ## Number of robusts (add interactions)
    nBob <- input$nBob
    #print(nBob)
    
    ## Number of novel (random select a model)
    nNel <- input$nNel
    #print(nNel)
    
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
    N <- c(rep(RAY, nRay), rep(ROB, nRob), rep(BOB, nBob), rep(NEL, nNel))
    N <- N[shuffle(length(N))]
    
    agentTypes <- N[as.integer(runif(timesteps, min=1,
                                     max=(nRay + nRob + nBob + nNel + 1)))]
    
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
    inParam$modelCompare <<- modelCompare
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
      updateTabsetPanel(session,"tabpanel", selected = "Plot")
    })
    
    # If we're not done yet, then schedule this block to execute again ASAP.
    # Note that we can be interrupted by other reactive updates to, for
    # instance, update a text output.
    if (isolate({ (vals$step < inParam$timesteps) && vals$running })) {
      m <- go(inParam)
      inParam$model1 <<- m[[1]]
      inParam$model2 <<- m[[2]]
      #Sys.sleep(1) # placeholder for computation
      vals$step <- isolate(vals$step) + 1
      inParam$agentType <<- inParam$agentTypes[vals$step]
      invalidateLater(0, session)
    }
  })
  
  output$Status <- renderText({
    paste("You're on iteration number:", vals$step)
  })
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Help!", #Title of modal area
      "This is helping!", #body of modal area
      easyClose = TRUE
      
    ))
  })
  
})
