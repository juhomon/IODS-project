## Juho Mononen: Custom functions used in the scripts. 


## Calculate new variables using expressions from a data frame
require(tidyverse)
mutate_addCalc <- function(df,var.df) {
  for (i in 1:nrow(var.df)) {
    df <- df %>% mutate(!! parse_expr(var.df$vars[i]) := !! parse_expr(var.df$calcs[i]))
  }
  return(df)
}


## Ex3 mean variable function
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
      tmp <- tmp %>% mutate({{tmp.var}} := rowMeans(select(tmp, contains(tmp.var))))
      ## If character take the por option
    } else {
      tmp <- tmp %>% mutate({{tmp.var}} := last(select(tmp, contains(paste0(tmp.var)))))
    }
  }
  return(tmp)
}