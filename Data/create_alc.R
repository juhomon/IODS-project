## Juho Mononen, 19.11.2011, Creating the alc dataset. 
## Data was obtained from here https://archive.ics.uci.edu/ml/machine-learning-databases/00320/

outfile <- "alc.tsv"
outfolder <- "data"

library(tidyverse)
## Functions included in the script fo convenience
#source("iods_functions.R")

## read file and check structure
por <- read.csv("Data/student-por.csv", sep = ";")
str(por)
dim(por)

## read file and check structure
mat <- read.csv("Data/student-mat.csv", sep = ";")
str(mat)
dim(mat)

## get all unique col names
colnames.both <- unique(colnames(por), colnames(mat))

## Set colnames to join by and variable colnames
vars <- c("failures", "paid", "absences", "G1", "G2", "G3")
join_by <- setdiff(colnames.both, vars)

## Then off to joining
## I don't see why we could not use inner join here?
## If we assume that the columns in join_by for the IDs for students then we should not after using inner_join()
## by those columns (=ID) have any duplicate rows for students. Also only those IDs that are present in both are kept.
## We do however have "duplicate" columns but that we can deal with later.
joined <- inner_join(por, mat, by=join_by, suffix=c(".p",".m"))

## now we just need to calculate means for the values with suffixes 
## We can use this function to do it
## It takes three arguments 
## 1. Data.frame
## 2. Variable names that can be found in columns 
## 3. Extension suffix for character columns by which to select "first"
mutate_ex3 <- function(df,vars,ext) {
  ## df to tmp for looped appending
  tmp <- df 
  ## In datacamp and Reijo's instruction means were taken for numeric and for character first observation
  ## (which by index numbering in Reijo's instruction was from por)
  for (i in 1:length(vars)) {
    ## Select variable to study 
    tmp.var <- vars[i]
    ## Check if it is numeric or not 
    test.num <- lapply(select(tmp, contains(tmp.var)), is.numeric) %>% unlist() %>% unique()
    ## If numeric calculate mean from columns that have the character string 
    if (test.num==T) {
      tmp <- tmp %>% mutate({{tmp.var}} := round(rowMeans(select(tmp, contains(tmp.var)))))
      ## If character take the por option
    } else {
      tmp <- tmp %>% mutate({{tmp.var}} := last(select(tmp, contains(paste0(tmp.var,ext)))))
    }
  }
  return(tmp)
}

## lets do the calculations 
out <-joined %>% 
  mutate_ex3(vars, ".p") %>%
  ## And calculate rest of the variables
  mutate(alc_use = (Dalc + Walc) / 2,
         high_use = alc_use > 2)

## lets have a look
glimpse(out)
## Looks good 

## save to a file
write.table(out, file = paste(outfolder, outfile, sep = "/"), quote = F, sep = "\t", col.names = T)