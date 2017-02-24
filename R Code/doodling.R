setwd('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/')
source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')

# save(x=inertia, file='./Code/R Code/Inertia.RData')

library(ggplot2)
library(reshape2)

# NEXT STEPS:
# match image to species/genus
# instead of normalized residual sum, plot slope between each set of points
# ...catterplots
bigDir <- './ClusterPickles/'
outDir <- dir('./ClusterPickles/', pattern='*ClusterSpread.csv')

# get the names of the images themselves
imNames <- as.character(read.csv(paste(bigDir, outputDirectories[1], '/out.csv', sep=''))$ID)
imNames <- as.character(sapply(imNames, function(x) tail(unlist(strsplit(x, '/')), 1)))
imNames <- as.character(sapply(imNames, function(x) substr(x, 1, nchar(x)-4)))

# species (c1) and filename (c2) for each image
nameRef <- read.csv('Chaet_Fishinator_Photo_Sources.csv')[,1:2]

# original images which also have clustered images
overlap <- nameRef[which(nameRef$File.Name %in% imNames),] # 
matchFish <- sapply(imNames, function(x) as.character(overlap[match(x,overlap[,2]),]$Species))
df <- data.frame(ID=imNames, Species=matchFish)

for (i in 1:length(outDir)) {
  CSV <- read.csv(paste('./ClusterPickles/', outDir[i], sep=''))$Avg..Cluster.Spread
  df <- cbind(df, CSV)
}

colnames(df) <- c("ID", "Species", sapply(c(1:(dim(df)[2]-2)), function(i) paste(i, 'C', sep='')))

dfTemp <- df[df$Species=="Chaetodon argentatus",]
dfTemp <- melt(dfTemp)
p <- ggplot(dfTemp, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
p <- p + xlab("Number of clusters") + ylab("Avg. cluster spread")
print(p)

species <- unique(df$Species)

for (i in 1:length(species)) {
  dfTemp <- df[df$Species==species[i],]
  dfTemp <- melt(dfTemp)
  p <- ggplot(dfTemp, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
  p <- p + xlab("Number of clusters") + ylab("Avg. cluster spread") + ggtitle(species[i])
  print(p)
  invisible(readline(prompt="Press [enter] to continue"))
}


jumpGraph(df[1:200,], j=10, "Avg. Cluster Spread")












df <- melt(inertia)
df <- melt(inertiaD1)
df <- melt(inertiaD2)
ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species))) + theme(legend.position="none")
print(p)

jumpGraph <- function(inputDF, j, ylab) {
  for (i in seq(1, dim(inputDF)[1], j)) {
    start <- i
    
    if ((i+j) < dim(inputDF)[1]) { end <- i+j } else { end <- dim(inputDF)[1]}
    
    df <- melt(inputDF[start:end,])
    
    p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
    p <- p + xlab("Number of Clusters") + ylab(ylab) + ggtitle(paste("Images", start, "to", end, sep=" "))
    # p <- p + theme(legend.position="none")
    print(p)
  }
}

jumpGraph(inertia, 50, ylab="Avg. pixel distance")

jumpGraph(inertiaD1, 50, ylab="Drop in avg. pixel distance")

jumpGraph(inertiaD2, 50, ylab="Rate of change in avg. pixel distance")

dfTemp <- df[df$ID=="folon_05.jpg",]
dfTemp <- melt(dfTemp)
p <- ggplot(dfTemp, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
# p <- p + xlab("Number of Clusters") + ylab(ylab) + ggtitle(paste("Images", start, "to", end, sep=" "))
# p <- p + theme(legend.position="none")
print(p)















# read in all the output CSVs
outputDirectories <- dir('./Out/', pattern='*Color')
lim <- length(outputDirectories)

# get the names of the images themselves
imNames <- as.character(read.csv(paste('Out/', outputDirectories[1], '/out.csv', sep=''))$ID)

# species (c1) and filename (c2) for each image
nameRef <- read.csv('Chaet_Fishinator_Photo_Sources.csv')[,1:2]

# for the record i tried an apply function here and it was more confusing and not faster :/
imNames2 <- vector()
for (i in 1:length(imNames)) {
  imNames2 <- c(imNames2, tail(unlist(strsplit(imNames[i], '/')), 1))
}

# match image names to species names for intraspecies consistency

# names of clustered images (567)
imNames2

# names of original images (569)
files <- as.character(nameRef$File.Name)

# original images which also have clustered images
overlap <- nameRef[which(files %in% imNames2),] # ok seems to be working now

matchFish <- sapply(imNames2, function(x) as.character(overlap[match(x,overlap[,2]),]$Species))

inertia <- data.frame(ID=imNames2, Species=matchFish)
# from imNames2, for each row, get the matching species name and append that to the dataframe

# grab the inertia column from each output CSV and append it to the inertia dataframe
for (i in 1:lim) {
  inertia <- cbind(inertia, read.csv(paste('Out/', outputDirectories[i], '/out.csv', sep=''))$Sum.of.Residuals)
}

# rename all the columns to something useful
colnames(inertia) <- c("ID", "Species", sapply(c(1:(dim(inertia)[2]-2)), function(i) paste(i, 'C', sep='')))

# normalize inertia to highest sum (which will be the 1-cluster sum)
inertia[,3:dim(inertia)[2]] <- t(apply(inertia[,3:dim(inertia)[2]], 1, function(x) x/max(x)))

# if you need to test just one
plot(c(1:10), inertia[1,3:dim(inertia)[2]], type='l')


# plot 50 at a time just to have an easier time viewing
j <- 30
for (i in seq(1, dim(inertia)[1], j)) {
  start <- i
  
  if ((i+j) < dim(inertia)[1]) { end <- i+j } else { end <- dim(inertia)[1]}
  
  df <- melt(inertia[start:end,])
  
  p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species)))
  p <- p + xlab("Number of Clusters") + ylab("Residual Sum") + ggtitle(paste("Images", start, "to", end, sep=" "))
  # p <- p + theme(legend.position="none")
  print(p)
}

# plot everything at once
df <- melt(inertia)
p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
p <- p + xlab("Number of Clusters") + ylab("Residual Sum") + theme(legend.position="none")
p


## first ""derivative""
# instead of 1C, 2C, 3C, etc...
# get (1C-2C), (2C-3C), (3C-4C)
# getting true derivative would i think be kind of pointless since that would require fitting to a polynomial first and you'd end up with some kind of inflection point at a non-integer number of clusters which is not great

# there's a lot to unpack here, but basically:
# 1. for every row of clusters, take the difference in inertia from each pair (1-2, 2-3, 3-4, etc); these should be negative because inertia is going down
# 2. stick the old species and picture names as columns onto these new values
inertiaD1 <- as.data.frame(cbind(inertia[,1:2], t(apply(inertia[,3:(dim(inertia)[2])], 1, function(x) diff(x)))))

# normalize values again
normInertiaD1 <- inertiaD1[,3:dim(inertiaD1)[2]] <- t(apply(inertiaD1[,3:dim(inertiaD1)[2]], 1, function(x) x/max(abs(x))))
normInertiaD1 <- cbind(inertiaD1[,1:2], normInertiaD1)

j <- 30
matFish <- inertiaD1
for (i in seq(1, dim(matFish)[1], j)) {
  start <- i
  
  if ((i+j) < dim(matFish)[1]) { end <- i+j } else { end <- dim(matFish)[1]}
  
  df <- melt(matFish[start:end,])
  
  p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species)))
  p <- p + xlab("Change in cluster number (number of added parameters)") + ylab("Change in Residual Sum (~= improvement)") + ggtitle(paste("Images", start, "to", end, sep=" "))
  # p <- p + theme(legend.position="none")
  print(p)
}


# second "derivative" should get you the inflection points
inertiaD2 <- inertiaD1[,1:(dim(inertia)[2]-1)]
inertiaD2 <- as.data.frame(cbind(inertiaD1[,1:2], t(apply(inertiaD1[,3:(dim(inertiaD1)[2])], 1, function(x) diff(as.numeric(x))))))

# inertiaD2[,3:dim(inertiaD2)[2]] <- t(apply(inertiaD2[,3:dim(inertiaD2)[2]], 1, function(x) x/max(abs(x))))

j <- 30
matFish <- inertiaD2
for (i in seq(1, dim(matFish)[1], j)) {
  start <- i
  
  if ((i+j) < dim(matFish)[1]) { end <- i+j } else { end <- dim(matFish)[1]}
  
  df <- melt(matFish[start:end,])
  
  p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species)))
  p <- p + xlab("Change in cluster number") + ylab("Rate of change in Residual Sum") + ggtitle(paste("Images", start, "to", end, sep=" "))
  # p <- p + theme(legend.position="none")
  print(p)
}

## TESTING
hezos <- inertia[inertia$Species=="Hemitaurichthys zoster",]

test <- as.numeric(hezos[1,3:dim(hezos)[2]])

plot(test, type='l', ylab = "Residual sum", xlab = "Number of clusters")

plot(diff(test), type='l',
     ylab = "Change in residual sum",
     xlab = "Number of clusters added")
plot(diff(diff(test)), type='l',
     ylab = "Relative improvement over previous residual sum",
     xlab = "Number of clusters added")

# interpretation: for 2nd derivative, take the last point after which adding more clusters does
diff(test)


## PLEASE IGNORE THIS

# OK......HANG ON A SECOND
# library(devtools)
# install_github("Gibbsdavidl/CatterPlots")

# signs that you are becoming unhinged include:
library(CatterPlots)
x <- c(1:10)
y <- unlist(inertia[1,3:dim(inertia)[2]])
purr <- catplot(xs=x, ys=y, size=0.1, type="line", cat=4, catcolor=c(1,0,1,1), xlab="andrea", ylab="are you happy now")

cats(purr, xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]))

x <- catplot(xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]))
cats(x, xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]))

purr <- catplot(xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]), 
                size=0.1, type="line", cat=4, catcolor=c(1,0,1,1),
                xlab="andrea", ylab="are you happy now")

cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))

cats(purr, xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]))

x <- -10:10
y <- -x^2 + 10
purr <- catplot(xs=x, ys=y, cat=3, catcolor=c(0,1,1,1))
cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))






dfCB01 <- melt(inertia[inertia$Species=="Chaetodon baronessa",])

C.baronessa01 <- ggplot(dfCB01, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species))) + xlab("Change in cluster number") + ylab("Rate of change in Residual Sum") + ggtitle("Chaetodon baronessa")

dfCB02 <- melt(inertiaD1[inertiaD1$Species=="Chaetodon baronessa",])

C.baronessa02 <- ggplot(dfCB02, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species))) + xlab("Change in cluster number") + ylab("Rate of change in Residual Sum") + ggtitle("Chaetodon baronessa D1")

dfCB03 <- melt(inertiaD2[inertiaD2$Species=="Chaetodon baronessa",])

C.baronessa03 <- ggplot(dfCB03, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(Species))) + xlab("Change in cluster number") + ylab("Rate of change in Residual Sum") + ggtitle("Chaetodon baronessa D2")

unknowns <- c("Chaetodon paucifasciatus", 
              "Chaetodon larvatus", 
              "Chaetodon madagaskariensis",
              "Chaetodon trifasciatus",
              "Chaetodon austriacus",
              "Chaetodon collare", 
              "Chaetodon mesoleucos")

twos <- c("Chaetodon smithi",
          "Chaetodon melapterus",
          "Chaetodon speculum",
          "Chaetodon striatus")

threes <- c("Forcipiger longirostris",
            "Chaetodon plebeius",
            "Chaetodon fremblii",
            "Chaetodon melannotus",
            "Chaetodon tricinctus")

fours <- c("Chaetodon baronessa",
           "Chaetodon auriga")

fishSet <- twos
fishSet <- threes
fishSet <- fours
fishSet <- c("Chaetodon larvatus")
for (i in 1:length(fishSet)) {
  df1 <- melt(inertia[inertia$Species==fishSet[i],])
  df2 <- melt(inertiaD1[inertiaD1$Species==fishSet[i],])
  df3 <- melt(inertiaD2[inertiaD2$Species==fishSet[i],])
  
  p1 <- ggplot(df1, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID))) + xlab("Cluster") + ylab("Residual Sum") + ggtitle(fishSet[i])
  
  p2 <- ggplot(df2, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID))) + xlab("Change in cluster number") + ylab("Change in Residual Sum")
  
  p3 <- ggplot(df3, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID))) + xlab("Change in cluster number") + ylab("Rate of change in Residual Sum") + geom_hline(yintercept = 0.10, lty=2)
  
  multiplot(p1, p2, p3)
}
