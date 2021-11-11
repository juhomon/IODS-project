## Juho Mononen: Custom functions used in the scripts. 


## Calculate new variables using expressions from a data frame
require(tidyverse)
mutate_addCalc <- function(df,var.df) {
  for (i in 1:nrow(var.df)) {
    df <- df %>% mutate(!! parse_expr(var.df$vars[i]) := !! parse_expr(var.df$calcs[i]))
  }
  return(df)
}