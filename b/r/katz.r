library(RColorBrewer)
library(gplots)
heatclust <- function(m) {
  hc <- hclust(dist(m))
  clrno=3
  cols<-rainbow(clrno, alpha = 1)
  clstrs <- cutree(hc, k=clrno)
  ccols <- cols[as.vector(clstrs)]
  heatcol<-colorRampPalette(c(3,1,2), bias = 1.0)(32)
  heatmap.2(as.matrix(m), Rowv=as.dendrogram(hc),col=heatcol,trace="none",RowSideColors=ccols)
}

bucket.names <- c("sim","10","100","1000","10K","100K","1M","10M")

df <- read.table("sims-features.txt",header=T,row.names=1,na.strings="-")
sf <- df[2:dim(df)[1],]
but4wk <- rownames(sf[sf$week<=3,])

m <- read.table("medians-srates.txt",row.names=1,col.names=bucket.names)

dm <- as.matrix(dist(m))
rownames(dm) <- rownames(m)
colnames(dm) <- rownames(m)
dmdreps <- sort(dm["dreps",])
dmdreps <- dmdreps[names(dmdreps)!="dreps"]

# names(sort(dmdreps[but4wk]))

dmdreps.sf <- rep(0.,dim(sf)[1])
names(dmdreps.sf) <- rownames(sf)
dmdreps.sf[names(dmdreps)] <- dmdreps

m.sims <- rownames(m)
m.sims.wk0 <- m.sims[grep("0$",m.sims)]
m.sims.wk1 <- m.sims[grep("1wk",m.sims)]
m.sims.wk2 <- m.sims[grep("2wk",m.sims)]
m.sims.wk3 <- m.sims[grep("3wk",m.sims)]
m.0wk <- m[c("dreps",m.sims.wk0),]
m.1wk <- m[c("dreps",m.sims.wk1),]
m.2wk <- m[c("dreps",m.sims.wk2),]
m.3wk <- m[c("dreps",m.sims.wk3),]

m.sims.fg0 <-   m.sims[grep("fg.*0$",m.sims)]
m.sims.fg1wk <- m.sims[grep("fg.*1wk",m.sims)]
m.sims.fg2wk <- m.sims[grep("fg.*2wk",m.sims)]

m.fg1wk <- m[c("dreps",fg1wk),]
m.fg2wk <- m[c("dreps",fg2wk),]

d <- read.table("medians-overx-dreps.txt",row.names=1,col.names=bucket.names)
rbind(d,dreps=rep(1.0,7))
d.sims <- rownames(m)
d.sims.wk0 <- d.sims[grep("0$",d.sims)]
d.sims.wk1 <- d.sims[grep("1wk",d.sims)]
d.sims.wk2 <- d.sims[grep("2wk",d.sims)]
d.sims.wk3 <- d.sims[grep("3wk",d.sims)]
d.0wk <- m[c("dreps",d.sims.wk0),]
d.1wk <- m[c("dreps",d.sims.wk1),]
d.2wk <- m[c("dreps",d.sims.wk2),]
d.3wk <- m[c("dreps",d.sims.wk3),]

# ds  <- c(d.0wk,...) fails as it glues them together!  Need a list instead:
ds <- list(d.0wk,d.1wk,d.2wk,d.3wk)
for (i in c(0,1,2,3)) { pdf(paste("heatmap-overx-dreps-medians-",i,"wk.pdf",sep="")); heatclust(ds[[i+1]]); dev.off() }

cb.rows <- m.rows[grep("cb",m.rows)]
m.cb <- m[cb.rows,]
m.cb.d <- rbind(m.cb,dreps=rep(1.0,7))

s <- read.table("sbucks-ments-star-med-medians.txt",row.names=1,col.names=bucket.names)
s.sims <- rownames(s)
s.sims.wk0 <- s.sims[grep("0$",s.sims)]
s.sims.wk1 <- s.sims[grep("1wk",s.sims)]
s.sims.wk2 <- s.sims[grep("2wk",s.sims)]
s.sims.wk3 <- s.sims[grep("3wk",s.sims)]
s.0wk <- s[c("dreps",s.sims.wk0),]
s.1wk <- s[c("dreps",s.sims.wk1),]
s.2wk <- s[c("dreps",s.sims.wk2),]
s.3wk <- s[c("dreps",s.sims.wk3),]

s <- abs(log(s))
s <- s[apply(s,1,function(row) max(row) < Inf),]

v <- read.table("vols4-re-norm-medians.txt",row.names=1,col.names=bucket.names)
v.sims <- rownames(v)
v.sims.wk0 <- v.sims[grep("0$",v.sims)]
v.sims.wk1 <- v.sims[grep("1wk",v.sims)]
v.sims.wk2 <- v.sims[grep("2wk",v.sims)]
v.sims.wk3 <- v.sims[grep("3wk",v.sims)]
v.0wk <- v[c("dreps",v.sims.wk0),]
v.1wk <- v[c("dreps",v.sims.wk1),]
v.2wk <- v[c("dreps",v.sims.wk2),]
v.3wk <- v[c("dreps",v.sims.wk3),]

s0 <- s
s <- s[1:172,]

...

s <- s0[173:238,]
some.ereps <- c("dreps","ureps0","ureps1wk","ureps2wk","ureps3wk","ereps0","ereps1wk","ereps2wk","ereps3wk","rreps7m0","rreps7m1wk","rreps7m2wk","rreps7m3wk","fg5uf1m0","fg5uf1m1wk", "fg5uf1m2wk","fg5uf1m3wk","fg5mf1m0","fg5mf1m1wk","fg5mf1m2wk","fg5mf1m3wk","fg8uf05c0d0","fg8uf05c0d1wk","fg8uf05c0d2wk","fg8uf05c0d3wk","fg5cf1cA0","fg5cf1cA1wk","fg5cf1cA2wk","fg5cf1cA3wk")
ereps.breps <- c(some.ereps,rownames(s0)[173:238])

s <- s0[s.ereps.breps,]

v.rownames <- rownames(v)
breps <- v.rownames[grep("cb",v.rownames)]
ereps.breps <- c(some.ereps,breps)

v0 <- v
v <- v0[ereps.breps,]
...
nobs <- !(rownames(v0) %in% breps)
v <- v0[nobs,]
...
