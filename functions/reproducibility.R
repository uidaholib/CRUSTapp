################
##
## @description Main reproducibility simulation
##
## @param None
##
## @return None
##
## @lastChange 2017-02-01
##
## @changes
##
################
library(caTools)
library(data.table)
library(permute)
library(matrixStats)
library(MCMCpack)


#############
## PATHS
#############
baseDir <- "/data/Dropbox/Reproducibility"
scriptDir <- paste0(baseDir, "/code")
inputDir <- paste0(baseDir, "/data")
outputDir <- paste0(baseDir, "/data")


#############
## FUNCTIONS
#############
source(paste0(scriptDir, "/analysis.R"))
source(paste0(scriptDir, "/calculateDet.R"))
source(paste0(scriptDir, "/calculateDistance.R"))
source(paste0(scriptDir, "/compareModels.R"))
source(paste0(scriptDir, "/constants.R"))
source(paste0(scriptDir, "/convertBinary.R"))
source(paste0(scriptDir, "/generateModels.R"))
source(paste0(scriptDir, "/generateXSet.R"))
source(paste0(scriptDir, "/generateY.R"))
source(paste0(scriptDir, "/getBetas.R"))
source(paste0(scriptDir, "/getPredictors.R"))
source(paste0(scriptDir, "/modelBySimilarity.R"))
source(paste0(scriptDir, "/modelToStr.R"))
source(paste0(scriptDir, "/searchModel.R"))
source(paste0(scriptDir, "/seedGenerator.R"))
source(paste0(scriptDir, "/simulator.R"))
source(paste0(scriptDir, "/strToModel.R"))


###################
## INPUT PARAMETERS
###################
## Number of replications
## Default: 100
replications <- 100

## Length of the simulation
## Default: 10000
timesteps <- 1e3

## Number of factors
## Default: 3
k <- 3

## Sigma (Error variance)
## Default: 0.2
sigma <- 0.2

## Sample size
## Default: 100
sampleSize <- 100

##
## Generate all possible linear regression models with k number of factors
##
## The linear regression models are represented in a matrix where columns
## represent the factors and each row represent the terms. Cells with value 1
## indicate the factor in each term.
##
## Example: The following matrix represents the linear regression model
##          x1 + x2 + x3 + x1x2 + x1x3
##
##      1   0   0
##      0   1   0
##      0   0   1
##      1   1   0
##      1   0   1
##
models <- generateModels(k)

## Identify the number of predictors of each model
predictors <- getPredictors(models, k)

## Generate Betas
fModel <- t(as.matrix(models[[1]]))
for(model in models){
  
  if(!is.matrix(model)){
    model <- t(as.matrix(model))
  }
  
  if(nrow(model) > nrow(fModel)){
    fModel <- model
  }
}
beta <- c(1, rep(1, nrow(fModel)))
#betas <- cbind(0, beta[1])
betas <- cbind(0, 0)

f <- 10^((k-1):0)
for(r in 1:nrow(fModel)){
  index <- sum(fModel[r,] * f)
  betas <- rbind(betas, cbind(as.numeric(index), as.numeric(beta[r + 1])))
}

## True model
tModel <- strToModel("x1+x2+x3", k)

## Correlation
correlation <- 0.2

## Number of replicators
nRay <- 1

## Number of robusts (add or removes terms)
nRob <- 1

## Number of robusts (add interactions)
nBob <- 1

## Number of novel (random select a model)
nNel <- 1

##
## Model comparison
##
## TSTATISTICS    T Statistic
## RSQ            R-Squared
## ARSQ           Adjusted R-Squared
## AIC            Akaike Information Criterion
##
modelCompare <- AIC

## Output filename
if(modelCompare == TSTATISTICS){
  outputFile <- "output-tstatistics.csv"
} else if(modelCompare == RSQ){
  outputFile <- "output-rsq.csv"
} else if(modelCompare == ARSQ){
  outputFile <- "output-arsq.csv"
} else if(modelCompare == AIC){
  outputFile <- "output-aic.csv"
}

## Verbose mode
verbose <- TRUE

## Number of decimal places
ndec <- 4


###################
## SET SEED
###################
seeds <- seedGenerator(replications, paste0(inputDir, "/seeds.csv"))


###################
## SIMULATION
###################
simulator(replications, timesteps, models, k, tModel,
    nRay, nRob, nBob, nNel, betas, sampleSize, correlation, sigma, 
    modelCompare, inputDir, outputDir, verbose, ndec, seeds)
