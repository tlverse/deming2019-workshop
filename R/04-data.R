## ----load_ist_data_intro, message=FALSE, warning=FALSE------------------------
library(tidyverse)

# read in data
ist <- read_csv("https://raw.githubusercontent.com/tlverse/deming2019-workshop/master/data/ist_sample.csv")
ist


## ----skim_ist_data, message=FALSE, warning=FALSE------------------------------
library(skimr)
skim(ist)


## ----load_washb_data_intro, message=FALSE, warning=FALSE----------------------
library(tidyverse)

# read in data
dat <- read_csv("https://raw.githubusercontent.com/tlverse/tlverse-data/master/wash-benefits/washb_data.csv")
dat


## ----skim_washb_data, message=FALSE, warning=FALSE----------------------------
skim(dat)


## ----load_vet_data_intro, message=FALSE, warning=FALSE------------------------
library(tidyverse)

# read in data
vet <- read_csv("https://raw.githubusercontent.com/tlverse/deming2019-workshop/master/data/veteran.csv")
vet


## ----skim_vet_data, message=FALSE, warning=FALSE------------------------------
skim(vet)

