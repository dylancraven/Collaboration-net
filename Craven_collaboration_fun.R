setwd('/home/dylan/ownCloud/documents/blog_Posts')

rm(list=ls())
###libraries & functions
require(reshape2)
require(dplyr)

devtools::install_github("briatte/ggnet")
library(ggnet)

library(network)
library(sna)
library(ggplot2)

#require(igraph)
#require(intergraph)

## data
dat<-read.delim("Craven_pubs.csv",sep=",",header=T)

datt<-select(dat,ID,Year,Author,Country_of_Affiliation)

summary(datt) # quick summary of data (number of articles, years, and articles per author)

# loop to create unique links (i.e. 'Author A - Author B') per publication

  nn<-length(unique(datt$ID))
  
  outt=c();
  for(i in 1:nn){
  
  b=subset(datt, datt$ID==(unique(datt$ID))[i]) 
  
  
  Article_ID<-unique(b$ID)
  Year<-unique(b$Year)
  
  b$Author<-droplevels(b$Author)
  
  b$Author<-as.character(b$Author)
  
  if(dim(b)[1]<2){
  dff$Author_1<-b$Author
  dff$Author_2<-b$Author
  dff$Article_ID<-Article_ID
  dff$Year<-Year}
  else{
  comb<-combn(b$Author,2,simplify=FALSE)
  
  n<-NROW(comb)
  
  dff<-data.frame(matrix(unlist(comb), nrow=n, byrow=T),stringsAsFactors=FALSE)
  colnames(dff)[1]<-"Author_1"
  colnames(dff)[2]<-"Author_2"
  dff$Article_ID<-Article_ID
  dff$Year<-Year}
  
  outt[[i]]<-rbind.data.frame(dff)
  }
  
authorz<-do.call(rbind,outt)

pais<-select(datt,ID,Author,Country_of_Affiliation)
colnames(pais)[2]<-"Author_1"
colnames(pais)[3]<-"Country_1"
colnames(pais)[1]<-"Article_ID"


authorz1<-merge(authorz,pais,by.y=c("Author_1","Article_ID"))

pais2<-select(datt,ID,Author,Country_of_Affiliation)
colnames(pais2)[2]<-"Author_2"
colnames(pais2)[3]<-"Country_2"
colnames(pais2)[1]<-"Article_ID"
                
authorz2<-merge(authorz1,pais2,by.y=c("Article_ID","Author_2"))
                
authorzz<-select(authorz2,Article_ID,Year,Author_1,Country_1,Author_2,Country_2)

### create data frame to give attributes to network vertices
## by country
## vertex labels = country of affiliation

authorzz$Country_1<-as.factor(authorzz$Country_1)
authorzz$Country_2<-as.factor(authorzz$Country_2)

# for the blog post, please note that i created subsets denoting before and after I finished graduate studies
#pre<-subset(authorzz,Year<2013) 
#post<-subset(authorzz,Year>2012)

## create network object 

land<-select(authorzz,Country_1,Country_2) #or pre

net2 = network(land, directed = TRUE)


####give attributes to vertices
#### here, i change the color of vertices to reflect different geographical regions
#### Continents
 
cont<-data.frame(unique(network.vertex.names(net2)))
colnames(cont)[1]<-"Country"
cont$Country<-as.character(cont$Country)
cont$Cont<-ifelse(cont$Country=="US"|cont$Country=="Canada","North America",NA)
cont$Cont<-ifelse(cont$Country=="Japan","East Asia",cont$Cont)
cont$Cont<-ifelse(cont$Country=="Australia","Australasia",cont$Cont)
cont$Cont<-ifelse(cont$Country=="Austria"|cont$Country=="Belgium"|cont$Country=="Czech Republic"|cont$Country=="Denmark"|cont$Country=="Denmark"|cont$Country=="France"|cont$Country=="Germany"|cont$Country=="Holland"|cont$Country=="Hungary"|cont$Country=="Ireland"|cont$Country=="Poland"|cont$Country=="Slovak Republic"|cont$Country=="Spain"|cont$Country=="Sweden"|cont$Country=="Switzerland"|cont$Country=="UK","Europe",cont$Cont)
cont$Cont<-ifelse(is.na(cont$Cont)==TRUE,"Latin America",cont$Cont)


x = data.frame(Country = network.vertex.names(net2))

x = merge(x, cont, by = "Country", sort = FALSE)$Cont

net2 %v% "Continent" = as.character(x)

y <- RColorBrewer::brewer.pal(5, "Set2")[ c(4, 1, 2, 3, 5) ]  ## there are many palette options when there are <10 groups
names(y) =  unique(x)

## call to ggnet
## the integration with ggplot2 is very handy because a lot of the tricks to clean legends in normal ggplot2 figures can
## be used for network figures too (e.g., 'guides')


all<-ggnet2(net2, label=TRUE,label.size=2, mode = "kamadakawai",size="degree", color="Continent",color.palette=y,
             layout.par = list(cell.jitter = 0.2) ,legend.position="bottom",edge.color="grey80")+
guides(size =FALSE ,color = guide_legend(override.aes = list(size = 2),ncol=2))


png("Country_Connections_overall.png",height=4, width=6,units="in",bg="transparent",res=300,type="cairo-png")

all
dev.off()

