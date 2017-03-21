source('~/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/R Code/sourceMe.R')
library(ggplot2)
library(reshape2)

group <- c(group01, group02)

dark <- c("chcol_04", "chdae_04", "chfla_02", "chlar_04",
          "chmes_04", "chtric_03", "hezos_03")
light <- c("chcap_02", "chcit_04", "chfre_02", "chmer_05",
           "chmey_04", "chorn_01", "chvag_03", "chxan_04")
group <- c(dark, light)

# NEXT STEPS:
# 1) take cluster size into account - maybe artificially make 100 points distributed by cluster size?
# 2) try another test set
# 3) HSV hues instead?
# 4) figure out some way to map distance matrix (heatmap?)
# 5) writeup!

# fishList <- csvToList('./Output/30Color/out.csv')
fishList <- csvToList('./GQIOutput/30Color/out.csv', normalize = F)
fishList <- reorderPointsHA(fishList)

darklightList <- subList(fishList, subVec = group)
darklightCDM <- colorDistMat(darklightList)
darklightMat <- darklightCDM$Distance.Matrix

BWYYList <- subList(fishList, subVec = c(group01, group02))
BWYYCDM <- colorDistMat(BWYYList)
BWYYMat <- BWYYCDM$Distance.Matrix

CDM <- colorDistMat(fishList)
mat <- CDM$Distance.Matrix-min(CDM$Distance.Matrix, na.rm=T)

melted_mat <- melt(mat)
ggplot(data = melted_mat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()+scale_fill_gradient2(low = "royalblue4", high = "goldenrod2", mid="ghostwhite", midpoint=mean(range(mat, na.rm=T))) + theme(axis.text.x = element_text(angle = 90, hjust = 1))



heatmap(BWYYMat, symm=TRUE, col=my_palette)

heatmap(darklightMat, symm=TRUE, col=my_palette)


colorPlot3dMulti('./Figures/Output/30Color/out.csv', group=c("chaetodon_lunula"))
mapColDist(BWYYList)
mapColDist(darklightList)

mapColDist(csvToList('./Figures/Obvious/Output/30Color/out.csv', normalize = T))
mapColDist(csvToList('./Figures/Obvious/Output/10Color/out.csv', normalize = F))

mapColDist(csvToList('./Figures/Output/50Color/out.csv', normalize = T))
mapColDist(csvToList('./Figures/Output/30Color/out.csv', normalize = F))

