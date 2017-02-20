setwd('~/Dropbox/Colorful_Fishinator/')
library(ggplot2)
library(reshape2)

# NEXT STEPS:
# match image to species/genus
# instead of normalized residual sum, plot slope between each set of points
# ...catterplots




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
  
for (i in 1:lim) { #change this to read 1:length(outputDirectories) - for now there's extra stuff in the OutTest folder so we're being clunky
  inertia <- cbind(inertia, read.csv(paste('Out/', outputDirectories[i], '/out.csv', sep=''))$Sum.of.Residuals)
}
colnames(inertia) <- c("ID", "Species", sapply(c(1:(dim(inertia)[2]-2)), function(i) paste(i, 'C', sep='')))

inertia[,3:dim(inertia)[2]] <- t(apply(inertia[,3:dim(inertia)[2]], 1, function(x) x/max(x)))

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

df <- melt(inertia)

p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
p <- p + xlab("Number of Clusters") + ylab("Residual Sum") + theme(legend.position="none")
p

# instead of 1C, 2C, 3C, etc...
# get (1C-2C), (2C-3C), (3C-4C)

# sloppy way: do this one row at a time to figure out what i'm doing







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
