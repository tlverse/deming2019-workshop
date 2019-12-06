setwd("/Users/linamontoya/Dropbox/archive/252E 2108/RLabs_LMedits2019/Data structures/")
set.seed(252)

##########################
#### DATA STRUCTURE 0 ####
##########################

generate_data0 = function(n){
  
  L1 = rbinom(n,1,0.5)
  A1 = rbinom(n,1,plogis(0.3-L1))
  L2 = rbinom(n,1,plogis(-2+1.8*A1+2*L1))
  A2 = rbinom(n,1,plogis(L2+L1))
  Y = rbinom(n,1,plogis(-3+1.3*A1+1.7*A2+1.3*L1+1.7*L2))
  
  O = data.frame(L1, A1, L2, A2, Y)
  return(O)
  
}

generate_data0_intervene = function(n){
  
  L1 = rbinom(n,1,0.5)
  A1 = 1
  L2 = rbinom(n,1,plogis(-2+1.8*A1+2*L1))
  A2 = 1
  Y = rbinom(n,1,plogis(-3+1.3*A1+1.7*A2+1.3*L1+1.7*L2))
  
  X = data.frame(L1, A1, L2, A2, Y)
  return(X)
  
}


ObsData0 = generate_data0(1000)
X = generate_data0_intervene(10000000)
Psi.F0 = mean(X$Y)
save(generate_data0, generate_data0_intervene, Psi.F0, ObsData0, file = "../Data structures/DataStructure0.RData")

###################################
#### DATA STRUCTURE 0 WITH DTR ####
###################################

generate_data0_dtr = function(n) {
  
  L1 = rnorm(n)
  A1 = rbinom(n, 1, plogis(0.01*(L1)))
  L2 = 0.5*L1 + 0.7*A1 + rnorm(n)
  A2 = rbinom(n, 1, plogis(0.01*(L2+A1+L1)))
  Y = rbinom(n, 1, plogis(3*L1*A1 + 3*L2*A2))
  
  O = data.frame(L1, A1, L2, A2, Y)
  
  return(O)
}

generate_data0_dtr_intervene = function(n, abar) {
  
  L1 = rnorm(n)
  if (abar == "DTR") {
    A1 = as.numeric(L1 < 0)
  } else {
    A1 = abar[1]
  }
  L2 = 0.5*L1 + 0.7*A1 + rnorm(n)
  if (abar == "DTR") {
    A2 = as.numeric(L2 < 0)
  } else {
    A2 = abar[1]
  }
  Y = rbinom(n, 1, plogis(3*L1*A1 + 3*L2*A2))
  
  X = data.frame(L1, A1, L2, A2, Y)
  
  return(X)
}



X = generate_data0_dtr_intervene(n = 1000000, abar = "DTR")
Psi.F0_dtr = mean(X$Y)
ObsData0_dtr = generate_data0_dtr(n = 1000)

save(Psi.F0_dtr, ObsData0_dtr, generate_data0_dtr, generate_data0_dtr_intervene, file = "../Data structures/DataStructure0_dtr.RData")


##########################
#### DATA STRUCTURE 1 ####
##########################


generate_data1 = function(n) {
  
  # exogenous variables
  U.W = runif(n, min=0, max=1)
  U.A = runif(n, min=0, max=1)
  U.L = rnorm(n, mean=2, sd=1)
  U.Delta = runif(n, min=0, max=1)
  U.Y = rnorm(n, mean=72, sd=0.3)
  
  # endogenous variables
  W = U.W
  A = as.numeric(U.A < plogis(0.01*W))
  L = W + A + U.L
  Delta = as.numeric(U.Delta < plogis(0.01*(W + A + L)))
  DeltaY = ifelse(Delta == 0, NA, L + 5*A + 3*W - 0.25*A*W + U.Y)
  
  # store all variables in dataframe
  O = data.frame(W, A, L, Delta, DeltaY)
  
  return(O)
}

ObsData1 = generate_data1(1000)

generate_data1_intervene = function(n, a, delta) {
  
  # exogenous variables
  U.W = runif(n, min=0, max=1)
  U.A = runif(n, min=0, max=1)
  U.L = rnorm(n, mean=2, sd=1)
  U.Delta = runif(n, min=0, max=1)
  U.Y = rnorm(n, mean=72, sd=0.3)
  
  
  # endogenous variables
  W = U.W
  A = a # intervention on A
  L = W + A + U.L
  Delta = rep(delta, n) # intervention on Delta
  Y = L + 5*A + 3*W - 0.25*A*W + U.Y
  DeltaY = ifelse(Delta == 0, NA, Y)
  
  # store all variables in dataframe
  X = data.frame(W, A, L, Delta, Y, DeltaY)
  
  return(X)
}

X1_1 = generate_data1_intervene(n = 100000, a = 1, delta = 1)
X1_0 = generate_data1_intervene(n = 100000, a = 0, delta = 1)

Psi.F1 = mean(X1_1$DeltaY) - mean(X1_0$DeltaY)

save(ObsData1, generate_data1, Psi.F1, generate_data1_intervene, file = "../Data structures/DataStructure1.RData")

##########################
#### DATA STRUCTURE 2 ####
##########################
generate_data2 = function(n) {
  
  # exogenous variables
  U.L1 = rnorm(n, mean=0, sd=1)
  U.A1 = runif(n, min=0, max=1)
  U.L2 = rnorm(n, mean=0, sd=1)
  U.A2 = runif(n, min=0, max=1)
  U.L3 = rnorm(n, mean=0, sd=1)
  U.A3 = runif(n, min=0, max=1)
  U.L4 = rnorm(n, mean=0, sd=1)
  U.A4 = runif(n, min=0, max=1)
  U.Y = rnorm(n, mean=72, sd=3)
  
  # endogenous variables
  L1 = U.L1
  A1 = as.numeric(U.A1 < plogis(0.001*L1))
  L2 = A1 + L1 + U.L2
  A2 = as.numeric(U.A2 < plogis(0.001*(L2+A1 + L1)))
  L3 = A1 + L1 + A2 + L2 + U.L3
  A3 = as.numeric(U.A3 < plogis(0.001*(L1 + A1 + L2 + A2 + L3)))
  L4 = A1 + L1 + A2 + L2 + A3 + L3 + U.L4
  A4 = as.numeric(U.A4 < plogis(0.001*(L1 + A1 + L2 + A2 + L3 + A3 + L4))) 
  
  Y = 0.3*L1 + A1 + 0.5*L2 + A2 + 0.7*L3 + A3 + L4 + A4 - U.Y + 130
  
  O = data.frame(L1, A1, L2, A2, L3, A3, L4, A4, Y)
  
  return(O)
}

generate_data2_intervene <- function(n, abar) {
  
  # exogenous variables
  U.L1 = rnorm(n, mean=0, sd=1)
  U.A1 = runif(n, min=0, max=1)
  U.L2 = rnorm(n, mean=0, sd=1)
  U.A2 = runif(n, min=0, max=1)
  U.L3 = rnorm(n, mean=0, sd=1)
  U.A3 = runif(n, min=0, max=1)
  U.L4 = rnorm(n, mean=0, sd=1)
  U.A4 = runif(n, min=0, max=1)
  U.Y = rnorm(n, mean=72, sd=3)
  
  # endogenous variables
  L1 = U.L1
  A1 = abar[1]
  L2 = A1 + L1 + U.L2
  A2 = abar[2]
  L3 = A1 + L1 + A2 + L2 + U.L3
  A3 = abar[3]
  L4 = A1 + L1 + A2 + L2 + A3 + L3 + U.L4
  A4 = abar[4]
  Y = 0.3*L1 + A1 + 0.5*L2 + A2 + 0.7*L3 + A3 + L4 + A4 - U.Y + 130
  
  O = data.frame(L1, A1, L2, A2, L3, A3, L4, A4, Y)
  
  return(O)
}

X2_1111 = generate_data2_intervene(n=100000, abar = c(1, 1, 1, 1))
X2_0000 = generate_data2_intervene(n=100000, abar = c(0, 0, 0, 0))
Psi.F2 = mean(X2_1111$Y) - mean(X2_0000$Y)


# MSM without weights
abar_mat = expand.grid(c(0,1), c(0,1), c(0,1), c(0,1))
colnames(abar_mat) = c("A1", "A2", "A3", "A4")
sum.abar = EY.abar = rep(NA, 16)
for(i in 1:16) {
    X = generate_data2_intervene(100000, abar = as.numeric(abar_mat[i,]))
    sum.abar[i] = rowSums(abar_mat)[i]
    EY.abar[i] = mean(X$Y)
}
MSM = glm(EY.abar ~ sum.abar)
TrueMSMbeta1 = MSM$coefficients[[2]]

# MSM with weights
ObsData2 = generate_data2(n=100000)
g.abar = rep(NA, 16)
for(i in 1:16){
    # marginal probability
    marg.prob = mean(ObsData2$A1 == abar_mat[i,1] &
                       ObsData2$A2 == abar_mat[i,2] &
                       ObsData2$A3 == abar_mat[i,3] &
                       ObsData2$A4 == abar_mat[i,4])
    # assign to subject in vector g.abar
    g.abar[i] = marg.prob
}
MSM_wts = glm(EY.abar ~ sum.abar, weights = g.abar)
TrueMSMbeta1_wts = MSM_wts$coefficients[[2]]


ObsData2 = generate_data2(n=1000)

save(ObsData2, generate_data2, Psi.F2,generate_data2_intervene, TrueMSMbeta1, TrueMSMbeta1_wts, file = "../Data structures/DataStructure2.RData")

##########################
#### DATA STRUCTURE 3 ####
##########################

generate_data3 = function(n) {
  
  # exogenous variables
  U.L1 = rnorm(n, mean=0, sd=1)
  U.A1 = runif(n, min=0, max=1)
  U.Y2 = runif(n, min=0, max=1)
  U.L2 = rnorm(n, mean=0, sd=1)
  U.A2 = runif(n, min=0, max=1)
  U.Y3 = runif(n, min=0, max=1)
  
  # endogenous variables
  L1 = U.L1
  A1 = as.numeric(U.A1 < plogis(.001*L1))
  Y2 = as.numeric(U.Y2 < plogis(L1 - 2*A1 - 6))
  L2 = ifelse(Y2 == 1, NA, A1 + L1 + U.L2)
  A2 = ifelse(Y2 == 1, NA, as.numeric(U.A2 < plogis(0.001*(L1 + A1 + L2))))
  Y3 = ifelse(Y2 == 1, 1, as.numeric(U.Y3 < plogis(L1 - 2*A1 + L2 - A2)))
  
  O = data.frame(L1, A1, Y2, L2, A2, Y3)
  
  return(O)
  
}

generate_data3_intervene = function(n, abar) {
  
  # exogenous variables
  U.L1 = rnorm(n, mean=0, sd=1)
  U.A1 = runif(n, min=0, max=1)
  U.Y2 = runif(n, min=0, max=1)
  U.L2 = rnorm(n, mean=0, sd=1)
  U.A2 = runif(n, min=0, max=1)
  U.Y3 = runif(n, min=0, max=1)
  
  # endogenous variables
  L1 = U.L1
  A1 = abar[1]
  Y2 = as.numeric(U.Y2 < plogis(L1 - 2*A1 - 6))
  L2 = ifelse(Y2 == 1, NA, A1 + L1 + U.L2)
  A2 = abar[2]
  Y3 = ifelse(Y2 == 1, 1, as.numeric(U.Y3 < plogis(L1 - 2*A1 + L2 - A2)))
  
  X = data.frame(L1, A1, Y2, L2, A2, Y3)
  
  return(X)
  
}

ObsData3 = generate_data3(n = 1000)
X3_11 = generate_data3_intervene(n = 100000, abar = c(1, 1))
X3_00 = generate_data3_intervene(n = 100000, abar = c(0, 0))
Psi.F3 = mean(X3_11$Y3) - mean(X3_00$Y3)
save(ObsData3, generate_data3, generate_data3_intervene, generate_data3_intervene, Psi.F3, file = "../Data structures/DataStructure3.RData")



##########################
#### DATA STRUCTURE 4 ####
##########################
generate_data4 = function(n) {
  
  # exogenous variables
  U.L1 = rnorm(n, mean=0, sd=1)
  U.C1 = runif(n, min=0, max=1)
  U.A1 = runif(n, min=0, max=1)
  U.Y2 = runif(n, min=0, max=1)
  U.L2 = rnorm(n, mean=0, sd=1)
  U.C2 = runif(n, min=0, max=1)
  U.A2 = runif(n, min=0, max=1)
  U.Y3 = runif(n, min=0, max=1)
  
  # endogenous variables
  L1 = U.L1
  C1 = as.numeric(U.C1 < plogis(.001*L1 - 2))
  A1 = ifelse(C1 == 1, NA, as.numeric(U.A1 < plogis(.001*L1)))
  Y2 = as.numeric(U.Y2 < plogis(L1 - 2*A1 - 6))
  L2 = ifelse(Y2 == 1, NA, A1 + L1 + U.L2)
  C2 = as.numeric(U.C2 < plogis(.001*(L1 + A1 + L2) - 2))
  A2 = ifelse(Y2 == 1 | C2 == 1, NA, as.numeric(U.A2 < plogis(0.001*(L1 + A1 + L2))))
  Y3 = ifelse(Y2 == 1, 1, as.numeric(U.Y3 < plogis(L1 - 2*A1 + L2 - A2)))
  
  O = data.frame(L1, C1, A1, Y2, L2, C2, A2, Y3)
  
  return(O)
  
}



generate_data4_intervene = function(n, abar, cbar) {
  
  # exogenous variables
  U.L1 = rnorm(n, mean=0, sd=1)
  U.C1 = runif(n, min=0, max=1)
  U.A1 = runif(n, min=0, max=1)
  U.Y2 = runif(n, min=0, max=1)
  U.L2 = rnorm(n, mean=0, sd=1)
  U.C2 = runif(n, min=0, max=1)
  U.A2 = runif(n, min=0, max=1)
  U.Y3 = runif(n, min=0, max=1)
  
  # endogenous variables
  L1 = U.L1
  C1 = rep(cbar[1], n) # intervention on C1
  A1 = abar[1] # intervention on A1
  Y2 = as.numeric(U.Y2 < plogis(L1 - 2*A1 - 6))
  L2 = ifelse(Y2 == 1, NA, A1 + L1 + U.L2)
  C2 = rep(cbar[2], n) # intervention on C2
  A2 = abar[2] # intervention on A2
  Y3 = ifelse(Y2 == 1, 1, as.numeric(U.Y3 < plogis(L1 - 2*A1 + L2 - A2)))
  
  X = data.frame(L1, C1, A1, Y2, L2, C2, A2, Y3)
  
  return(X)
  
}

ObsData4 = generate_data4(n = 1000)
X4_11 = generate_data4_intervene(n = 100000, abar = c(1, 1), cbar = c(0, 0))
X4_00 = generate_data4_intervene(n = 100000, abar = c(0, 0), cbar = c(0, 0))
Psi.F4 = mean(X4_11$Y3) - mean(X4_00$Y3)
save(ObsData4, generate_data4, generate_data4_intervene, Psi.F4, file = "../Data structures/DataStructure4.RData")



