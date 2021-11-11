## Juho Mononen: Creating the learning2014 dataset. 
## Made a more general approach which can be used with the other +VAR marked variables 
## - described here: https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS2-meta.txt
## - In case we need to use those other variables as well this scipt can calculate them based on the formulas.

## 
outfile <- "learning2014.tsv"
outfolder <- "data"


## Get functions and packages needed for this script
library(tidyverse)
source("iods_functions.R")

dir.create(outfolder)

## read in the table 
df <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = T, sep = "\t")

## check the structure and the dimensions
str(df)
dim(df)

## -------
# observations: The data.frame has 59 integer and 1 character columns with 183 rows.
## -------

## read variables in
var.in <- readLines("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt", )

## select lines by determining start and end, needs to be done manually.
start <- "+VAR d_sm:1=D03+D11+D19+D27"
end <- "+VAR Stra_adj:4=Stra/8"
lines <- which(str_sub(var.in, 1, nchar(start)) == start):which(str_sub(var.in, 1, nchar(end)) == end)

## check that the line interval is indeed correct
var.tmp <- var.in[lines]
print(var.tmp)

## remove +VAR
var.tmp <- gsub("\\+VAR ", "", var.tmp) 
print(var.tmp)

## clean ":1" etc.
var.tmp <- sub(":[0-9]", "", var.tmp) 
print(var.tmp)

## Create var.df
var.df <- data.frame(vars=sub("=.*", "", var.tmp), calcs=sub(".*?=", "", var.tmp), stringsAsFactors = F)
  
## Create data.frame for output
df.out <- df %>% 
  mutate_addCalc(var.df) %>%
  rename_with(str_to_lower) %>%
  dplyr::select(gender, age, attitude, deep_adj, stra_adj, surf_adj, points) %>%
  rename_with( ~ gsub("_adj$", "",.x)) %>% 
  dplyr::filter(points!=0)

## Write output
write.table(df.out, file = paste(outfolder, outfile, sep = "/"), quote = F, sep = "\t", col.names = T)

## Read the output files 
data.back <-read.table(paste(outfolder, outfile, sep = "/"), header = T, sep = "\t", stringsAsFactors = F)

## Checking that the file is good
head(data.back)
str(data.back)

## Seems good
