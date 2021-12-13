## Datawrangling for RATS and BPRS
## Juho Mononen, 12.12.2021

library(tidyverse)

# reading in 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = T)
# view structure
str(BPRS)
## the data is in wide format, as in variables for subjects are separated by weeks into several columns
## treatment describes the index for treatments and subjects respectively for patient or similar. These are then followed by 9 week columns starting from 0


# reading in 
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = T)
# view structure
str(RATS)
## Similar to before. ID and group columns followed by weekday columns

## 2-3. steps for both
BPRS.out <- BPRS %>% mutate_at(1:2, as.factor)  %>% 
  gather(key = "weeks", value = "bprs", -treatment, -subject) %>%
  mutate(week =as.integer(substr(weeks,5,5)))
RATS.out <- RATS %>% mutate_at(1:2, as.factor)  %>%
  gather(key = "WD", value = "Weight", -ID, -Group) %>%
  mutate(Time=as.integer(substr(WD,3,5)))

## check structure for both
str(BPRS.out)
str(RATS.out)

## Values for both are as expected with "guide variables" (treatment & subject for BPRS and ID & Group for RATS) 
## ...categorizing the time series data (measurement points for ) for RATS, weights by Time variable, and for BPRS, bprs by week variable.
## With both we have now concentrated the time series values over multiple columns to one and guide them with time points as a variable inb one column. 
## This is the format e.g. ggplot expects for data when using base functions of it along with other R functions.

# save both 
write.table(BPRS.out, "Data/BPRS.tsv", row.names = F, quote = F)
write.table(RATS.out, "Data/RATS.tsv", row.names = F, quote = F)