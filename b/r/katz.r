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