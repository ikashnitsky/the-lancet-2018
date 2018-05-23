################################################################################
#
# At a glance 2018-05-23
# Define custom functions
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jonas Schöley, jschoeley@health.sdu.dk 
#
################################################################################


# custom functions --------------------------------------------------------

# a function to overcome the problem of mapping nested polygons
# check out https://stackoverflow.com/questions/21748852
gghole <- function(fort){
        poly <- fort[fort$id %in% fort[fort$hole,]$id,]
        hole <- fort[!fort$id %in% fort[fort$hole,]$id,]
        out <- list(poly,hole)
        names(out) <- c('poly','hole')
        return(out)
}

# a function to create zooming limits
zoom_limits <- function(
        # 3-columns data frame. ! Oreder is important: L, R, T
        df, 
        # whether to minimize zooming triangle and move the data center
        # or keep the data center at (1/3, 1/3, 1/3)
        keep_center = TRUE, 
        # add 1 percentage point margin to avoid cutting the extreme points
        one_pp_margin = FALSE,
        # the default is to calculate average from the provided data
        # though, I leave a possibility to specify custom center
        # in our case, custom center is the EU pop structure
        center = apply(df, 2, mean)
) {
        # calculate minimums of the variables
        mins <- apply(df, 2, min)
        # calculate max data span
        span <- max(apply(df, 2, function(x) diff(range(x))))
        # add 1 percentage point margin to avoid cutting the extreme points
        if(one_pp_margin == TRUE & min(mins) > .01){
                mins <- mins - .01
                span <- span + .01
        }
        # keep the center at (1/3, 1/3, 1/3) or not
        if(keep_center == TRUE){
                limits <- rbind(
                        center - (1/3)*span/(sqrt(2)/2),
                        center + (2/3)*span/(sqrt(2)/2)
                )
        } else {
                limits <- rbind(
                        mins,
                        c(
                                1 - (mins[2] + mins[3]),
                                1 - (mins[1] + mins[3]),
                                1 - (mins[1] + mins[2])
                        )
                ) 
        }
        return(limits)
}


# coordinates and labels for the centered gridlines of a ternary diagram
TernaryCentroidGrid <- function (center) {
        # center percent difference labels
        labels <- seq(-1, 1, 0.1)
        labels <- data.frame(
                L = labels[labels >= -center[1]][1:10],
                T = labels[labels >= -center[2]][1:10],
                R = labels[labels >= -center[3]][1:10]
        )
        
        # breaks of uncentered grid
        breaks = data.frame(
                L = labels$L + center[1],
                T = labels$T + center[2],
                R = labels$R + center[3]
        )
        
        list(labels = labels, breaks = breaks)
}



