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

## Colouring function taken from here: https://stackoverflow.com/questions/57450913/removing-background-color-for-column-labels-while-keeping-plot-background-color
# Defines function to color according to correlation
cor_func <- function(data, mapping, method, symbol, ...){
  x <- eval_data_col(data, mapping$x)
  y <- eval_data_col(data, mapping$y)
  
  corr <- cor(x, y, method=method, use='complete.obs')
  colFn <- colorRampPalette(c("brown1", "white", "dodgerblue"), 
                            interpolate ='spline')
  fill <- colFn(100)[findInterval(corr, seq(-1, 1, length = 100))]
  
  ggally_text(
    label = paste(symbol, as.character(round(corr, 2))), 
    mapping = aes(),
    xP = 0.5, yP = 0.5,
    color = 'black',
    ...
  ) + #removed theme_void()
    theme(panel.background = element_rect(fill = fill))
}

## Another function for better geom points apparently some variables have non-zero variance so cant use this...
ggally_dens2DPointsViridis <- function(data, mapping, N=100, ...){
  
  require(viridis)
  
  ## function for calculating density
  get_density <- function(x, y, n ) {
    dens <- MASS::kde2d(x = x, y = y, n = n)
    i_x <- findInterval(x, dens$x)
    i_y <- findInterval(y, dens$y)
    i <- cbind(i_x, i_y)
    return(dens$z[i])
  }
  
  ## get columns from mapping (ggplot mapping)
  map_y <- eval_data_col(data, mapping$y)
  map_x <- eval_data_col(data, mapping$x)
  
  ## calculate density
  data$density <- get_density(x=map_x, y=map_y, n=N)
  
  p <- ggplot(data, mapping) +
    geom_point(aes(colour=density), ...) +
    scale_color_viridis()      
  p
}