setwd('~/Dropbox/Colorful_Fishinator/')
library(ggplot2)
library(reshape2)

# NEXT STEPS:
# streamline reading in multiple CSVs (loop over superdirectory)
# normalize each line/set of inertias to the 1-cluster inertia
# ...catterplots


# OK......HANG ON A SECOND
# library(devtools)
# install_github("Gibbsdavidl/CatterPlots")
library(CatterPlots)

# read in all the output CSVs
outputDirectories <- dir('./Out/', pattern='*Color')
lim <- length(outputDirectories)
imNames <- as.character(read.csv(paste('Out/', outputDirectories[1], '/out.csv', sep=''))$ID)

# for the record i tried an apply function here and it was more confusing and not faster :/
imNames2 <- vector()
for (i in 1:length(imNames)) {
  imNames2 <- c(imNames2, tail(unlist(strsplit(imNames[i], '/')), 1))
}

inertia <- data.frame(ID=imNames2)
  
for (i in 1:lim) { #change this to read 1:length(outputDirectories) - for now there's extra stuff in the OutTest folder so we're being clunky
  inertia <- cbind(inertia, read.csv(paste('Out/', outputDirectories[i], '/out.csv', sep=''))$Sum.of.Residuals)
}
colnames(inertia) <- c("ID", sapply(c(1:(dim(inertia)[2]-1)), function(i) paste(i, 'C', sep='')))

inertia[,2:dim(inertia)[2]] <- t(apply(inertia[,2:dim(inertia)[2]], 1, function(x) x/max(x)))


plot(c(1:6), inertia[1,2:dim(inertia)[2]], type='l')


df <- melt(inertia)

p <- ggplot(df, aes(variable, value, group=factor(ID))) + geom_line(aes(color=factor(ID)))
p <- p + xlab("Number of Clusters") + ylab("Residual Sum") + theme(legend.position="none")
p


purr <- catplot(xs=c(1:6), ys=unlist(inertia[1,2:dim(inertia)[2]]), 
                size=0.1, type="line", cat=4, catcolor=c(1,0,1,1),
                xlab="andrea", ylab="are you happy now")

purr <- catplot(xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]), 
                size=0.1, type="line", cat=4, catcolor=c(1,0,1,1),
                xlab="andrea", ylab="are you happy now")

cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))

cats(purr, xs=c(1:6), ys=unlist(inertia[2,2:dim(inertia)[2]]))

x <- -10:10
y <- -x^2 + 10
purr <- catplot(xs=x, ys=y, cat=3, catcolor=c(0,1,1,1))
cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))
