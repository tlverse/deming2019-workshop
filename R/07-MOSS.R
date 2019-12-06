## ----moss-0, message=FALSE, warning=FALSE-------------------------------------
library(MOSS)

vet_data <- read.csv("https://raw.githubusercontent.com/tlverse/deming2019-workshop/master/data/veteran.csv")
head(vet_data)


## ----moss-1, message=FALSE, warning=FALSE-------------------------------------
T_tilde <- vet_data$time
Delta <- vet_data$status
A <- vet_data$trt
W <- vet_data[, c(3, 6:9)]
t_max <- max(T_tilde)


## ----moss-2, message=FALSE, warning=FALSE, cache = TRUE-----------------------
# recall treatment was randomized
SL.ranger.faster = function(...) {
  SL.ranger(..., num.trees = 50)
}
sl_lib_decent <- c("SL.mean", "SL.glm", "SL.step.forward", "SL.bayesglm", 
                   "SL.ranger.faster", "SL.gam")

initial_fit <- initial_sl_fit(T_tilde, Delta, A, W, t_max, 
                              sl_censoring = sl_lib_decent, 
                              sl_failure = sl_lib_decent)

names(initial_fit)


## ---- moss-2-transform, warning=FALSE, message=FALSE--------------------------
initial_fit$density_failure_1$hazard_to_survival()
initial_fit$density_failure_0$hazard_to_survival()


## ----moss-3-kgrid, message=FALSE, warning=FALSE-------------------------------
k_grid <- 1:max(T_tilde)
initial_fit$density_failure_1$t <- k_grid
initial_fit$density_failure_0$t <- k_grid


## ----moss-3-standard, warning=FALSE, message=FALSE, cache = TRUE--------------
# estimate survival curve for standard treatment group
hazard_fit_standardA <- MOSS_hazard$new(
  A,
  T_tilde,
  Delta,
  density_failure = initial_fit$density_failure_0,
  density_censor = initial_fit$density_censor_0,
  g1W = initial_fit$g1W,
  A_intervene = 1,
  k_grid
)
psi_standardA <- hazard_fit_standardA$iterate_onestep()

## ----moss-3-test, warning=FALSE, message=FALSE, cache = TRUE------------------
# estimate survival curve for test treatment group
hazard_fit_testA <- MOSS_hazard$new(
  A,
  T_tilde,
  Delta,
  density_failure = initial_fit$density_failure_1,
  density_censor = initial_fit$density_censor_1,
  g1W = initial_fit$g1W,
  A_intervene = 2,
  k_grid
)
psi_testA <- hazard_fit_testA$iterate_onestep()


## ----moss-3-ate, warning=FALSE, message=FALSE, cache = TRUE-------------------
hazard_fit_ate <- MOSS_hazard_ate$new(
  A,
  T_tilde,
  Delta,
  density_failure = initial_fit$density_failure_1,
  density_censor = initial_fit$density_censor_1,
  density_failure_0 = initial_fit$density_failure_0,
  density_censor_0 = initial_fit$density_censor_0,
  initial_fit$g1W
)
psi_ate <- hazard_fit_ate$iterate_onestep()
summary(psi_ate)


## ----moss-4-standard, cache = TRUE--------------------------------------------
# estimate and obtain inference for survival curve for standard treatment group
survival_standardA <- survival_curve$new(t = k_grid, survival = psi_standardA)
survival_curve_standardA <- as.vector(survival_standardA$survival)

eic_standardA <- eic$new(
  A = A,
  T_tilde = T_tilde,
  Delta = Delta,
  density_failure = hazard_fit_standardA$density_failure,
  density_censor = hazard_fit_standardA$density_censor,
  g1W = hazard_fit_standardA$g1W,
  psi = survival_curve_standardA,
  A_intervene = hazard_fit_standardA$A_intervene
)
eic_matrix_standardA <- eic_standardA$all_t(k_grid = k_grid)
std_err_standardA <- compute_simultaneous_ci(eic_matrix_standardA)
upper_bound_standardA <- survival_curve_standardA + (1.96*std_err_standardA)
lower_bound_standardA <- survival_curve_standardA - (1.96*std_err_standardA)

plotdf_standardA <- data.frame(time = k_grid, est = survival_curve_standardA, 
                               upper = upper_bound_standardA, 
                               lower = lower_bound_standardA, 
                               type = rep("standard", length(k_grid)))

plot_standardA <- ggplot(data = plotdf_standardA, aes(x = time, y = est)) + 
  geom_line() +
  geom_ribbon(data = plotdf_standardA, aes(ymin = lower, ymax = upper), 
              alpha = 0.5) +
  ggtitle("Treatment-Specific Survival Curves Among Standard Treatment Group in
           Veterans’ Administration Lung Cancer Trial")
plot_standardA


## ----moss-4-test, cache = TRUE------------------------------------------------
# estimate and obtain inference for survival curve for test treatment group
survival_testA <- survival_curve$new(t = k_grid, survival = psi_testA)
survival_curve_testA <- as.vector(survival_testA$survival)

eic_testA <- eic$new(
  A = A,
  T_tilde = T_tilde,
  Delta = Delta,
  density_failure = hazard_fit_testA$density_failure,
  density_censor = hazard_fit_testA$density_censor,
  g1W = hazard_fit_testA$g1W,
  psi = survival_curve_testA,
  A_intervene = hazard_fit_testA$A_intervene
)
eic_matrix_testA <- eic_testA$all_t(k_grid = k_grid)
std_err_testA <- compute_simultaneous_ci(eic_matrix_testA)
upper_bound_testA <- survival_curve_testA + (1.96*std_err_testA)
lower_bound_testA <- survival_curve_testA - (1.96*std_err_testA)

plotdf_testA <- data.frame(time = k_grid, est = survival_curve_testA, 
                           upper = upper_bound_testA, lower = lower_bound_testA, 
                           type = rep("test", length(k_grid)))

plot_testA <- ggplot(data = plotdf_testA, aes(x = time, y = est)) + 
  geom_line() +
  geom_ribbon(data = plotdf_testA, aes(ymin = lower, ymax = upper), alpha = 0.5) +
  ggtitle("Treatment-Specific Survival Curves Among Test Treatment Group in
           Veterans’ Administration Lung Cancer Trial")
plot_testA


## ----moss-4-ate-broken, eval=FALSE, echo=FALSE--------------------------------
## # estimate survival curve for ate
## survival_ate <- survival_curve$new(t = k_grid, survival = psi_ate)
## survival_ate$display(type = 'survival')
## 
## eic_ate <- eic$new(
##   A = A,
##   T_tilde = T_tilde,
##   Delta = Delta,
##   density_failure = hazard_fit_ate$density_failure,
##   density_censor = hazard_fit_ate$density_censor,
##   g1W = hazard_fit_ate$g1W,
##   psi = survival_curve_ate,
##   A_intervene = NULL
## )
## # TO-DO: fix simultaneous inference for ATE
## eic_matrix_ate <- eic_ate$all_t(k_grid = k_grid)
## std_err_testA <- compute_simultaneous_ci(eic_matrix_testA)
## upper_bound_testA <- survival_curve_testA + 1.96 * std_err_testA
## lower_bound_testA <- survival_curve_testA - 1.96 * std_err_testA
## 
## plotdf_testA <- data.frame(est = survival_curve_testA,
##                                upper = upper_bound_testA,
##                                lower = lower_bound_testA,
##                                time = k_grid,
##                                type = rep("test", length(k_grid)))
## 
## plotdf <- rbind.data.frame(plotdf_standardA, plotdf_testA)

