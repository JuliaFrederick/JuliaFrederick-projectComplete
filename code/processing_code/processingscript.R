###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl)
library(dplyr)
library(DataCombine)
library(ggplot2)
library(stats)
library(reshape2)

#load data. path is relative to project directory.
plateres <- read.csv("./data/raw_data/CompiledPlateResults.csv")
tickpath <- read.csv("./data/raw_data/RawDataTickPathLoc.csv",na.strings = c("", "NA"))
    #Add NA to observations where pathogen species was not tested (all observations without neg/pos were not tested)
    #Where sex is blank it is a nymph or larval cluster which do not currently phenotypically sex -> add NA to those columns

#take a look at the data
dplyr::glimpse(tickpath)
#Note to self PME = Panola Mountain Ehrlichia

####Processing data####

#Renaming columns that don't convert from the .csv file
names(tickpath)[1]<-"Season"
names(tickpath)[5]<-"TransectNum"
names(tickpath)[6]<-"TickID"

#Renaming the "Borrelia.spp." column to not have the . at the end
names(tickpath)[14]<-"Borrelia.spp"
 
#Checking that all factors are coded correctly
levels(tickpath$Site)
  ##Some sites have spaces at the end that shouldn't be there, 
    #or have two names for the same place
tickpath$Site <- replace(tickpath$Site, tickpath$Site == "Sewee ", "Sewee")
tickpath$Site <- replace(tickpath$Site, tickpath$Site == "SRS North", "SRS N")
tickpath$Site <- replace(tickpath$Site, tickpath$Site == "SRS S ", "SRS S")
tickpath$Site <- replace(tickpath$Site, tickpath$Site == "Wando ", "Wando")
tickpath$Site <- replace(tickpath$Site, tickpath$Site == "FM McConnell", "McConnell")
tickpath$Site <- factor(tickpath$Site) 
levels(tickpath$Site)

levels(tickpath$Habitat)
  ##Subset of "Upland" has an extra space at the end
tickpath$Habitat <- replace(tickpath$Habitat, tickpath$Habitat == "Upland ", "Upland")
tickpath$Habitat <- factor(tickpath$Habitat) 
levels(tickpath$Habitat)

levels(tickpath$Species)
  ##Species has duplicated, one has an extra space at the end
  #"Ixodes scapularis"      "Ixodes scapularis " Want to remove the space from the second
tickpath$Species <- replace(tickpath$Species, tickpath$Species == "Ixodes scapularis ", "Ixodes scapularis")
tickpath$Species <- factor(tickpath$Species) 
levels(tickpath$Species)


#Each pathogen species that is tested is listed at "Pos___" or "Neg___" with 3 letters corresponding to the pathogen
  #need to transform to 0 for neg, 1 for positive
positiveNames <- c("PosRick","PosEew", "PosEch", "PosAna", "PosBor", "PosPME")
negNames <- c("NegRick", "negRick", "NegEew", "NegEch", "NegAna", "NegBor", "NegPME", "NegPMe")
columnNames <- c("Rickettsia", "Ehrlichia.ewingii", "Ehrlichia.chaffeensis", "Anaplasma.phagocytophilum", "Borrelia.spp", "PME")

#creating a dataframe that will have what needs to be changed and to what
preplacedf <- data.frame("Current" = positiveNames, "New" = 1)
nreplacedf <- data.frame("Current" = negNames, "New" = 0)
replacedf <- rbind(preplacedf, nreplacedf)

#FindReplace is from the DataCombine package
for (i in columnNames){
  tickpath <- FindReplace(tickpath, i, replacedf, from = "Current", to = "New", exact = TRUE)
}

#Change from character strings to numeric
sapply(tickpath, class)
tickpath[columnNames] <- sapply(tickpath[columnNames], as.numeric)
sapply(tickpath, class)

#Need total number of ticks found in each transect
Totaltick<-tickpath %>% 
  group_by(Season, Region, Site, Habitat, TransectNum, Species) %>%
  count(Species)
names(Totaltick)[7]<-"NumberTicksFound"

tickpath<-merge(x=tickpath,y=Totaltick, by=c("Season","Region","Site","Habitat","TransectNum","Species"))


####Data Exploration####
#How the habitat effects the prevalence of pathogens in ticks?
#Total number of positive tests found in a habitat broken down by species.
  #Creating the number of total pathogens
tickpath$TotalPath <- rowSums(tickpath[,c("Rickettsia", "Ehrlichia.ewingii",
                                          "Ehrlichia.chaffeensis", "Anaplasma.phagocytophilum", 
                                          "Borrelia.spp", "PME")], na.rm=TRUE)
  #Associating all pathogen tests on a single tick with that tick
meltpath <- melt(tickpath, id.vars=c("Season","Region","Site","Habitat","TransectNum","TickID",
                                     "Species","Sex","Life.stage","TotalPath","NumberTicksFound"))

meltpath %>%
  ggplot(aes(x=Habitat,y=value, fill=variable)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(.~Species)


#How the tick lifestage prevelance is changed within habitat?
tickpath %>%
  ggplot(aes(x=NumberTicksFound, fill=Life.stage)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_grid(Habitat~.)
  #Nymphal Amblyomma americanum is by far the most prevelant
  #Ixodes scapularis adults peak in the Fall, and A.A. peaks in summer

  ##Need to reorder the seasons to put them in chronological order
levels(tickpath$Season)
tickpath$Season <- factor(tickpath$Season, levels = c("Spring", "Summer", "Fall", "Winter"))
levels(tickpath$Season)

#How pathogen prevalence shifts over time within different habitats?


#save data as RDS
saveRDS(tickpath, file = "./data/processed_data/processeddata_tickpath.rds")
saveRDS(Totaltick, file = "./data/processed_data/processeddata_Totaltick.rds")
saveRDS(meltpath, file = "./data/processed_data/processeddata_melttick.rds")



####Code I don't think I need####
#total number of individual pathogens found in a habitat
#habitatNames <- c(levels(tickpath$Habitat))
#tickpathHabitat <- data.frame()
#for (i in habitatNames){
#  standin <- subset(tickpath, Habitat == i)
#  tickpathHabitat <- rbind(tickpathHabitat,colSums(standin[,10:15], na.rm=TRUE))
#}
#colnames(tickpathHabitat)[1:6] <- columnNames
#Habname <- data.frame(Habitat = c(levels(tickpath$Habitat)))
#tickpathHabitat <- cbind(Habname,tickpathHabitat)
#tickpathHabitat <- melt(tickpathHabitat, id.vars="Habitat")
