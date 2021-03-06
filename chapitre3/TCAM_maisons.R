#TCAM_maisons

library(sf)
library(SpatialPosition)
library(cartography)
library(dplyr)
library(tidyr)
library(stringr)   
library(tidyverse)


TCAM_prix <- Typo_1999_2012_carreaux200_Maison_36693tiles
TCAM_prix<- TCAM_prix[,c(1:13)]

CAGR <- function(df, variables){
  CAGR <- vector()
  cagr <- list()
  for(i in 2:length(variables)){
    
    # vector def
    pop1 <- df[, variables[i-1]]
    pop2 <- df[, variables[i]]
    year1 <- as.integer(str_replace_all(variables[i-1], "[A-Z]", replacement = ""))
    year2 <- as.integer(str_replace_all(variables[i], "[A-Z]", replacement = ""))
    # compute n and CAGR
    n <- year2 - year1
    result <- ((pop2/pop1)^(1/n)-1)*100
    cagr[[length(cagr) + 1]] <- result 
  }
  
  return(cagr)
} 

#discrter TCAM
TCAM_prix_discret<-CAGR(TCAM_prix,variables = c(3,8,13) )
TCAM_prix_discret <- as.data.frame(do.call(cbind, TCAM_prix_discret))
TCAM_prix_discret<-TCAM_prix_discret%>%gather ("key", "values", c(1:2))
getBreaks(TCAM_prix_discret$values,nclass = 5,method="quantile")
breaks_ratio<-c(-27.4998224,0,2.8050096,13.6877520,16.9644284,67.5338286)
######
TCAM_prix_2<-CAGR(TCAM_prix,variables = c(3,8,13) )
TCAM_prix_2 <- as.data.frame(do.call(cbind, TCAM_prix_2))
TCAM_prix <- cbind(TCAM_prix,TCAM_prix_2)


setwd("~/Shapes/datidf")
list.files()
carreauInsee200 <- st_read("car200m_idf_reparGeom.shp",
                           stringsAsFactors = FALSE) %>%
  st_cast("POLYGON") %>%
  st_sf(stringsAsFactors = FALSE, crs = 2154, sf_column_name = "geometry")

carreauInsee200 <-  st_transform(carreauInsee200, crs = 2154)
carreauInsee200$Carreau_ID<-1:length(carreauInsee200$TARGET_FID)

# #Mask
Mask_st_200 <- st_union(carreauInsee200)
Mask_st_200<-st_sf(id = 1, geometry =Mask_st_200 )

# Mask_simplified <-
Mask_st_200 <- Mask_st_200 %>%
  st_buffer(dist = 200) %>%
  st_buffer(dist = -400) %>%
  st_simplify(preserveTopology = FALSE, dTolerance = 200) %>%
  st_buffer(200)



setwd("~/Shapes/shpIDF_dep_lamb93")
list.files()

lim_IDF.st<- st_read("ile-de-france.shp",
                     stringsAsFactors = FALSE) %>%
  st_cast("POLYGON") %>%
  st_sf(stringsAsFactors = FALSE, crs = 2154, sf_column_name = "geometry")
lim_IDF.st  <-  st_transform(lim_IDF.st , crs = 2154)

#pour carreau Insee
Cadrillage_200<- carreauInsee200%>%
  st_sf(geometry = .)

Cadrillage_200_jointure<-left_join(Cadrillage_200, TCAM_prix, by="Carreau_ID")


# Cadrillage_200_jointure<- Cadrillage_200_jointure%>%
#   # select(-c(4:7))%>%
#   group_by(Carreau_ID)%>%
#   filter_all(all_vars(!is.na(.)))

# Cadrillage_200_jointure<- Cadrillage_200_jointure%>%
#   st_sf(geometry = .)
# cadrillage_200_spdf<-as(Cadrillage_200_jointure, "Spatial")
# proj4string(cadrillage_200_spdf) <-CRS("+init=epsg:2154")
# cadrillage_200_spdf<- spTransform(cadrillage_200_spdf, "+init=epsg:2154")
col_mask<-"#878787"
opacity_mask <-60
col_mask <- paste0(col_mask, opacity_mask)
cols=carto.pal(pal1 = 'blue.pal', n1 = 1 ,pal2='red.pal', n2=4)

dev.off()

setwd("~/Sauvegarde_figures/TCAM")
pdf(file="TCAM_1999_2007_carraux200_maisons_36693tiles.pdf",width = 10, height = 5)

plot(Mask_st_200, col= col_mask, border=NA, main=NULL)

choroLayer(x=Cadrillage_200_jointure,
           var = "V1",
           col = cols,
           breaks = breaks_ratio,
           border = NA,
           legend.title.txt = "1999_2007",
           legend.pos = "topright",add=T )
plot(lim_IDF.st$geometry,add=T)


dev.off()

setwd("~/Sauvegarde_figures/TCAM")
pdf(file="TCAM_2007_2012_carraux200_maisons_36693tiles.pdf",width = 10, height = 5)
plot(Mask_st_200, col= col_mask, border=NA, main=NULL)

choroLayer(x=Cadrillage_200_jointure,
           var = "V2",
           col = cols,
           breaks = breaks_ratio,
           border = NA,
           legend.title.txt = "2007_2012",
           legend.pos = "topright",add=T )
plot(lim_IDF.st$geometry,add=T)

dev.off()



##########

#TCAM_maisons 1000

library(sf)
library(SpatialPosition)
library(cartography)
library(dplyr)
library(tidyr)
library(stringr)   
library(tidyverse)


TCAM_prix <- Typo_1999_2012_carreaux1000_Maison_5030tiles
TCAM_prix<- TCAM_prix[,c(1:13)]

CAGR <- function(df, variables){
  CAGR <- vector()
  cagr <- list()
  for(i in 2:length(variables)){
    
    # vector def
    pop1 <- df[, variables[i-1]]
    pop2 <- df[, variables[i]]
    year1 <- as.integer(str_replace_all(variables[i-1], "[A-Z]", replacement = ""))
    year2 <- as.integer(str_replace_all(variables[i], "[A-Z]", replacement = ""))
    # compute n and CAGR
    n <- year2 - year1
    result <- ((pop2/pop1)^(1/n)-1)*100
    cagr[[length(cagr) + 1]] <- result 
  }
  
  return(cagr)
} 

#discrter TCAM
TCAM_prix_discret<-CAGR(TCAM_prix,variables = c(3,8,13) )
TCAM_prix_discret <- as.data.frame(do.call(cbind, TCAM_prix_discret))
TCAM_prix_discret<-TCAM_prix_discret%>%gather ("key", "values", c(1:2))
getBreaks(TCAM_prix_discret$values,nclass = 5,method="quantile")
breaks_ratio<-c(-11.663559,0, 1.139756,14.845423,16.367480,26.749287)
######
TCAM_prix_2<-CAGR(TCAM_prix,variables = c(3,8,13) )
TCAM_prix_2 <- as.data.frame(do.call(cbind, TCAM_prix_2))
TCAM_prix <- cbind(TCAM_prix,TCAM_prix_2)


setwd("~/Shapes/datidf")
list.files()
carreauInsee1000 <- st_read("car1000m_idf_reparGeom.shp",
                            stringsAsFactors = FALSE) %>%
  st_cast("POLYGON") %>%
  st_sf(stringsAsFactors = FALSE, crs = 2154, sf_column_name = "geometry")

carreauInsee1000 <-  st_transform(carreauInsee1000, crs = 2154)
carreauInsee1000$Carreau_ID<-1:length(carreauInsee1000$id_c1000)

# #Mask
Mask_st_1000 <- st_union(carreauInsee1000)
Mask_st_1000<-st_sf(id = 1, geometry =Mask_st_1000 )

# Mask_simplified <-
Mask_st_1000 <- Mask_st_1000 %>%
  st_buffer(dist = 500) %>%
  st_buffer(dist = -1000) %>%
  st_simplify(preserveTopology = FALSE, dTolerance = 500) %>%
  st_buffer(500)


setwd("~/Shapes/shpIDF_dep_lamb93")
list.files()

lim_IDF.st<- st_read("ile-de-france.shp",
                     stringsAsFactors = FALSE) %>%
  st_cast("POLYGON") %>%
  st_sf(stringsAsFactors = FALSE, crs = 2154, sf_column_name = "geometry")
lim_IDF.st  <-  st_transform(lim_IDF.st , crs = 2154)

#pour carreau Insee
Cadrillage_1000<- carreauInsee1000%>%
  st_sf(geometry = .)

Cadrillage_1000_jointure<-left_join(Cadrillage_1000, TCAM_prix, by="Carreau_ID")


# Cadrillage_1000_jointure<- Cadrillage_1000_jointure%>%
#   # select(-c(4:7))%>%
#   group_by(Carreau_ID)%>%
#   filter_all(all_vars(!is.na(.)))

# Cadrillage_1000_jointure<- Cadrillage_1000_jointure%>%
#   st_sf(geometry = .)
# cadrillage_1000_spdf<-as(Cadrillage_1000_jointure, "Spatial")
# proj4string(cadrillage_1000_spdf) <-CRS("+init=epsg:2154")
# cadrillage_1000_spdf<- spTransform(cadrillage_1000_spdf, "+init=epsg:2154")
col_mask<-"#878787"
opacity_mask <-60
col_mask <- paste0(col_mask, opacity_mask)
cols=carto.pal(pal1 = 'blue.pal', n1 = 1 ,pal2='red.pal', n2=4)

dev.off()

setwd("~/Sauvegarde_figures/TCAM")
pdf(file="TCAM_1999_2007_carraux1000_maisons_5030tiles.pdf",width = 10, height = 5)

plot(Mask_st_1000, col= col_mask, border=NA, main=NULL)

choroLayer(x=Cadrillage_1000_jointure,
           var = "V1",
           col = cols,
           breaks = breaks_ratio,
           border = NA,
           legend.title.txt = "1999_2007",
           legend.pos = "topright",add=T )
plot(lim_IDF.st$geometry,add=T)


dev.off()

setwd("~/Sauvegarde_figures/TCAM")
pdf(file="TCAM_2007_2012_carraux1000_maisons_5030tiles.pdf",width = 10, height = 5)
plot(Mask_st_1000, col= col_mask, border=NA, main=NULL)

choroLayer(x=Cadrillage_1000_jointure,
           var = "V2",
           col = cols,
           breaks = breaks_ratio,
           border = NA,
           legend.title.txt = "2007_2012",
           legend.pos = "topright",add=T )
plot(lim_IDF.st$geometry,add=T)

dev.off()


##########################################




TCAM_prix <- Typo_1999_2012_533communes_Maisons
TCAM_prix<- TCAM_prix[,c(1:13)]

CAGR <- function(df, variables){
  CAGR <- vector()
  cagr <- list()
  for(i in 2:length(variables)){
    
    # vector def
    pop1 <- df[, variables[i-1]]
    pop2 <- df[, variables[i]]
    year1 <- as.integer(str_replace_all(variables[i-1], "[A-Z]", replacement = ""))
    year2 <- as.integer(str_replace_all(variables[i], "[A-Z]", replacement = ""))
    # compute n and CAGR
    n <- year2 - year1
    result <- ((pop2/pop1)^(1/n)-1)*100
    cagr[[length(cagr) + 1]] <- result 
  }
  
  return(cagr)
} 

#discrter TCAM
TCAM_prix_discret<-CAGR(TCAM_prix,variables = c(3,8,13) )
TCAM_prix_discret <- as.data.frame(do.call(cbind, TCAM_prix_discret))
TCAM_prix_discret<-TCAM_prix_discret%>%gather ("key", "values", c(1:2))
getBreaks(TCAM_prix_discret$values,nclass = 5,method="quantile")
breaks_ratio<-c(-15.7002515,0,2.0900900,14.2580939,16.8117034,31.1295121)
######
TCAM_prix_2<-CAGR(TCAM_prix,variables = c(3,8,13) )
TCAM_prix_2 <- as.data.frame(do.call(cbind, TCAM_prix_2))
TCAM_prix <- cbind(TCAM_prix,TCAM_prix_2)


setwd("~/Shapes/IRIS")
list.files()

IrisInsee<- st_read("IRIS_LAMB93_IDF_2008.shp",
                    stringsAsFactors = FALSE) %>%
  st_cast("POLYGON") %>%
  st_sf(stringsAsFactors = FALSE, crs = 2154, sf_column_name = "geometry")
IrisInsee  <-  st_transform(IrisInsee , crs = 2154)
# "simplifier geometry"
IrisInsee  <- st_buffer(IrisInsee, 0)


#obtenir shape commune par aggregation 
CommunesInsee<- IrisInsee%>% 
  group_by(DepCom)%>%
  summarize()



#departement
setwd("~/Shapes/shpIDF_dep_lamb93")
list.files()
DepInsee<- st_read("ile-de-france.shp",
                   stringsAsFactors = FALSE) %>%
  st_cast("POLYGON") %>%
  st_sf(stringsAsFactors = FALSE, crs = 2154, sf_column_name = "geometry")
DepInsee <-  st_transform(DepInsee, crs = 2154)

#pour carreau Insee

str(CommunesInsee)
CommunesInsee$DepCom<-as.integer(CommunesInsee$DepCom)
CommunesInsee_jointure<-left_join(CommunesInsee, TCAM_prix, by="DepCom")


# Cadrillage_1000_jointure<- Cadrillage_1000_jointure%>%
#   # select(-c(4:7))%>%
#   group_by(Carreau_ID)%>%
#   filter_all(all_vars(!is.na(.)))

# Cadrillage_1000_jointure<- Cadrillage_1000_jointure%>%
#   st_sf(geometry = .)
# cadrillage_1000_spdf<-as(Cadrillage_1000_jointure, "Spatial")
# proj4string(cadrillage_1000_spdf) <-CRS("+init=epsg:2154")
# cadrillage_1000_spdf<- spTransform(cadrillage_1000_spdf, "+init=epsg:2154")
col_mask<-"#878787"
opacity_mask <-60
col_mask <- paste0(col_mask, opacity_mask)
cols=carto.pal(pal1 = 'blue.pal', n1 = 1 ,pal2='red.pal', n2=4)

dev.off()

setwd("~/Sauvegarde_figures/TCAM")
pdf(file="TCAM_1999_2007_communes_maisons_533tiles.pdf",width = 10, height = 5)



choroLayer(x=CommunesInsee_jointure,
           var = "V1",
           col = cols,
           breaks = breaks_ratio,
           border = NA,
           legend.title.txt = "1999_2007",
           legend.pos = "topright" )
plot(lim_IDF.st$geometry,add=T)


dev.off()

setwd("~/Sauvegarde_figures/TCAM")
pdf(file="TCAM_2007_2012_communes_maisons_533tiles.pdf",width = 10, height = 5)

choroLayer(x=CommunesInsee_jointure,
           var = "V2",
           col = cols,
           breaks = breaks_ratio,
           border = NA,
           legend.title.txt = "2007_2012",
           legend.pos = "topright" )
plot(lim_IDF.st$geometry,add=T)

dev.off()
