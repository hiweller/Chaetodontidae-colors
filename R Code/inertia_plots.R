setwd('~/Dropbox/Colorful Fishinator/')
library(ggplot2)
library(reshape2)

# read in all the output CSVs
outputDirectories <- dir('OutTest/')

csv01 <- read.csv('OutTest/01Color/out.csv')
csv02 <- read.csv('OutTest/02Color/out.csv')
csv03 <- read.csv('OutTest/03Color/out.csv')

# get all the inertia ( = residual) values from each one
Cluster1 <- csv01$Inertia
Cluster2 <- csv02$Inertia
Cluster3 <- csv03$Inertia

# make our dataframe
df <- data.frame(Picture = csv01$ID, Cluster1 = Cluster1, Cluster2 = Cluster2, Cluster3 = Cluster3)
df <- melt(df)
# for each image, plot inertia as a function of number of clusters (x axis = clusters, y  axis = inertia/residuals)
ggplot(df, aes(variable, value, group=factor(Picture))) + geom_line(aes(color=factor(Picture)))
