################
##
## @description Calculate the estimated value based on the data generated under
##              the True Model
##
## @param model Model in matrix format
## @param betas Betas
## @param xset  X values randomly generated
##
## @return Similar model by interaction
##
## @lastChange 2016-12-28
##
## @changes
##
################
modelExpectation <- function(model, betas, xset){
  
  if(!is.matrix(model)){
    model <- t(as.matrix(model))
  }
  
  k <- length(model[1,])
  
  f <- 10^((k-1):0)
  modelExp <- rep(betas[1, 2], nrow(xset))
  for(r in 1:nrow(model)){
    x <- rowProds(as.matrix(xset[, model[r,] == 1]))
    index <- betas[,1] == sum(as.numeric(model[r,] == 1) * f)
    modelExp <- modelExp + (betas[index, 2] * x)
  }
  
  return(modelExp)
}
