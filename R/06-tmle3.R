## ----cv_fig4, echo = FALSE----------------------------------------------------
knitr::include_graphics("img/misc/TMLEimage.pdf")


## ----tmle3-load-data----------------------------------------------------------
library(data.table)
library(tmle3)
library(sl3)
ist_data <- data.table(read.csv("https://raw.githubusercontent.com/tlverse/deming2019-workshop/master/data/ist_sample.csv"))


## ----tmle3-node-list----------------------------------------------------------
node_list <- list(
  W = c(
    "RXHEP", "REGION", "RDELAY", "RCONSC", "SEX", "AGE", "RSLEEP", "RVISINF",
    "RCT", "RATRIAL", "RASP3", "MISSING_RATRIAL_RASP3", "RHEP24", 
    "MISSING_RHEP24", "RSBP", "RDEF1", "RDEF2", "RDEF3", "RDEF4", "RDEF5",
    "RDEF6", "RDEF7", "RDEF8", "STYPE"
    ),
  A = "RXASP",
  Y = "DRSISC"
)


## ----tmle3-process_missing----------------------------------------------------
head(ist_data)


## ----tmle3-process_missing-broken, echo=FALSE, eval=FALSE---------------------
## processed <- process_missing(ist_data, node_list, complete_nodes = "A",
##                              impute_nodes = "W")
## ist_data_processed <- processed$data
## node_list_processed <- processed$node_list
## all.equal(data.table(ist_data), ist_data_processed, check.attributes = FALSE)
## all.equal(node_list, node_list_processed)


## ----tmle3-ate-spec-----------------------------------------------------------
ate_spec <- tmle_ATE(
  treatment_level = 1,
  control_level = 0
)


## ----tmle3-learner-list-------------------------------------------------------
# choose base learners
lrnr_mean <- make_learner(Lrnr_mean)
lrnr_glm <- make_learner(Lrnr_glm)
lrnr_xgboost <- make_learner(Lrnr_xgboost)
lrnr_lasso <- make_learner(Lrnr_glmnet)
lrnr_ridge <- make_learner(Lrnr_glmnet, alpha = 0)
lrnr_ranger <- make_learner(Lrnr_ranger)

# default metalearner appropriate to data types
sl_Y <- Lrnr_sl$new(
  learners = list(lrnr_mean, lrnr_glm, lrnr_lasso, lrnr_ridge, lrnr_ranger, 
    lrnr_xgboost)
  )
sl_Delta <- Lrnr_sl$new(
  learners = list(lrnr_mean, lrnr_glm, lrnr_lasso, lrnr_ridge)
  )
sl_A <- Lrnr_sl$new(
  learners = list(lrnr_mean, lrnr_glm)
  )
learner_list <- list(A = sl_A, delta_Y = sl_Delta, Y = sl_Y)


## ----tmle3-spec-fit-----------------------------------------------------------
tmle_fit <- tmle3(ate_spec, ist_data, node_list, learner_list)


## ----tmle3-spec-summary-------------------------------------------------------
print(tmle_fit)
# in most cases the transformation that's applied to tmle3 estimates and 
# inference (psi_transformed) is nothing -- it comes up for estimands like ORs, 
# which are estimated on the log scale
estimates <- tmle_fit$summary$psi_transformed
print(estimates)


## ----tmle3-spec-task----------------------------------------------------------
tmle_task <- ate_spec$make_tmle_task(ist_data, node_list)


## ----tmle3-spec-task-npsem----------------------------------------------------
tmle_task$npsem


## ----tmle3-spec-initial-likelihood--------------------------------------------
initial_likelihood <- ate_spec$make_initial_likelihood(
  tmle_task,
  learner_list
)
print(initial_likelihood)


## ----tmle3-spec-initial-likelihood-estimates----------------------------------
initial_likelihood$get_likelihoods(tmle_task)


## ----tmle3-spec-targeted-likelihood-------------------------------------------
targeted_likelihood <- Targeted_Likelihood$new(initial_likelihood)


## ----tmle3-spec-targeted-likelihood-no-cv-------------------------------------
targeted_likelihood_no_cv <-
  Targeted_Likelihood$new(initial_likelihood,
    updater = list(cvtmle = FALSE)
  )


## ----tmle3-spec-params--------------------------------------------------------
tmle_params <- ate_spec$make_params(tmle_task, targeted_likelihood)
print(tmle_params)


## ----tmle3-manual-fit---------------------------------------------------------
tmle_fit_manual <- fit_tmle3(
  tmle_task, targeted_likelihood, tmle_params,
  targeted_likelihood$updater
)
print(tmle_fit_manual)


## ----tmle3-tsm-all------------------------------------------------------------
tsm_spec <- tmle_TSM_all()
targeted_likelihood <- Targeted_Likelihood$new(initial_likelihood)
all_tsm_params <- tsm_spec$make_params(tmle_task, targeted_likelihood)
print(all_tsm_params)


## ----tmle3-delta-method-param-------------------------------------------------
ate_param <- define_param(
  Param_delta, targeted_likelihood,
  delta_param_ATE,
  list(all_tsm_params[[1]], all_tsm_params[[2]])
)
print(ate_param)


## ----tmle3-tsm-plus-delta-----------------------------------------------------
all_params <- c(all_tsm_params, ate_param)
tmle_fit_multiparam <- fit_tmle3(
  tmle_task, targeted_likelihood, all_params,
  targeted_likelihood$updater
)
print(tmle_fit_multiparam)


## ----stratified_ate, warning = FALSE, message = FALSE-------------------------
stratified_ate_spec <- tmle_stratified(ate_spec, "REGION")
stratified_fit <- tmle3(stratified_ate_spec, ist_data, node_list, learner_list)
print(stratified_fit)


## ----data, message=FALSE, warning=FALSE---------------------------------------
# load the data set
data(cpp)
cpp <- cpp[!is.na(cpp[, "haz"]), ]
cpp$parity01 <- as.numeric(cpp$parity > 0)
cpp[is.na(cpp)] <- 0
cpp$haz01 <- as.numeric(cpp$haz > 0)


## ---- metalrnr-exercise-------------------------------------------------------
metalearner <- make_learner(Lrnr_solnp,
  loss_function = loss_loglik_binomial,
  learner_function = metalearner_logistic_binomial
)

