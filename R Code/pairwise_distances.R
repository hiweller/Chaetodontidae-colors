source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')

csvDir <- dir('./GQIOutput/', pattern='*Color')
csvDir <- csvDir[c(2, 4:11, 1, 3)]

# turn data into list
fishList <- csvToList(paste('./Output/', csvDir[1], '/out.csv', sep=''))

colorPlot3dComp(paste('./Output/',csvDir[1], '/out.csv', sep=''), group=group04)

# plot a bunch of black, yellow, and white fishes
colorPlot3dMulti(paste('./Output/', csvDir[1], '/out.csv', sep=''), group=group02)

colorPlot3dMulti(paste('./Output/', csvDir[2], '/out.csv', sep=''), group=c('chmel_02'))

# color them by individual
colorPlot3dComp(paste('./Output/', csvDir[1], '/out.csv', sep=''), group=group06)

# when you just pair the clusters in their current order, no good:
plotColorPairs(subList(fishList, subVec = group02))

# but when you use LSAP...
plotColorPairs(fishList, orderPts=TRUE)
# test <- subList(fishList, names(fishList)[2:325])
plotColorPairs(subList(fishList, subVec = group02), orderPts=TRUE)
