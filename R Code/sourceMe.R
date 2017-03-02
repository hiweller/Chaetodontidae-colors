setwd('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/')

library(ggplot2)

plot_jpeg = function(path, add=FALSE)
{
  require('jpeg')
  jpg = readJPEG(path, native=T) # read the file
  res = dim(jpg)[1:2] # get the resolution
  if (!add) # initialize an empty plot area if add==FALSE
    plot(1,1,xlim=c(1,res[1]),ylim=c(1,res[2]),type='n',xaxs='i',yaxs='i',xaxt='n',yaxt='n',xlab='',ylab='',bty='n', main = path)
  rasterImage(jpg,1,1,res[1],res[2])
}

# read in all the output CSVs
# outputDirectories <- dir('./Out/', pattern='*Color')
bigDir <- './Out/'
outputDirectories <- dir(bigDir, pattern='*Color')
lim <- length(outputDirectories)

# get the names of the images themselves
imNames <- as.character(read.csv(paste(bigDir, outputDirectories[1], '/out.csv', sep=''))$ID)

# species (c1) and filename (c2) for each image
nameRef <- read.csv('Chaet_Fishinator_Photo_Sources.csv')[,1:2]

# for the record i tried an apply function here and it was more confusing and not faster :/
imNames2 <- vector()
for (i in 1:length(imNames)) {
  imNames2 <- c(imNames2, tail(unlist(strsplit(imNames[i], '/')), 1))
}

# original images which also have clustered images
overlap <- nameRef[which(nameRef$File.Name %in% imNames2),] # ok seems to be working now

matchFish <- sapply(imNames2, function(x) as.character(overlap[match(x,overlap[,2]),]$Species))

inertia <- data.frame(ID=imNames2, Species=matchFish)
# from imNames2, for each row, get the matching species name and append that to the dataframe

# grab the inertia column from each output CSV and append it to the inertia dataframe
for (i in 1:lim) {
  inertia <- cbind(inertia, read.csv(paste(bigDir, outputDirectories[i], '/out.csv', sep=''))$Avg..Pixel.Distance)
}

# rename all the columns to something useful
colnames(inertia) <- c("ID", "Species", sapply(c(1:(dim(inertia)[2]-2)), function(i) paste(i, 'C', sep='')))

# normalize inertia to highest sum (which will be the 1-cluster sum)
# inertia[,3:dim(inertia)[2]] <- t(apply(inertia[,3:dim(inertia)[2]], 1, function(x) x/max(x)))

inertiaD1 <- as.data.frame(cbind(inertia[,1:2], t(apply(inertia[,3:(dim(inertia)[2])], 1, function(x) diff(x)))))

inertiaD2 <- as.data.frame(cbind(inertiaD1[,1:2], t(apply(inertiaD1[,3:(dim(inertiaD1)[2])], 1, function(x) diff(x)))))



multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

# function for plotting colors in an image in RGB space
# takes path to (greenscreened) image, number of points you want to plot (<20000 recommended), and whether or not you want to reverse axes to look at graph from other vertex
pixelPlot <- function(path, n, rev=TRUE) {
  
  img <- readJPEG(path)
  dim(img) <- c(dim(img)[1]*dim(img)[2], 3)
  # always do it the crappy way first so when you do it the decent way you feel like a genius instead of barely on par!
  idx <- c()
  
  v <- round(seq(1, dim(img)[1], dim(img)[1]/n))
  
  img2 <- img[v,]
  
  for (i in 1:dim(img2)[1]) {
    row <- img2[i,]
    if (row[1] <= 120/255 & row[2] >= 150/255 & row[3] <=120/255) {
      idx <- c(idx, i)
    }
  }
  img3 <- img2[-idx,]
  
  rgbExp <- apply(img3, 1, function(x) rgb(x[1], x[2], x[3]))
  
  if (rev) 
  {scatterplot3d(img3, pch=20, color = rgbExp, xlab = "R", ylab="G", zlab="B", main = paste(path, n, " points", sep=" "))} 
  else 
  {scatterplot3d(-img3, pch=20, color = rgbExp, xlab = "R", ylab="G", zlab="B", main = paste("Rev.", path, n, "points", sep=" "))}
}