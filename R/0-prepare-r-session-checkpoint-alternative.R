################################################################################
#
# At a glance 2018-05-23
# Install and load required packages -- checkpoint solution
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jonas Schöley, jschoeley@health.sdu.dk 
#
################################################################################


# This script will make sure that there will be no error in the replication of 
# the analysis due to R packages absence or version missmatch.
# For this reason we use the special package for reproducible research called 
# "checkpoint".
# This package installes all the packages used in a project precisely as they 
# were at a specific date, the date of abalysis. 
# More info: https://github.com/RevolutionAnalytics/checkpoint/wiki


# install "checkpoint" package with all its dependencies 
# install only if it was not previously installed
# solution by Sacha Epskamp from: http://stackoverflow.com/a/9341833/4638884
if (!require('checkpoint', character.only = TRUE)) {
        install.packages('checkpoint', dep = TRUE)
        if (!require('checkpoint', character.only = TRUE))
                stop("Package not found")
}

# load "checkpoint" package
library(checkpoint)

# create the system directory for `checkpont` to avoid being asked about that
ifelse(
        dir.exists('~/.checkpoint'),
        yes = print('directory already exists'),
        no = dir.create('~/.checkpoint')
)

# Set the checkpoint date for reproducibility: 2018-05-23
# Now quite a long process starts: "checkpoint" scans through all the scripts in 
# the project and finds all the packages that should be installed to run the scripts.
# The packages will be installed precisely as the were on 2018-05-23.
checkpoint('2018-05-23')


# load required packages
library(tidyverse)      # data manipulation and viz
library(ggtern)         # plot ternary diagrams
library(gridExtra)      # arrange subplots
library(lubridate)      # easy manipulations with dates
library(ggthemes)       # themes for ggplot2
library(extrafont)      # custom font
library(hrbrthemes)     # to use import_roboto_condensed()
library(eurostat)       # grab data
library(rgdal)          # deal with shapefiles
library(rgeos)
library(maptools)
library(pacman)         # deal with packages
library(tricolore)      # tricolore package

# get Roboto Consensed font -- called later as myfont
import_roboto_condensed()
