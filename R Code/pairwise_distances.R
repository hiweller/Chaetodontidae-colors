source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')

library(spatstat)
library(clue)

csvDir <- dir('./GQIOutput/', pattern='*Color')
csvDir <- csvDir[c(2, 4:11, 1, 3)]

# turn data into list
fishList <- csvToList(paste('./Output/', csvDir[1], '/out.csv', sep=''))

# yellow, white, and black predominant
group <- c("chadi_05", "chauri_01", "chfal_04",
             "choxy_03", "chmel_04", "chocel_04",
             "chvag_03", "folon_02")

colorPlot3dComp(paste('./Output/',csvDir[1], '/out.csv', sep=''), group=group[1:2])

bwy <- subList(fishList, group)
T1 <- pp3(bwy[[1]][,3], bwy[[1]][,4], bwy[[1]][,5], box3(c(0,255)))
T2 <- pp3(bwy[[2]][,3], bwy[[2]][,4], bwy[[2]][,5], box3(c(0,255)))

# matrix of the distance from each point in A to each point in B
# get pairs (1 from each column) that minimize the overall distance?
# wait... i think this is actually doable. holy shit!
distances <- crossdist(T1, T2)
solve_LSAP(distances, maximum=FALSE)

# THIS WORKS THANK GOD FOR OPEN SOURCE PACKAGE DISTRIBUTION!!!

