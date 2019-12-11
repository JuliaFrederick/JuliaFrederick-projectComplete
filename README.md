# This is Julia Frederick's class project repository

In order to run this project and produce a complete manuscript only the `products/manuscript/ProjectTemplate.Rmd` file needs to be run. This includes code chucks that pull from other files within this project that run through all cleaning, processing, and analysis for this manuscript.  
A supplemental material document can also be created by running the `products/manuscript/SuppMaterial.Rmd` file


# Pre-requisites

This is a template for a data analysis project using R, Rmarkdown (and variants, e.g. bookdown), Github and a reference manager that can handle bibtex (I recommend [Jabref](http://www.jabref.org/) or [Zotero](https://www.zotero.org/)). It is also assumed that you have a word processor installed (e.g. MS Word or [LibreOffice](https://www.libreoffice.org/)). You need that software stack to make use of this template.  

It also requires multiple packages they may need to be installed prior to running. These include: readxl, knitr, dplyr, DataCombine, ggplot2, stats, reshape2, here, broom, pander, forcats, doParallel, rpart, rpart.plot, mda, ranger, e1071, gbm, caret, mlr, visdat, parallelMap

# Structure

* All original data goes into the `excelDataFiles` and some description of the project
* All data that will be pulled for this project goes into the subfolders inside the `data` folder, including a map of sampling sites.
* All code goes into the `code` folder or subfolders.
* All results (figures, tables, computed values) go into `results` folder or subfolders.
* All products (manuscripts, supplement, etc.) go into `products` subfolders.
* See the various `readme.md` files in those folders for some more information.

# Content 

The template comes with a few files that are meant as illustrative examples of the kinds of content you would place in the different folders. 

* There is a dataset from tick collections in the `raw_data` folder. 
* The `processing_code` folder contains a single R script which loads the raw data, performs a bit of cleaning, and saves the result in the `processed_data` folder.
* The `analysis_code` folder contains multiple R scripts which loads the processed data, completes univarite, bivariate and random forest modeling, and produces figures and some numeric output, which is saved in the `results` folder.
* The `products` folder contains the `bibtex` and CSL style file for references. Those files are used by the manuscript.
* The  `manuscript` folder contains the template for this report written in Rmarkdown (bookdown, to be precise). This is the main script and will run all accompanying scripts



