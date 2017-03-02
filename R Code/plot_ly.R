source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')
library(jpeg)
library(scatterplot3d)
library(plotly)
imDir <- dir('./GoodQualityImages/', pattern='*.jpg')
csvDir <- dir('./GQIOutput/', pattern='*Color')
csvDir <- csvDir[c(2, 4:11, 1, 3)]

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

colorPlot3d <- function(path, r='all') {
  
  fishList <- csvToList(path)
  if (!is.numeric(r)) {
    for (i in 1:length(fishList)) {
      triplets <- fishList[[i]]
      rgbExp <- apply(triplets/255, 1, function(x) rgb(x[3], x[4], x[5]))
      p <- plot_ly(triplets, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Cluster) %>%
        add_markers(color=I(rgbExp), size=~Pct, sizes=c(1000,10000)) %>%
        layout(scene = list(xaxis=list(title='Red'),
                            yaxis=list(title='Green'),
                            zaxis=list(title='Blue')), title=paste(imNames[i], path))
      print(p)
      invisible(readline(prompt="Press [enter] to continue or [esc] to exit the loop"))
    }
  } else {
    triplets <- fishList[[r]]
    rgbExp <- apply(triplets/255, 1, function(x) rgb(x[3], x[4], x[5]))
    p <- plot_ly(triplets, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Cluster) %>%
      add_markers(color=I(rgbExp), size=~Pct, sizes=c(1000,10000)) %>%
      layout(scene = list(xaxis=list(title='Red'),
                          yaxis=list(title='Green'),
                          zaxis=list(title='Blue')), title=imNames[r])
    print(p)
  }
}

fishList <- csvToList(paste('./GQIOutput/', csvDir[2], '/out.csv', sep=''))

group <- names(fishList)
# group <- group06
newList <- vector("list", length(group))
for (i in 1:length(group)) {
  newList[[i]] <- fishList[[group[i]]]
  names(newList)[i] <- group[i]
} 
newDF <- newList[[1]]
newDF$Image <- rep(names(newList)[1], dim(newList[[1]])[1])

for (i in 2:length(newList)) {
  tempDF <- newList[[i]]
  tempDF$Image <- rep(names(newList)[i], dim(newList[[i]])[1])
  newDF <- rbind(newDF, tempDF)
}

rgbExp <- apply(newDF[,3:5]/255, 1, function(x) rgb(x[1], x[2], x[3]))
p <- plot_ly(newDF, x = ~R, y = ~G, z = ~B, size=~Pct, color=~Cluster, text = ~paste('Image: ', Image)) %>%
  add_markers(color=I(rgbExp), size=~Pct, sizes=c(500,10000)) %>%
layout(scene = list(xaxis=list(title='Red'), yaxis=list(title='Green'), zaxis=list(title='Blue')), title=paste(imNames[i], path))
print(p)


# mostly yellow with black accents (spots and bars)
group01 <- c("chsem_04", "chraf_03", "chben_05",
             "chaurip_03", "chand_03", "chcit_04",
             "chple_01", "chfre_02")

# yellow, white, and black predominant
group02 <- c("chadi_05", "chauri_01", "chfal_04",
             "choxy_03", "chmel_04", "chocel_04",
             "chvag_03", "folon_02")

# black and white
group03 <- c("prguy_01", "hezos_03", "chmey_03",
             "amhow_02", "charg_02")

# stripes
group04 <- c("amhow_02", "checur_01", "cheros_01",
             "chetru_05", "chhoe_01")

# yellow and white
group05 <- c("chxant_03", "chxan_04", "chtrif_04",
             "chpau_01", "chmer_05")

# red accents
group06 <- c("chcol_04", "chfla_02", "chlar_04",
             "chpau_01", "chtrif_04")






colorPlot3d(paste('./GQIOutput/', csvDir[2], '/out.csv', sep=''))

for (i in 1:dim(Rs)[1]) {
  triplets <- data.frame(R=as.numeric(Rs[i,]), G=as.numeric(Gs[i,]), B=as.numeric(Bs[i,]))
  
  rgbExp <- apply(triplets/255, 1, function(x) rgb(x[1], x[2], x[3]))
  
  scatterplot3d(triplets, pch=19, color = rgbExp, xlab = "R", ylab="G", zlab="B", main = tail(strsplit(as.character(test[i,1]), '/')[[1]], 1))
  
  invisible(readline(prompt="Press [enter] to continue or [esc] to exit the loop"))
}

