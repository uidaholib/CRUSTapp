################
##
## @description Calculate the deterministic part of the model
##
## @param model Model in matrix format
## @param xset  X values randomly generated
## @param betas Random betas
##
## @return Deterministic value of the model
##
## @lastChange 2016-12-28
##
## @changes
##
################
calculateDet <- function(model, xset, betas){
  
  if(!is.matrix(model)){
    model <- t(as.matrix(model))
  }
  
  deterministic <- 0
  for(r in 1:nrow(model)){
    x <- rowProds(as.matrix(xset[, model[r,] == 1]))
    deterministic <- deterministic + (betas[r] * x)
  }
  
  return(deterministic)
}
