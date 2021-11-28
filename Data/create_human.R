## Script for creating dataset for Dimensionality reduction techniques exercise
## Juho Mononen, 28.11.2021

# Human development dataset
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# get structure and dimensions
str(hd)
dim(hd)
# comments: the dataset has 195 observations with 8 variables. 4 variables are continuous numeric, 2 integers and 2 characters

# get summary of the values
summary(hd)
# comments: GNI.per.Capita.Rank.Minus.HDI.Rank seems to have some NA values in it, also HDI.Rank. 
# Numeric cariables have very different scales (e.g. HDI.Rank (1-188) vs Human.Development.Index..HDI (0.3480-0.9440))

# Gender inequality dataset
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# get structure and dimensions
str(gii)
dim(gii)
# comments: the dataset has 195 observations with 10 variables. 7 variables are continuous numeric, 2 integers and 1 character

# get summary of the values
summary(gii)
# comments: All of the numeric variables have NAs in them. Many of the variables are percentages.


# Creating better names
# lets do this manually since there are not so many

# print the current ones for gii
colnames(hd)
# set new names
colnames(hd) <- c("HDIrank", "country", "HDI", "lifeExp", "edExp", "edMean", "GNIpc", "GNIpcHDIadj")
# check new names
colnames(hd)

# print the current ones for gii
colnames(gii)
# set new names
colnames(gii) <- c("GIIrank", "country", "GII", "matMort", "birthRate", "parlRep", "edu2F", "edu2M", "labF", "labM")
# check new names
colnames(gii)

# generate new variables for gii
gii <- mutate(gii, eduF2M=edu2F/edu2M, labF2M=labF/labM)

# create human by joining the datasets
human <- inner_join(hd, gii, by="country")

# check dimensions
dim(human)
# comments: amount of observations is indeed 195 observations to 19 variables

# save the table
write.table(human, file = "Data/human.tsv", quote = F, sep="\t", row.names = F)


