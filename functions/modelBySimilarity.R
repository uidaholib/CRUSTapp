################
##
## @description Generate a similar model adding an interaction
##
## @param model Model in matrix format
##
## @return Similar model by interaction
##
## @lastChange 2016-12-28
##
## @changes
##
################
modelSimilarByInteraction <- function(model){
  
  if(!is.matrix(model)){
    k <- length(model)
    similarModel <- t(as.matrix(model))
    model <- t(as.matrix(model))
  } else {
    similarModel <- model
  }
  
  k <- length(model[1,])
  
  # Get the index of the single terms and
  # identify existing interactions
  f <- 10^((k-1):0)
  nTerms <- 0
  terms <- c()
  inters <- c()
  for(r in 1:nrow(model)){
    if(sum(model[r,]) == 1){
      nTerms <- nTerms + 1
      terms <- c(terms, which(model[r,] == 1))
    } else {
      inters <- c(inters, sum(model[r,] * f))
    }
  }
  
  # Generate all possible interactions
  inter <- NULL
  if(length(terms) > 1){
    for(i in 2:length(terms)){
      comb <- combs(terms, i)
      for(c in 1:nrow(comb)){
        aux <- rep(0, k)
        aux[comb[c,]] <- 1
        if (!(sum((aux) * f) %in% inters)){
          inter <- rbind(inter, aux)
        }
      }
    }
  }
  
  # Select an interaction randomly
  if(!is.null(nrow(inter))){
    rownames(inter) <- c()
    addInter <- inter[as.integer(runif(1, min=1, max=nrow(inter)+1)),]
  
    # Identify the index of the terms in the interaction
    terms <- which(addInter == 1)
    
    # Add all necessary interactions
    similarModel <- rbind(similarModel, addInter)
    rownames(similarModel) <- c()
    inters <- c(inters, sum(addInter * f))
    for(i in 2:length(terms)){
      comb <- combs(terms, i)
      for(c in 1:nrow(comb)){
        aux <- rep(0, k)
        aux[comb[c,]] <- 1
        if(!(sum((aux) * f) %in% inters)){
          similarModel <- rbind(similarModel, aux)
          rownames(similarModel) <- c()
        }
      }
    }
  }
  
  return(similarModel)
}


################
##
## @description Generate a similar model adding or removing a term
##
## @param model Model in matrix format
##
## @return Similar model by term
##
## @lastChange 2016-12-28
##
## @changes
##
################
modelSimilarByTerm <- function(model){
  
  opAdd <- TRUE
  if(!is.matrix(model)){
    nTerms <- 1
    terms <- which(model == 1)
    
    similarModel <- t(as.matrix(model))
    model <- t(as.matrix(model))
    
    k <- length(model[1,])
  } else {
    nTerms <- 0
    terms <- c()
    for(r in 1:nrow(model)){
      if(sum(model[r,]) == 1){
        nTerms <- nTerms + 1
        terms <- c(terms, which(model[r,] == 1))
      }
    }
    
    k <- length(model[1,])
    
    if((nTerms == k) ||
       ((nTerms > 1) && (runif(1) > 0.5))){
      opAdd <- FALSE
    }
    
    similarModel <- model
  }
  
  if(opAdd){
    values <- setdiff(c(1:k), terms)
    index <- round(runif(1, 1, length(values)))
    newTerm <- rep(0, k)
    newTerm[values[index]] <- 1
    similarModel <- rbind(similarModel, newTerm)
  } else {
    index <- terms[round(runif(1, 1, length(terms)))]
    
    if(index != 1){
      similarModel <- c()
      for(r in 1:nrow(model)){
        term <- model[r,]
        if(term[index] != 1){
          similarModel <- rbind(similarModel, model[r,])
        }
      }
    }
  }
  
  rownames(similarModel) <- c()
  return(similarModel)
}
