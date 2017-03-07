setwd('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/')

library(ggplot2)

colorPlot3dComp <- function(path, group='all', title=FALSE) {
  
  if (!is.character(title)) { title <- path }
  
  scene <- list(xaxis=list(title='Red', linecolor=toRGB('red'), linewidth=6, range=c(0,255)), yaxis=list(title='Green', linecolor=toRGB('green'), linewidth=6, range=c(0,255)), zaxis=list(title='Blue', linecolor=toRGB('blue'), linewidth=6, range=c(0,255)), camera = list(eye = list(x = -1.25, y = 1.25, z = 1.25)))
  
  # turn out.csv into a list with 1 element per species;
  # each element is a DF with cluster number, cluster pct, R, G, and B columns
  fishList <- csvToList(path)
  
  # if a specific group has not been specified just do this for all of them
  if (group[1]=='all') {
    group <- names(fishList)
  } else if (length(group)==1) {
    newDF <- fishList[[group]]
    newDF$Image <- rep(group, dim(newDF)[1])
  } else {
    
    # new list of just the images of interest
    newList <- vector("list", length(group))
    
    for (i in 1:length(group)) {
      newList[[i]] <- fishList[[group[i]]]
      names(newList)[i] <- group[i]
    } 
    
    # flatten list into one DF for plotting; add a column of image names for identification in plot
    newDF <- newList[[1]]
    newDF$Image <- rep(names(newList)[1], dim(newList[[1]])[1])
    
    for (i in 2:length(newList)) {
      tempDF <- newList[[i]]
      tempDF$Image <- rep(names(newList)[i], dim(newList[[i]])[1])
      newDF <- rbind(newDF, tempDF)
    }
  }
  
  
  # make RGB color vector so that each point in the plot will be colored according to its actual color
  # rgbExp <- apply(newDF[,3:5]/255, 1, function(x) rgb(x[1], x[2], x[3]))
  p <- plot_ly(newDF, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Image, text = ~paste('Image: ', Image)) %>%
    add_markers(color=~Image, size=~Pct, sizes=c(500,10000)) %>%
    layout(scene = scene, title=title)
  return(p)
}


# plots several fish on one color plot
colorPlot3dMulti <- function(path, group='all', title=FALSE) {
  
  if (!is.character(title)) { title <- path }
  
  scene <- list(xaxis=list(title='Red', linecolor=toRGB('red'), linewidth=6, range=c(0,255)), yaxis=list(title='Green', linecolor=toRGB('green'), linewidth=6, range=c(0,255)), zaxis=list(title='Blue', linecolor=toRGB('blue'), linewidth=6, range=c(0,255)), camera = list(eye = list(x = -1.25, y = 1.25, z = 1.25)))
  
  # turn out.csv into a list with 1 element per species;
  # each element is a DF with cluster number, cluster pct, R, G, and B columns
  fishList <- csvToList(path)
  
  # if a specific group has not been specified just do this for all of them
  if (group[1]=='all') {
    group <- names(fishList)
  } else if (length(group)==1) {
    newDF <- fishList[[group]]
    newDF$Image <- rep(group, dim(newDF)[1])
  } else {
    
    # new list of just the images of interest
    newList <- vector("list", length(group))
    
    for (i in 1:length(group)) {
      newList[[i]] <- fishList[[group[i]]]
      names(newList)[i] <- group[i]
    } 
    
    # flatten list into one DF for plotting; add a column of image names for identification in plot
    newDF <- newList[[1]]
    newDF$Image <- rep(names(newList)[1], dim(newList[[1]])[1])
    
    for (i in 2:length(newList)) {
      tempDF <- newList[[i]]
      tempDF$Image <- rep(names(newList)[i], dim(newList[[i]])[1])
      newDF <- rbind(newDF, tempDF)
    }
  }
  
  
  # make RGB color vector so that each point in the plot will be colored according to its actual color
  rgbExp <- apply(newDF[,3:5]/255, 1, function(x) rgb(x[1], x[2], x[3]))
  p <- plot_ly(newDF, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Cluster, text = ~paste('Image: ', Image)) %>%
    add_markers(color=I(rgbExp), size=~Pct, sizes=c(500,10000)) %>%
    layout(scene = scene, title=title)
  return(p)
}

plot_jpeg = function(path, add=FALSE)
{
  require('jpeg')
  jpg = readJPEG(path, native=T) # read the file
  res = dim(jpg)[1:2] # get the resolution
  if (!add) # initialize an empty plot area if add==FALSE
    plot(1,1,xlim=c(1,res[1]),ylim=c(1,res[2]),type='n',xaxs='i',yaxs='i',xaxt='n',yaxt='n',xlab='',ylab='',bty='n', main = path)
  rasterImage(jpg,1,1,res[1],res[2])
}

# turns out.csv objects returned from python into list of dataframes (1 per image), so you can plot all of them at once if you want
csvToList <- function(path) {
  df <- read.csv(path)
  testlist <- vector("list", dim(df)[1])
  
  imNames <- as.character(sapply(as.character(df$ID), function(x) tail(unlist(strsplit(x, '/')), 1)))
  
  names(testlist) <- imNames
  
  Percent <- df[,seq(4, dim(df)[2], 4)]
  Rs <- df[,seq(5, dim(df)[2], 4)]
  Gs <- df[,seq(6, dim(df)[2], 4)]
  Bs <- df[,seq(7, dim(df)[2], 4)]
  
  for (i in 1:dim(df)[1]) {
    triplets <- data.frame(Cluster=c(1:dim(Percent)[2]),
                           Pct=as.numeric(Percent[i,]),
                           R=as.numeric(Rs[i,]),
                           G=as.numeric(Gs[i,]),
                           B=as.numeric(Bs[i,]))
    testlist[[i]] <- triplets }
  return(testlist)
}


# 3d scatterplots of color for out.csv objects returned from running python scripts; pass path to out.csv file
colorPlot3d <- function(path, r='all') {
  
  scene <- list(xaxis=list(title='Red', linecolor=toRGB('red'), linewidth=6, range=c(0,255)), yaxis=list(title='Green', linecolor=toRGB('green'), linewidth=6, range=c(0,255)), zaxis=list(title='Blue', linecolor=toRGB('blue'), linewidth=6, range=c(0,255)), camera = list(eye = list(x = -1.25, y = 1.25, z = 1.25)))
  
  fishList <- csvToList(path)
  if (!is.numeric(r)) {
    for (i in 1:length(fishList)) {
      triplets <- fishList[[i]]
      rgbExp <- apply(triplets/255, 1, function(x) rgb(x[3], x[4], x[5]))
      p <- plot_ly(triplets, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Cluster) %>%
        add_markers(color=I(rgbExp), size=~Pct, sizes=c(1000,10000)) %>%
        layout(scene = scene, title=paste(imNames[i], path))
      print(p)
      invisible(readline(prompt="Press [enter] to continue or [esc] to exit the loop"))
    }
  } else {
    triplets <- fishList[[r]]
    rgbExp <- apply(triplets/255, 1, function(x) rgb(x[3], x[4], x[5]))
    p <- plot_ly(triplets, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Cluster) %>%
      add_markers(color=I(rgbExp), size=~Pct, sizes=c(1000,10000)) %>%
      layout(scene = scene, title=imNames[r])
    print(p)
  }
}

# subset a list; provide list and vector with subset of names you want to pull out
# ex: listToDF(csvToList('./Output/10Color/out.csv'), c("amhow_01", "amhow_02"))
subList <- function(startList, subVec) {
  # pull out sublist from main list:
  # make empty list
  miniList <- vector("list", length(subVec))
  
  # put each matching entry into the new list
  miniList <- lapply(c(1:length(subVec)), function(x) miniList[[x]] <- startList[[subVec[x]]])
  names(miniList) <- subVec
  
  return(miniList)
}

# turn list into dataframe; original name of element in list becomes a new factor
# kind of like 'melt'
listToDF <- function(startList) {
  
  # flatten list into one DF for plotting; add a column of image names for identification in plot
  newDF <- startList[[1]]
  newDF$Image <- rep(names(startList)[1], dim(startList[[1]])[1])
  
  for (i in 2:length(startList)) {
    tempDF <- startList[[i]]
    tempDF$Image <- rep(names(startList)[i], dim(startList[[i]])[1])
    newDF <- rbind(newDF, tempDF) }
  
  return(newDF)
} 


# plots multiple ggplot plots in one window
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