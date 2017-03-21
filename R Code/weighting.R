test <- csvToList('./Figures/Output/30Color/out.csv')

tf <- test[[1]]

dim(tf)
h <- 100
s <- 1


bar <- matrix(NA, nrow=h, ncol=3)
for (i in 1:dim(tf)[1]) {
  row <- tf[i,]
  multiplier <- h*row$Pct
  t <- round(s+multiplier)
  bar[s:t,] <- 
  s <- t
}
print(t)

df <- data.frame(a=1:2, b=letters[1:2]) 
df[rep(seq_len(nrow(df)), each=2),]

df.expanded <- df[rep(row.names(df), df$freq), 1:2]


pct2 <- round_preserve_sum(tf$Pct, digits=2)
df.expanded <- tf[rep(row.names(tf), h*pct2),]

round_preserve_sum <- function(x, digits = 0) {
  up <- 10 ^ digits
  x <- x * up
  y <- floor(x)
  indices <- tail(order(x-y), round(sum(x)) - sum(y))
  y[indices] <- y[indices] + 1
  y / up
}
