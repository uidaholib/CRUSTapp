go <- function(inParam){
  
  agentType <- inParam$agentType
  model1 <- inParam$model1
  model2 <- inParam$model2
  gModel <- inParam$gModel
  models <- inParam$models
  nModels <- inParam$nModels
  deterministic <- inParam$deterministic
  sigma <- inParam$sigma
  Xset <- inParam$Xset
  betas <- inParam$betas
  modelCompare <- inParam$modelCompare
  
  ## Ray (replicator)
  if(agentType == RAY){
    if(!compareModels(model2, gModel)){
      model <- model2
    } else {
      model <- model1
    }
    
    ## Rob (robust)
  } else if(agentType == ROB){
    model <- modelSimilarByTerm(gModel)
    
    ## Bob (robust)
  } else if(agentType == BOB){
    model <- modelSimilarByInteraction(gModel)
    
    ## Nel (random)
  } else if(agentType == NEL){
    model <- models[[as.integer(runif(1, min=1, max=nModels + 1))]]
  }
  
  model1 <- model
  model2 <- gModel
  
  ## Analyze the Selected Model and Global Model
  Yset <- generateY(deterministic, sigma)
  stat <- analysis(model, gModel, Yset, Xset, betas)
  
  switchModel <- FALSE
  if((modelCompare == TSTATISTICS) &
     (!is.null(stat$model$tstatistics)) &
     (!is.null(stat$gModel$tstatistics)) &
     (!is.na(stat$model$tstatistics)) &
     (!is.na(stat$gModel$tstatistics))){
    if(stat$model$tstatistics > stat$gModel$tstatistics){
      switchModel <- TRUE
    }
  } else if((modelCompare == RSQ) &
            (!is.null(stat$model$rsq)) &
            (!is.null(stat$gModel$rsq)) &
            (!is.na(stat$model$rsq)) &
            (!is.na(stat$gModel$rsq))){
    if(stat$model$rsq > stat$gModel$rsq){
      switchModel <- TRUE
    }
  } else if((modelCompare == AIC) &
            (!is.null(stat$model$aic)) &
            (!is.null(stat$gModel$aic)) &
            (!is.na(stat$model$aic)) &
            (!is.na(stat$gModel$aic))){
    if(stat$model$aic < stat$gModel$aic){
      switchModel <- TRUE
    }
  } else if((modelCompare == ARSQ) &
            (!is.null(stat$model$arsq)) &
            (!is.null(stat$gModel$arsq)) &
            (!is.na(stat$model$arsq)) &
            (!is.na(stat$gModel$arsq))){
    if(stat$model$arsq > stat$gModel$arsq){
      switchModel <- TRUE
    }
  }
  
  if(switchModel){
    gModel <- model
  }

  return(list(model1, model2))
}
