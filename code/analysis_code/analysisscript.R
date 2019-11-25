###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2)
library(dplyr)
library(broom)
library(reshape2)
library(here)
library(pander)

#load data. path is relative to project directory.
tickpath <- readRDS(here("././data/processed_data/processeddata_tickpath.rds"))
iscapbor <- readRDS(here("././data/processed_data/processeddata_iscapbor.rds"))


#How the habitat effects the prevalence of pathogens in ticks?
#Total number of positive tests found in a habitat broken down by species.
#Creating the number of total pathogens
tickpath$TotalPath <- rowSums(tickpath[,c("Rickettsia", "Ehrlichia.ewingii",
                                          "Ehrlichia.chaffeensis", "Anaplasma.phagocytophilum", 
                                          "Borrelia.spp", "PME")], na.rm=TRUE)
#Associating all pathogen tests on a single tick with that tick
meltpath <- melt(tickpath, id.vars=c("Season","Region","Site","Habitat","TransectNum","TickID",
                                     "Species","Sex","Life.stage","TotalPath","NumberTicksFound"))

speciesLand<-meltpath %>%
  ggplot(aes(x=Habitat,y=value, fill=variable)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(.~Species)

ggsave(filename=here("././results/speciesLandfigure.png"),plot=speciesLand) 

# fit linear model
lmfitSpecies <- lm(Habitat ~ Species, meltpath)  
lmfitSpecies
# place results from fit into a data frame with the tidy function
lmtableSpecies <- broom::tidy(lmfitSpecies)
lmtableSpecies
# save table  
saveRDS(lmtableSpecies, file = here("././results/resulttableSpecies.rds"))

#How the tick lifestage prevelance is changed within habitat?
lifeLand<-tickpath %>%
  ggplot(aes(x=NumberTicksFound, fill=Life.stage)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_grid(Habitat~.)
#Nymphal Amblyomma americanum is by far the most prevelant
#Ixodes scapularis adults peak in the Fall, and A.A. peaks in summer

ggsave(filename=here("././results/lifeLandfigure.png"),plot=lifeLand) 

# fit linear model
lmfitLife <- lm(Life.stage ~ Habitat, tickpath)  
lmfitLife

# place results from fit into a data frame with the tidy function
lmtableLife <- broom::tidy(lmfitLife)
lmtableLife

# save table  
saveRDS(lmtableLife, file = here("././results/resulttableLife.rds"))
saveRDS(tickpath, file = here("././data/processed_data/processeddata_tickpath.rds"))

BorrRegion <- iscapbor %>%
  ggplot(aes(x=Borrelia.spp, fill = Region)) +
  geom_bar()
ggsave(filename=here("././results/BorrRegionfigure.png"),plot=BorrRegion) 
