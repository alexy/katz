library(RColorBrewer)
library(gplots)

heatclust <- function(m) {
  hc <- hclust(dist(m))
  clrno=3
  cols<-rainbow(clrno, alpha = 1)
  clstrs <- cutree(hc, k=clrno)
  ccols <- cols[as.vector(clstrs)]
#  heatcol<-colorRampPalette(c(3,1,2), bias = 1.0)(32)
  heatmap.2(as.matrix(m),dendrogram="row",Colv=F,col="heat.colors",trace="none",RowSideColors=ccols,margins=c(10,10))
}


heatmaps <- function(m,infix,shift=0) {
	m.sims <- rownames(m)
	
	week.suffix <- c("0$","1wk","2wk","3wk","4wk")
	
	for (i in c(0,1,2,3)) { 
		sims <- m.sims[grep(week.suffix[i+shift+1],m.sims)]
		w <- m[c("dreps",sims),]
		file <- paste("heatmap-",infix,"-",i,"wk.pdf",sep="")
		pdf(file,width=10)
		heatclust(w)
		dev.off() 
	}
}


some.reps <- c(
"dreps","ureps","ereps","rreps","creps","lj1u","lj1m","lj1c",
"fg5uf1u","fg5mf1u[0-3](wk)?","fg5mf1c","fg5cf1cA",
"fg2uf05c","fg2cf05c",
#"fg8uf05c","fg8cf05c",
"fg5cf1cb1f",
"fg5cf1cb2f",
"fg5cf1cb3f",
"fg5cf1cb4f",
"fg5cf1cb5f",
"fg5cf1cb6f",
"fg5cf1cb7f"
#,"fg5cf1cb567f","fg5cf1cb567t"
#,"fg5mf1ub1f","fg5mf1ub1t","fg5mf1ub6f","fg5mf1ub6t","fg5mf1ub567f","fg5mf1ub567t"
)

bucket.names <- c("sim","10","100","1000","10K","100K","1M","10M")

no.nan.df <- function(df) df[apply(df,1,function(row) !any(is.nan(row))),]
no.inf.df <- function(df) df[apply(df,1,function(row) !any(is.infinite(row))),]

good.ments <- function(d,a,b) { dd <- no.nan.df(d[,a:b]); no.inf.df(log10(dd)) }

my.table <- function(name) read.table(name,row.names=1,col.names=bucket.names)

vashu.mat <- function(name,oself=F,bylog=F,from.col=1,upto.col=7,m=NA) {
	if (!is.data.frame(m)) m <- my.table(name)
	
	m.sims <- rownames(m)
	
	m.sims.exclude <- m.sims[Reduce(function(r,x) c(r,grep(x,m.sims)),init=c(),c("0d","7m","B","C"))]
  m.sims.include <- m.sims[Reduce(function(r,x) c(r,grep(x,m.sims)),init=c(),some.reps)]
  m.sims.some    <- m.sims.include[!(m.sims.include %in% m.sims.exclude)]
  
  m1 <- m[m.sims.some,]
  if (bylog) m1 <- good.ments(m1,from.col,upto.col)
  
  infix <- gsub(".txt$","",name)
  
  if (oself) 
  {
    m1 <- rbind(m1,dreps=rep(1.0,7))
    heatmaps(m1,infix,shift=1) 
  } else {
    heatmaps(m1,infix)
  }
}
  
# srates-medians.txt
# overx-dreps-medians.txt
# overx-self-medians.txt
# vols4-me-norm-medians.txt
# vols4-re-norm-medians.txt
# sbucks-ments-star-med-medians.txt
# sbucks-reps-star-med-medians.txt
# b2bm-aftr-rel-medians.txt
# b2bm-befr-rel-medians.txt
# b2bm-self-rel-medians.txt
# b2br-aftr-rel-medians.txt
# b2br-befr-rel-medians.txt
# b2br-self-rel-medians.txt
# cstau.txt
# cstaubs-medians.txt

file.of <- function(base) paste(base,"-medians.txt",sep="")

simple.bases <- c(
  "srates","overx-dreps",
  "vols4-re-norm","vols4-me-norm",
  "b2br-self-rel",
  "cstaubs"
  )

log10.bases <- c(
  "sbucks-ments-star-med","sbucks-reps-star-med",
  "b2bm-self-rel"
  )

for (base in simple.bases) vashu.mat(file.of(base))
for (base in log10.bases)  vashu.mat(file.of(base),bylog=T)
vashu.mat(file.of("overx-self"),oself=T)
vashu.mat(file.of("b2br-befr-rel"),from.col=2)
vashu.mat(file.of("b2br-aftr-rel"),upto.col=6)
vashu.mat(file.of("b2bm-befr-rel"),from.col=2,bylog=T)
vashu.mat(file.of("b2bm-aftr-rel"),upto.col=6,bylog=T)
cstau <- read.table("cstau.txt",row.names=1,col.names=c("sim",paste("d",7:32,sep="")))
vashu.mat("cstau",m=cstau)
