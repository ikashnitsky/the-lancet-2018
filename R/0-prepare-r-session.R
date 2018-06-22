################################################################################
#
# At a glance 2018-05-23
# Install and load required packages
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jonas Schöley, jschoeley@health.sdu.dk 
#
################################################################################


# install pacman to streamline further package installation
if (!require("pacman", character.only = TRUE)){
        install.packages("pacman", dep = TRUE)
        if (!require("pacman", character.only = TRUE))
                stop("Package not found")
}


# these are the required packages
pkgs <- c(
        "tidyverse", 
        "ggtern",
        "gridExtra",
        "lubridate",
        "ggthemes",
        "extrafont",
        "hrbrthemes",
        "rgdal",
        "rgeos",
        "maptools",
        "eurostat",
        "tricolore"
)


# install the missing packages
# only run if at least one package is missing
if(!sum(!p_isinstalled(pkgs))==0){
        p_install(
                package = pkgs[!p_isinstalled(pkgs)], 
                character.only = TRUE
        )
}

# load the packages
p_load(pkgs, character.only = TRUE)

# get Roboto Consensed font -- called later as myfont
import_roboto_condensed()
