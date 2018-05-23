################################################################################
#
# At a glance 2018-05-23
# Master script to replicate the map
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jonas Schöley, jschoeley@health.sdu.dk 
#
################################################################################


# This is a master script that calls other scripts one-by-one to replicate the 
# colorcoded map. To avoid problems caused by possible changes in the data, we
# stored a copy of the data as of 2018-05-23.


# Step 0. Prepare the R session
source("R/0-prepare-r-session.R")

# Step 1. Load custom functions
source("R/1-own-functions.R")

# Step 2 (skip). Download and prepaer the data
# source("R/2-get-data.R")

# Step 3. Draw the map
source("R/3-the-map.R")

# Find the map (colorcoded-map-ikashnitsky-jschoeley.png) 
# in the main project directory



# Alternative package instalation solution --------------------------------

# This is a note sent to not-so-close future.
# If you experience problems replicating the map, probably the reason is 
# package dependency. The most reliable way to deal with this problem is to
# use checkpoint package. 
# Just uncomment the next line and run the alternative #0 sctipt
# source("R/0-prepare-r-session-checkpoint-alternative.R")