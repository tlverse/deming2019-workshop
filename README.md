# Targeted Learning Workshops at 2019 Deming Conference on Applied Statistics

Welcome to the GitHub repository accompanying the half-day tutorial and 2-day 
short course on Targeted Learning, given at the Deming Conference on Applied 
Statistics, December 4-6, 2019. 

## Half-Day Tutorial on December 4, 2019

* 9:00A-10:30A: Overview of Targeted (Machine) Learning 
* 10:30A-10:45P: Break
* 10:45A-12:00P: TMLE for the Causal Impact of a Single 
      Time-Point Intervention on Survival with Software Exercise in `R`

## 2-Day Short Course on December 5-6, 2019
### Day 1: December 5, 2019  

* 8:00A-9:30A: Overview of Targeted (Machine) Learning 
* 9:30A-9:50A: Break
* 9:50A-11:20P: Causal Inference and Interventions
* 11:20A-12:40P: Lunch
* 12:40P-2:10P: Super (Machine) Learning and Targeted Minimum Loss-Based 
  Estimation 
* 2:10P-2:30P: Break
* 2:30P-4:10P: Super Learning in the `tlverse` software ecosystem
* 4:10P-4:40P: Break
* 4:40P-5:50P: Super Learning in the `tlverse` software ecosystem

### Day 2: December 6, 2019  

* 8:00A-9:30A: Targeted Maximum Likelihood Estimation
* 9:30A-10:00A: Break
* 10:00A-11:20A: Targeted Maximum Likelihood Estimation of the Average Treatment 
  Effect in the `tlverse` software ecosystem
* 11:20A-11:40A: Lunch
* 11:40A-1:10P: Targeted Minimum Loss-Based Estimation of Time-to-Event 
  Outcomes with `MOSS` and Targeted Minimum Loss-Based Estimation for 
  Longitudinal Data with `ltmle`

Most of the software materials are based on an 
early draft of the (eventually forthcoming) book **The Hitchhiker's Guide to the 
`tlverse`, or a Targeted Learning Practitioner's Handbook**, by Mark van der 
Laan, Alan Hubbard, Jeremy Coyle, Nima Hejazi, Ivana Malenica, and Rachael 
Phillips. For a work-in-progress draft of the unabridged book, please see 
https://tlverse.org/tlverse-handbook or the associated GitHub 
repository: https://github.com/tlverse/tlverse-handbook.

[![Travis-CI Build Status](https://travis-ci.com/tlverse/deming2019-workshop.svg?branch=master)](https://travis-ci.com/tlverse/deming2019-workshop)
Note: `travis-ci` currently deploys the developmental version of this workshop
handbook into the `gh-pages` branch of this repository, which is hosted by
GitHub Pages at https://tlverse.org/deming2019-workshop.

The software materials are automatically built and deployed using
[Binder](https://github.com/jupyterhub/binderhub), which supports using R
and RStudio, with libraries pinned to a specific snapshot on
[MRAN](https://mran.microsoft.com/documents/rro/reproducibility). An
RStudio session, pre-loaded with all the materials, is available via
[![Binder](http://mybinder.org/badge_logo.svg)](http://mybinder.org/v2/gh/tlverse/deming2019-workshop/master?urlpath=rstudio)
