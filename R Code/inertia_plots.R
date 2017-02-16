setwd('~/Dropbox/Colorful Fishinator/')

# read in all the output CSVs

# get all the inertia ( = residual) values from each one

# for each image, plot inertia as a function of number of clusters (x axis = clusters, y  axis = inertia/residuals)

outputDirectories <- dir('OutTest/')

csv01 <- read.csv('OutTest/01Color/out.csv')
csv02 <- read.csv('OutTest/02Color/out.csv')
csv03 <- read.csv('OutTest/03Color/out.csv')
csv04 <- read.csv('OutTest/04Color/out.csv')
csv05 <- read.csv('OutTest/05Color/out.csv')
csv06 <- read.csv('OutTest/06Color/out.csv')

Cluster1 <- csv01$Inertia
Cluster2 <- csv02$Inertia
Cluster3 <- csv03$Inertia

# make our dataframe
df <- data.frame(Picture = csv01$ID, Cluster1 = Cluster1, Cluster2 = Cluster2, Cluster3 = Cluster3, Cluster4 = csv04$Inertia, Cluster5 = csv05$Inertia, Cluster6 = csv06$Inertia)
df <- melt(df)

p <- ggplot(df, aes(variable, value, group=factor(Picture))) + geom_line(aes(color=factor(Picture)))
p <- p + xlab("Number of Clusters") + ylab("Residual Sum")
p
