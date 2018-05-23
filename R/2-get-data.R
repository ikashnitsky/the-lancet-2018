################################################################################
#
# At a glance 2018-05-23
# Download and prepare the data
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jonas Schöley, jschoeley@health.sdu.dk 
#
################################################################################


# This script downloads and preapres data that we use to create the map
# The script is successfully run on 2018-05-23
# To ensure reproducibility, we stored copies of the data
# But feel free to re-create the data



# Download geodata --------------------------------------------------------

# Eurostat official shapefiles for regions
# http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units

# geodata will be stored in a directory "geodata"
ifelse(
        !dir.exists("data/geodata"),
        dir.create("data/geodata"),
        paste("Directory already exists")
)

f <- tempfile()
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2013_20M_SH.zip", destfile = f)
unzip(f, exdir = "data/geodata/.")
NUTS_raw <- readOGR("data/geodata/NUTS_2013_20M_SH/data/.", "NUTS_RG_20M_2013")

# colnames to lower case
names(NUTS_raw@data) <- tolower(names(NUTS_raw@data))

# NUTS_raw@data %>% View
# 
# # let's have a look
# plot(NUTS_raw)


# change coordinate system to LAEA Europe (EPSG:3035)
# check out https://espg.io
epsg3035 <- "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

NUTS <- spTransform(NUTS_raw, CRS(epsg3035)) 

# create borders between countries
NUTS0 <- NUTS[NUTS$stat_levl_==0,]

identify_borders <- function(SPolyDF){
        require(rgeos)
        require(sp)
        borders <- gDifference(
                as(SPolyDF,"SpatialLines"),
                as(gUnaryUnion(SPolyDF),"SpatialLines"),
                byid=TRUE)
        
        df <- data.frame(len = sapply(1:length(borders), 
                                      function(i) gLength(borders[i, ])))
        rownames(df) <- sapply(1:length(borders), 
                               function(i) borders@lines[[i]]@ID)
        
        SLDF <- SpatialLinesDataFrame(borders, data = df)
        return(SLDF)
} # raster::boundaries

Sborders <- identify_borders(NUTS0)

bord <- fortify(Sborders)

# subset NUTS-3 regions
NUTS3 <- NUTS[NUTS$stat_levl_==3,]


# remote areas to remove (NUTS-2)
remote <- c(paste0('ES',c(63,64,70)),paste('FRA',1:5,sep=''),'PT20','PT30')

# make the geodata ready for ggplot
gd3 <- fortify(NUTS3, region = "nuts_id") %>% 
        filter(!str_sub(id, 1, 4) %in% remote,
               !str_sub(id, 1, 2) == "AL")



# let's add neighbouring countries
f <- tempfile()
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/CNTR_2010_20M_SH.zip", destfile = f)
unzip(f, exdir = "data/geodata/.")
WORLD <- readOGR("data/geodata/CNTR_2010_20M_SH/CNTR_2010_20M_SH/Data/.",
                 "CNTR_RG_20M_2010")

# colnames to lower case
names(WORLD@data) <- tolower(names(WORLD@data))

# filter only Europe and the neighbouring countries
neigh_subset <- c("AT", "BE", "BG", "CH", "CZ", "DE", "DK", 
                  "EE", "EL", "ES", "FI", "FR", "HU", "IE", "IS", "IT", "LT", "LV", 
                  "NL", "NO", "PL", "PT", "SE", "SI", "SK", "UK", "IM", "FO", "GI", 
                  "LU", "LI", "AD", "MC", "MT", "VA", "SM", "HR", "BA", "ME", "MK", 
                  "AL", "RS", "RO", "MD", "UA", "BY", "RU", "TR", "CY", "EG", "LY", 
                  "TN", "DZ", "MA", "GG", "JE", "KZ", "AM", "GE", "AZ", "SY", "IQ",
                  "IR", "IL", "JO", "PS", "SA", "LB", "MN", "LY", "EG")

NEIGH <- WORLD[WORLD$cntr_id %in% neigh_subset,]

# reproject the shapefile to a pretty projection for mapping Europe
Sneighbors <- spTransform(NEIGH, CRS(epsg3035))

# cut of everything behing the borders
rect <- rgeos::readWKT(
        "POLYGON((20e5 10e5,
        80e5 10e5,
        80e5 60e5,
        20e5 60e5,
        20e5 10e5))"
        )
Sneighbors <- rgeos::gIntersection(Sneighbors,rect,byid = T)

neigh <- fortify(Sneighbors)



# save - just to skip the download process next time
save(gd3, neigh, bord, remote,
     file = "data/geodata.RData",
     compress = "xz")




# Get stat data -----------------------------------------------------------

# Find the needed dataset code 
# http://ec.europa.eu/eurostat/web/regions/data/database

# download the data on pop structures at NUTS-3 level
both15 <- get_eurostat("demo_r_pjanaggr3") %>% 
        # filter NUTS-3, 2015, both sex, and remove remote areas
        filter(sex=="T", nchar(paste(geo))==5,
               !str_sub(geo, 1, 4) %in% remote,
               !str_sub(geo, 1, 2) %in% c("AL", "MK"),
               year(time)==2015) %>% 
        droplevels() %>% 
        transmute(id = geo, age, value = values) %>% 
        spread(age, value) %>% 
        mutate(sy = Y_LT15 / TOTAL, 
               sw = `Y15-64` / TOTAL, 
               so = 1 - (sy + sw))

# if the automated download does not work, the data can be grabbed manually at
# http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing

save(both15, 
     file = "data/both15.RData",
     compress = "xz")
