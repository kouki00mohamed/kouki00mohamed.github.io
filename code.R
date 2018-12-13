library(readxl)
hasc<-read.csv("C:/Users/kouki/Desktop/kouki.github.io/codes_maps_tunisia (1).csv",sep = ";",header = TRUE)

code= read_xlsx("C:/Users/kouki/Desktop/kouki.github.io/base.xlsx")
View(code)
# ajouter hasc aux base pop chomage pop active
i=match(code$Gouvernorat,hasc$Gouvernorat)
View(i)
code$code=hasc$HASC_1[i]

View(code)
#regler la table finale

colnames(code)<-c("Area","population","HASC_1")
codemap=code[,c(1,3,2)]
View(codemap)
#creer leaflet
library(leaflet)
library(raster)
tnMAP=getData(name = "GADM", country="TUN" , level = 1)

code=codemap
i=match(tnMAP$HASC_1,code$HASC_1)
View(i)
tnMAP=cbind.Spatial(tnMAP,code[i,])

tnMAP@data=tnMAP@data[,-12]
View(tnMAP@data)
col=colorRampPalette(c( "#66ccff","#ff9900"))                                                                         
e=col(24) 

tnMAP@data$population=as.numeric(tnMAP@data$population)
pal=colorNumeric(e,domain = tnMAP@data$population)
leaflet(tnMAP)%>%addProviderTiles(providers$CartoDB.Positron )%>% addPolygons(stroke = FALSE , smoothFactor = 0.2 ,fillColor = pal(tnMAP@data$population), fillOpacity = 0.8 ,    popup = paste(tnMAP@data$Area,": ",tnMAP@data$population,"(Millier)" 
                                                                                                                                                                                             ))%>%  addLegend(pal = pal , values = ~population , opacity = 1.5 , position = "bottomright" )

