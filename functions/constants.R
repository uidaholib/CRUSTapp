################
##
## @description Define constants
##
## @param None
##
## @return None
##
## @lastChange 2016-12-28
##
## @changes
##
################

## Types of agents
RAY <- 1
ROB <- 2
BOB <- 3
NEL <- 4

## Model comparison
TSTATISTICS <- 1
RSQ <- 2
ARSQ <- 3
AIC <- 4

## Model output fields
O_NUM_FIELDS <- 20
O_STRATEGY <- 1
O_SELECTED_MODEL <- 2
O_SELECTED_TRUE_MODEL <- 3
O_SELECTED_MODEL_DISTANCE <- 4
O_INITIAL_GLOBAL_MODEL <- 5
O_INITIAL_GLOBAL_TRUE_MODEL <- 6
O_INITIAL_GLOBAL_MODEL_DISTANCE <- 7
O_FINAL_GLOBAL_MODEL <- 8
O_FINAL_GLOBAL_TRUE_MODEL <- 9
O_FINAL_GLOBAL_MODEL_DISTANCE <- 10
O_NUM_PREDICTORS <- 11
O_SAMPLE_SIZE <- 12
O_BETA1_ESTIMATE <- 13
O_BETA1_ERROR <- 14
O_TSTATISTICS <- 15
O_RSQ <- 16
O_ARSQ <- 17
O_AIC <- 18
O_REPLICATED <- 19
O_PREDICTORS <- 20

## File output headers
OUTPUT_HEADER <- c("replica",
                   "timestep",
                   "strategy",
                   "selected_model",
                   "selected_true_model",
                   "selected_model_distance",
                   "initial_global_model",
                   "initial_global_true_model",
                   "initial_global_model_distance",
                   "final_global_model",
                   "final_global_true_model",
                   "final_global_model_distance",
                   "num_predictors",
                   "sample_size",
                   "beta1_estimate",
                   "beta1_error",
                   "tStatistics",
                   "RSQ",
                   "ARSQ",
                   "AIC",
                   "replicated",
                   "predictors")
