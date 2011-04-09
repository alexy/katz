library(RColorBrewer)
library(gplots)

heatclust <- function(m) {
  hc <- hclust(dist(m))
  clrno=3
  cols<-rainbow(clrno, alpha = 1)
  clstrs <- cutree(hc, k=clrno)
  ccols <- cols[as.vector(clstrs)]
#  heatcol<-colorRampPalette(c(3,1,2), bias = 1.0)(32)
  heatmap.2(as.matrix(m),dendrogram="row",Colv=F,col="heat.colors",trace="none",RowSideColors=ccols)
}


heatmaps <- function(m,infix,shift=0) {
	m.sims <- rownames(m)
	
	week.suffix <- c("0$","1wk","2wk","3wk","4wk")
	
	for (i in c(0,1,2,3)) { 
		sims <- m.sims[grep(week.suffix[i+shift+1],m.sims)]
		w <- m[c("dreps",sims),]
		pdf(paste("heatmap-",infix,"-",i,"wk.pdf",sep="")); 
		heatclust(w); 
		dev.off() 
	}
}


some.reps <- c(
"dreps","ureps","rreps","creps","lj1u","lj1m","lj1c",
"fg5uf1u","fg5mf1u[0-3](wk)?","fg5mf1c","fg5cf1cA",
"fg2uf05c","fg2cf05c"
#,"fg8uf05c","fg8cf05c"
,"fg5cf1cb1f","fg5cf1cb1t","fg5cf1cb6f","fg5cf1cb6t"
#,"fg5cf1cb567f","fg5cf1cb567t"
#,"fg5mf1ub1f","fg5mf1ub1t","fg5mf1ub6f","fg5mf1ub6t","fg5mf1ub567f","fg5mf1ub567t"
)

bucket.names <- c("sim","10","100","1000","10K","100K","1M","10M")

vashu.mat <- function(name,oself=F) {
	m <- read.table(name,row.names=1,col.names=bucket.names)
	m.sims <- rownames(m)
	
	m.sims.exclude <- m.sims[Reduce(function(r,x) c(r,grep(x,m.sims)),init=c(),c("0d","7m","B","C"))]
  m.sims.include <- m.sims[Reduce(function(r,x) c(r,grep(x,m.sims)),init=c(),some.reps)]
  m.sims.some    <- m.sims.include[!(m.sims.include %in% m.sims.exclude)]
  
  m1 <- m[m.sims.some,]
  
  infix <- gsub(".txt$","",name)
  
  if (oself) heatmaps(m1,infix,shift=1) else heatmaps(m1,infix)
}
  
  
  