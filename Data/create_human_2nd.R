## Juho Mononen
## Further edits on the human.tsv dataset.
## Original data from: http://hdr.undp.org/en/content/human-development-index-hdi

library(tidyverse)

## Load the previous human.tsv
human <- read.delim("Data/human.tsv", header = T, sep = "\t", stringsAsFactors = F)

str(human)
# 'data.frame':	195 obs. of  19 variables:
#   $ HDIrank    : int  1 2 3 4 5 6 6 8 9 9 ...
# $ country    : chr  "Norway" "Australia" "Switzerland" "Denmark" ...
# $ HDI        : num  0.944 0.935 0.93 0.923 0.922 0.916 0.916 0.915 0.913 0.913 ...
# $ lifeExp    : num  81.6 82.4 83 80.2 81.6 80.9 80.9 79.1 82 81.8 ...
# $ edExp      : num  17.5 20.2 15.8 18.7 17.9 16.5 18.6 16.5 15.9 19.2 ...
# $ edMean     : num  12.6 13 12.8 12.7 11.9 13.1 12.2 12.9 13 12.5 ...
# $ GNIpc      : chr  "64,992" "42,261" "56,431" "44,025" ...
# $ GNIpcHDIadj: int  5 17 6 11 9 11 16 3 11 23 ...
# $ GIIrank    : int  1 2 3 4 5 6 6 8 9 9 ...
# $ GII        : num  0.067 0.11 0.028 0.048 0.062 0.041 0.113 0.28 0.129 0.157 ...
# $ matMort    : int  4 6 6 5 6 7 9 28 11 8 ...
# $ birthRate  : num  7.8 12.1 1.9 5.1 6.2 3.8 8.2 31 14.5 25.3 ...
# $ parlRep    : num  39.6 30.5 28.5 38 36.9 36.9 19.9 19.4 28.2 31.4 ...
# $ edu2F      : num  97.4 94.3 95 95.5 87.7 96.3 80.5 95.1 100 95 ...
# $ edu2M      : num  96.7 94.6 96.6 96.6 90.5 97 78.6 94.8 100 95.3 ...
# $ labF       : num  61.2 58.8 61.8 58.7 58.5 53.6 53.1 56.3 61.6 62 ...
# $ labM       : num  68.7 71.8 74.9 66.4 70.6 66.4 68.1 68.9 71 73.8 ...
# $ eduF2M     : num  1.007 0.997 0.983 0.989 0.969 ...
# $ labF2M     : num  0.891 0.819 0.825 0.884 0.829 ...
dim(human)
# [1] 195  19

## the dataset has 195 observations with 19 variables.  
## Lets save relevant variables into a vector and go through them:
## --Variables to select
vars2take <- c("country", "eduF2M", "labF2M", "edExp", "lifeExp", "GNIpc", "matMort", "birthRate", "parlRep")

## Here are the explanations for these variables
# "country" = Country name
# "GNIpc" = Gross National Income per capita
# "lifeExp" = Life expectancy at birth
# "edExp" = Expected years of schooling 
# "matMort" = Maternal mortality ratio
# "birthRate" = Adolescent birth rate
# "parlRep" = Percetange of female representatives in parliament
# "edu2F" = Proportion of females with at least secondary education
# "edu2M" = Proportion of males with at least secondary education
# "labF" = Proportion of females in the labour force
# "labM" " Proportion of males in the labour force
# "eduF2M" = edu2F / edu2M
# "labF2M" = labF / labM

## Pipe for 1-3. 
human_new <- human %>% 
  mutate(GNIpc=as.numeric(str_replace(GNIpc, ",","."))) %>% ## convert to numeric 
  dplyr::select(all_of(vars2take)) %>%  ## select variables set above
  drop_na() ## drop NAs

## Print the country variable for selection of non-countries for dropping
human_new$country

## last rows seem to contain appropriate number of areas to drop
# "Arab States"                              
# "East Asia and the Pacific"                 "Europe and Central Asia"                  
# "Latin America and the Caribbean"           "South Asia"                               
# "Sub-Saharan Africa"                        "World"  

## Set these in variable
area2drop <- c("Arab States", "East Asia and the Pacific", "Europe and Central Asia", 
               "Latin America and the Caribbean", "South Asia", "Sub-Saharan Africa", 
               "World")

## create notin for easier handling with filtering
`%notin%` <- Negate(`%in%`)

## pipe for 4-5.
human_new <- human_new %>% 
  dplyr::filter(country %notin% area2drop) %>% ## filter non-countries
  column_to_rownames("country")  ## set rownames as country

## check dimensions
str(human_new)
#correct

## lets rename the old file to not overwrite it
file.rename(from = "Data/human.tsv", to = "Data/human_OLD.tsv")

## write the 
write.table(human_new, file = "Data/human.tsv", row.names = T, col.names = T, quote = F, sep = "\t")
