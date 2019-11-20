
library('caret')
library('mlr')
library('visdat')
library('parallelMap')
library('here')
tickpath <- readRDS(here("././data/processed_data/processeddata_tickpath.rds"))

xtickpath <- DropNA(tickpath, 'Borrelia.spp')
xtickpath <- xtickpath[,c(17,1:16)]


##Total Pathogen by Habitat
# fit linear model
lmfitPathHab <- lm(TotalPath ~ Habitat, xtickpath)  
lmfitPathHab
# place results from fit into a data frame with the tidy function
lmtablePathHab <- broom::tidy(lmfitPathHab)
lmtablePathHab
# save table  
saveRDS(lmtablePathHab, file = here("././results/resulttablePathHab.rds"))

##Total Pathogen by Habitat
# fit linear model
lmfitPathSea <- lm(TotalPath ~ Season, xtickpath)  
lmfitPathSea
# place results from fit into a data frame with the tidy function
lmtablePathSea <- broom::tidy(lmfitPathSea)
lmtablePathSea
# save table  
saveRDS(lmtablePathSea, file = here("././results/resulttablePathSea.rds"))

##Total Pathogen by Species
# fit linear model
lmfitPathSpe <- lm(TotalPath ~ Species, tickpath)  
lmfitPathSpe
# place results from fit into a data frame with the tidy function
lmtablePathSpe <- broom::tidy(lmfitPathSpe)
lmtablePathSpe
# save table  
saveRDS(lmtablePathSpe, file = here("././results/resulttablePathSpe.rds"))

##Testing Iscap and Borrelia by Region
lmBor <- lm(Borrelia.spp~Region, iscapbor) 
lmBor
lmtableBor <- broom::tidy(lmBor)
saveRDS(lmtableBor, file = here("././results/resulttableBor.rds"))