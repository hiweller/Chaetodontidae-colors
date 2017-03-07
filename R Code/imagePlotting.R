source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')
library(jpeg)
library(scatterplot3d)
library(plotly)

imDir <- dir('./GoodQualityImages/', pattern='*.jpg')
csvDir <- dir('./GQIOutput/', pattern='*Color')
csvDir <- csvDir[c(1:9, 11:21, 10)]


test <- read.csv(paste('./GQIOutput/', tail(csvDir, 1), '/out.csv', sep=''))
cnames <- names(test)

test <- test[,-seq(4, length(cnames), 4)]

Rs <- test[,seq(4, dim(test)[2], 3)]
Gs <- test[,seq(5, dim(test)[2], 3)]
Bs <- test[,seq(6, dim(test)[2], 3)]

triplets <- data.frame(R=Rs, G=Gs, B=Bs)
for (i in 1:dim(Rs)[1]) {
  triplets <- data.frame(R=as.numeric(Rs[i,]), G=as.numeric(Gs[i,]), B=as.numeric(Bs[i,]))
  
  rgbExp <- apply(triplets/255, 1, function(x) rgb(x[1], x[2], x[3]))
  
  scatterplot3d(triplets, pch=19, color = rgbExp, xlab = "R", ylab="G", zlab="B", main = tail(strsplit(as.character(test[i,1]), '/')[[1]], 1))
  
  invisible(readline(prompt="Press [enter] to continue or [esc] to exit the loop"))
}

# plot colors from each image in image directory
for (i in 1:length(imDir)) {
  pixelPlot(paste('./GoodQualityImages/', imDir[i], sep=""), 10000)
  invisible(readline(prompt="Press [enter] to continue or [esc] to exit the loop"))
}
