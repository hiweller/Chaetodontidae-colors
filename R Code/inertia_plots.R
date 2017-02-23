setwd('~/Dropbox/Colorful_Fishinator/')
library(ggplot2)
library(reshape2)

# OVERALL GOAL for looking at residual sums:
# figure out which exact colors are present on a fish
# in practice: figure out how many colors you need to describe fish (and which colors those are)
# clustering: at what point does adding additional clusters no longer significantly improve the sum of pixel-cluster residuals?


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

## first ""derivative""
# instead of 1C, 2C, 3C, etc...
# get (1C-2C), (2C-3C), (3C-4C)
# getting true derivative would i think be kind of pointless since that would require fitting to a polynomial first and you'd end up with some kind of inflection point at a non-integer number of clusters which is not great

# there's a lot to unpack here, but basically:
# 1. for every row of clusters, take the difference in inertia from each pair (1-2, 2-3, 3-4, etc); these should be negative because inertia is going down
# 2. stick the old species and picture names as columns onto these new values
inertiaD1 <- as.data.frame(cbind(inertia[,1:2], t(apply(inertia[,3:(dim(inertia)[2])], 1, function(x) diff(x)))))

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
inertiaD2 <- as.data.frame(cbind(inertiaD1[,1:2], t(apply(inertiaD1[,3:(dim(inertiaD1)[2])], 1, function(x) diff(x)))))

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
