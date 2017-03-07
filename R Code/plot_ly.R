source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')
library(jpeg)
library(scatterplot3d)
library(plotly)
library(reshape2)
library(vegan)
library(spatstat)

imDir <- dir('./GoodQualityImages/', pattern='*.jpg')
csvDir <- dir('./GQIOutput/', pattern='*Color')
csvDir <- csvDir[c(2, 4:11, 1, 3)]

# turn data into list
fishList <- csvToList(paste('./Output/', csvDir[1], '/out.csv', sep=''))




# get the names of the images themselves
imNames <- as.character(read.csv(paste('./Output/', csvDir[1], '/out.csv', sep=''))$ID)

imNames <- as.character(sapply(imNames, function(x) tail(unlist(strsplit(x, '/')), 1)))

# species (c1) and filename (c2) for each image
nameRef <- read.csv('Chaet_Fishinator_Photo_Sources.csv')[,1:2]

# original images which also have clustered images
overlap <- nameRef[which(nameRef$File.Name %in% imNames),] # 
matchFish <- sapply(imNames, function(x) as.character(overlap[match(x,overlap[,2]),]$Species))

species <- unique(matchFish)

for (i in 1:length(species)) {
  group <- names(which(matchFish==species[i]))
  
  p <- colorPlot3dComp(paste('./Output/', csvDir[2], '/out.csv', sep=''), group=group, title=species[i])
  print(p)
  
  invisible(readline(prompt="Press [enter] to continue or [esc] to exit the loop"))
}

p <- colorPlot3dComp(paste('./Output/', csvDir[2], '/out.csv', sep=''), group=names(which(matchFish="Chaetodon mesoleucos")))


group <- group06

# pull out sublist from main list
miniList <- vector("list", length(group))
miniList <- lapply(c(1:length(group)), function(x) miniList[[x]] <- fishList[[group[x]]])
names(miniList) <- group

# flatten list into one DF for plotting; add a column of image names for identification in plot
newDF <- miniList[[1]]
newDF$Image <- rep(names(miniList)[1], dim(miniList[[1]])[1])

for (i in 2:length(miniList)) {
  tempDF <- miniList[[i]]
  tempDF$Image <- rep(names(miniList)[i], dim(miniList[[i]])[1])
  newDF <- rbind(newDF, tempDF) }
  

rgbExp <- apply(miniList[[1]][,3:5]/255, 1, function(x) rgb(x[1], x[2], x[3]))

scene <- list(xaxis=list(title='Red', linecolor=toRGB('red'), linewidth=6, range=c(0,255)), 
              yaxis=list(title='Green', linecolor=toRGB('green'), linewidth=6, range=c(0,255)), 
              zaxis=list(title='Blue', linecolor=toRGB('blue'), linewidth=6, range=c(0,255)), 
              camera = list(eye = list(x = -1.25, y = 1.25, z = 1.25)))

p <- plot_ly(newDF, x = ~R, y = ~G, z = ~B, 
             size=~Pct, color=~Image, 
             text = ~paste('Image: ', Image)) %>%
  
  add_markers(size=~Pct, sizes=c(500,5000)) %>%
  
  layout(scene = scene, title=names(miniList)[1])

print(p)

# chart_link <- plotly_POST(p, filename = 'test')
# chart_link




s <- signup('hiweller', 'hiweller@uchicago.edu')
Sys.setenv("plotly_username" = "hiweller")
Sys.setenv("plotly_api_key" = "ov1wD4YIF9qHWL6a6yy8")













colorPlot3dMulti(paste('./Output/', csvDir[2], '/out.csv', sep=''), group=group06)


fishList <- csvToList(paste('./GQIOutput/', csvDir[1], '/out.csv', sep=''))

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
group03 <- c("prguy_01", "hezos_03", "chmey_04",
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

