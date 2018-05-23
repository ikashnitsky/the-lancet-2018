################################################################################
#
# At a glance 2018-05-23
# Produce ternary colorcoded map of pop structures at NUTS-3 level
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jonas Schöley, jschoeley@health.sdu.dk 
#
################################################################################



# load previously saved data
load("data/180523-both15.RData")
load("data/180523-geodata.RData")

# create a blank map
basemap <- ggplot()+
        geom_polygon(data = neigh,
                     aes(x = long, y = lat, group = group),
                     fill = "grey90",color = "grey90")+
        coord_equal(ylim = c(1350000,5550000), xlim = c(2500000, 7500000))+
        theme_map(base_family = font_rc)+
        theme(panel.border = element_rect(color = "black",size = .5,fill = NA),
              legend.position = c(1, 1),
              legend.justification = c(1, 1),
              legend.background = element_rect(colour = NA, fill = NA),
              legend.title = element_text(size = 15),
              legend.text = element_text(size = 15))+
        scale_x_continuous(expand = c(0,0)) +
        scale_y_continuous(expand = c(0,0)) +
        labs(x = NULL, y = NULL) 


# Produce legend ----------------------------------------------

# Whole data mean -- recalculated with Turkey
center <- both15 %>% 
        select(2:6) %>% 
        summarise_all(.funs = funs(sum)) %>% 
        transmute(e = Y_GE65 / TOTAL,
                  w = `Y15-64` / TOTAL,
                  y = Y_LT15 / TOTAL) %>% 
        gather() %>% pull(value)


# calculate TRUE scaling factor for colors, i.e. the factor of proportionality
# from big tern to zoomed tern
mins <- apply(both15 %>% select(so, sw, sy), 2, min)
zommed_side <- (1 - (mins[2] + mins[3])) - mins[1]
true_scale <- 1 / zommed_side

tric_diff <- Tricolore(both15, p1 = 'Y_GE65', p2 = 'Y15-64', p3 = 'Y_LT15',
                       center = center, spread = true_scale, show_data = F,
                       contrast = .5, lightness = 1, chroma = 1, hue = 2/12)


# add color-coded proportions to map
both15$rgb_diff <- tric_diff$hexsrgb

# percent-point difference grid
legend_grid <- TernaryCentroidGrid(center)



legend_limits <- zoom_limits(
        df = both15 %>% select(so, sw, sy),
        keep_center = FALSE,
        one_pp_margin = TRUE
) # try playing with the params


# main legend for final output --------------------------------------------

tric_diff$legend +
        geom_point(data = both15, aes(so, sw, z = sy), 
                   shape = 46, color = "grey20", size = 3)+
        # highlight London
        geom_point(data = both15 %>% filter(str_sub(id, 1, 4)=="UKI4"), 
                   aes(so, sw, z = sy), 
                   shape = 1, color = "darkgreen", size = 3)+
        # highlight Gaziantep
        geom_point(data = both15 %>% filter(id == "TRC11"), 
                   aes(so, sw, z = sy), 
                   shape = 1, color = "darkblue", size = 3)+
        # highlight Province of Ourense
        geom_point(data = both15 %>% filter(id == "ES113"), 
                   aes(so, sw, z = sy), 
                   shape = 1, color = "darkred", size = 3)+
        # highlight center
        geom_point(data = tibble(so = center[1], sw = center[2], sy = center[3]), 
                   aes(so, sw, z = sy), 
                   shape = 43, color = "white", size = 5)+
        scale_L_continuous("Elderly\n(65+)", limits = legend_limits[,1]) +
        scale_T_continuous("Working age\n(15-64)", limits = legend_limits[,2]) +
        scale_R_continuous("Young\n(0-14)", limits = legend_limits[,3]) +
        Larrowlab("% aged 65+") +
        Tarrowlab("% aged 15-64") +
        Rarrowlab("% aged 0-14") +
        theme_classic() +
        theme(plot.background = element_rect(fill = "grey90", colour = NA),
              tern.axis.arrow.show = TRUE, 
              tern.axis.ticks.length.major = unit(12, "pt"),
              tern.axis.text = element_text(size = 12, colour = "grey20"),
              tern.axis.title.T = element_text(),
              tern.axis.title.L = element_text(hjust = 0.2, vjust = 0.7, angle = -60),
              tern.axis.title.R = element_text(hjust = 0.8, vjust = 0.6, angle = 60),
              text = element_text(family = font_rc, size = 14, color = "grey20"))

legend_main <- last_plot()



# print stats for highlights
center

both15 %>% filter(str_sub(id, 1, 4)=="UKI4") %>% 
        summarise(so = so %>% mean, sw = sw %>% mean, sy = sy %>% mean)

both15 %>% filter(id == "TRC11") %>% select(so:sy)

both15 %>% filter(id == "ES113") %>% select(so:sy)




# explanation ternary plot ------------------------------------------------

ggtern() +
        geom_point(data = both15, aes(so, sw, z = sy), 
                   shape = 46, color = "grey20", size = 1)+
        geom_Lline(data = center, Lintercept = center[1], color = "gold", size = 1)+
        geom_Tline(data = center, Tintercept = center[2], color = "cyan", size = 1)+
        geom_Rline(data = center, Rintercept = center[3], color = "magenta", size = 1)+
        scale_L_continuous("E", limits = legend_limits[,1]) +
        scale_T_continuous("W", limits = legend_limits[,2]) +
        scale_R_continuous("Y", limits = legend_limits[,3]) +
        geom_point(data = tibble(so = center[1], sw = center[2], sy = center[3]), 
                   aes(so, sw, z = sy), 
                   shape = 43, color = "grey10", size = 5)+
        theme_classic() +
        theme(plot.background = element_rect(fill = NA, colour = NA),
              text = element_text(family = font_rc, size = 10, color = "grey20"),
              tern.axis.line.L = element_line(color = "gold", size = 1),
              tern.axis.line.T = element_line(color = "cyan", size = 1),
              tern.axis.line.R = element_line(color = "magenta", size = 1))

legend_explain <- last_plot()


# assemble explanation
ggplot()+
        coord_equal(xlim = c(0, 1), ylim = c(0, .5), expand = c(0,0))+
        scale_y_continuous(limits = c(0, .5))+
        
        annotation_custom(ggplotGrob(legend_explain),
                          xmin = -.025, xmax = .5, 
                          ymin = -.025, ymax = .475)+
        
        theme_map() %+replace%
        theme(plot.margin=grid::unit(rep(-0.2, 4), "lines"),
              plot.background = element_rect(fill = NA, colour = NA))+
        
        annotate("text", x = .5, y = .48, hjust = .5, vjust = 1,
                 label = toupper("interpretation of the ternary scheme"),
                 size = 5, family = font_rc, color = "grey20")+
        
        # label working age
        geom_curve(data = tibble(x = .325, y = .35, xend = .225, yend = .3), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = .3,
                   color = "cyan", 
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .335, y = .4, hjust = 0, vjust = 1, lineheight = .9,
                 label = "More people at WORKING AGES in this parallelogram,\ncompared to EU average; less kids and elderly people\n(above blue line, below yellow and pink lines)",
                 size = 4, family = font_rc, fontface = 3, color = "cyan3")+
        
        # label working age + youths
        geom_curve(data = tibble(x = .55, y = .225, xend = .275, yend = .225), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = .15,
                   color = "mediumpurple1", 
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .56, y = .225, hjust = 0, vjust = .5, lineheight = .9,
                 label = "Less ELDERLY people\nin this triangle;\nmore kids and adults",
                 size = 4, family = font_rc, fontface = 3, color = "mediumpurple3")+
        
        # label youths
        geom_curve(data = tibble(x = .75, y = .1, xend = .325, yend = .1), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = 0,
                   color = "magenta", 
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .76, y = .1, hjust = 0, vjust = .5, lineheight = .9,
                 label = "More KIDS; less\nadults and elderly",
                 size = 4, family = font_rc, fontface = 3, color = "magenta3")

explanation <- last_plot()


# redo --------------------------------------------------------------------



# assemble legend
ggplot()+
        coord_equal(xlim = c(0, 1), ylim = c(0, 1.4), expand = c(0,0))+
        
        annotate("text", x = .5, y = 1.37, hjust = .5, vjust = 1,
                 label = toupper("Color-coding scheme"),
                 size = 7, family = font_rc, color = "grey20")+
        annotation_custom(ggplotGrob(legend_main),
                          xmin = .02,xmax = .98, 
                          ymin = .5, ymax = 1.3)+
        
        
        annotation_custom(ggplotGrob(explanation),
                          xmin = -.01, xmax = .99, 
                          ymin = -.03, ymax = .47)+
        
        # additional info - EU center
        geom_curve(data = tibble(x = .33, y = 1.15, xend = .4375, yend = .8175), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = -0.3,
                   color = "white", 
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .315, y = 1.15, hjust = 1, vjust = .5, lineheight = .9,
                 label = "Age stucture of\nEuropean population:\nYouths -- 16.7%\nWorking age -- 65.8%\nElderly -- 17.4%",
                 size = 4.5, family = font_rc, fontface = 3, color = "grey20")+
        
        # additional info - London
        geom_curve(data = tibble(x = .73, y = 1.12, xend = .535, yend = .935), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = 0.45,
                   color = "darkgreen", size = .5,
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .95, y = 1.12, hjust = 1, vjust = .5, lineheight = .9,
                 label = "Inner London - East\naverage age structure:\nYouths -- 18.4%\nWorking age -- 73.9%\nElderly --   7.6%",
                 size = 4, family = font_rc, fontface = 3, color = "grey20")+
        
        # additional info - Gaziantep
        geom_curve(data = tibble(x = .89, y = .74, xend = .71, yend = .735), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = -0.45,
                   color = "darkblue", size = .5,
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .95, y = .84, hjust = 1, vjust = .5, lineheight = .9,
                 label = "Gaziantep\n(Turkey):\nY -- 33.6%\nW -- 61.5%\nE --   4.9%",
                 size = 3.5, family = font_rc, fontface = 3, color = "grey20")+
        
        # additional info - Province of Ourense
        geom_curve(data = tibble(x = .13, y = .74, xend = .245, yend = .71), 
                   aes(x = x, y = y, xend = xend, yend = yend),
                   curvature = 0.25,
                   color = "darkred", size = .5,
                   arrow = arrow(type = "closed", length = unit(0.1, "cm")))+
        annotate("text", x = .19, y = .84, hjust = 1, vjust = .5, lineheight = .9,
                 label = "Province of\nOurense (Spain):\nY --   9.7%\nW -- 59.9%\nE -- 30.4%",
                 size = 3.5, family = font_rc, fontface = 3, color = "grey20")+
        
        theme_map()+
        theme(text = element_text(family = font_rc, lineheight = .75)) %+replace%
        theme(plot.margin=grid::unit(rep(-0.2, 4), "lines"),
              plot.background = element_rect(fill = "grey90", colour = "grey20"))


legend <- last_plot()




# assemble the final plot
basemap +
        geom_map(map = gghole(gd3)[[1]], data = both15,
                 aes(map_id = id, fill = rgb_diff))+
        geom_map(map = gghole(gd3)[[2]], data = both15,
                 aes(map_id = id, fill = rgb_diff))+
        scale_fill_identity()+
        geom_path(data = bord, aes(long, lat, group = group), 
                  color = "white", size = .5)+
        theme(legend.position = "none") + 
        annotation_custom(ggplotGrob(legend),
                          xmin = 56.5e5,xmax = 74.5e5, 
                          ymin = 28.8e5, ymax = 55.8e5)+
        # authors
        annotate("text", x = 67e5, y = 17.2e5, hjust = 0, vjust = 0,
                 label = "Ilya Kashnitsky", fontface = 2,
                 size = 5, family = font_rc, color = "grey20")+
        annotate("text", x = 67e5, y = 16.5e5, hjust = 0, vjust = 0,
                 label = "ikashnitsky.github.io",
                 size = 4.5, family = font_rc, color = "grey40")+
        annotate("text", x = 68.5e5, y = 15e5, hjust = 0, vjust = 0,
                 label = "&", fontface = 2,
                 size = 10, family = font_rc, color = "#35978f")+
        annotate("text", x = 74.5e5, y = 14.7e5, hjust = 1, vjust = 0,
                 label = "Jonas Schöley", fontface = 2,
                 size = 5, family = font_rc, color = "grey20")+
        annotate("text", x = 74.5e5, y = 14e5, hjust = 1, vjust = 0,
                 label = "jschoeley.github.io",
                 size = 4.5, family = font_rc, color = "grey40")+
        # date
        annotate("text", x = 67e5, y = 14e5, hjust = 0, vjust = 0,
                 label = "2018", fontface = 2,
                 size = 5, family = font_rc, color = "#35978f")+
        # data
        annotate("text", x = 26e5, y = 14e5, hjust = 0, vjust = 0, lineheight = .9,
                 label = "Data: Eurostat, 2015; Geodata: NUTS 2013\nReproduce: https://github.com/ikashnitsky/the-lancet-2018",
                 size = 4.5, family = font_rc, color = "grey50")+
        # title
        annotate("text", x = 26e5, y = 55e5, hjust = 0, vjust = 1, 
                 label = "REGIONAL POPULATION STRUCTURES\n                                          AT A GLANCE",
                 size = 8, family = font_rc, color = "grey20")

together <- last_plot()

# save
ggsave("colorcoded-map-ikashnitsky-jschoeley.png", together, width = 14, height = 11.76, 
       dpi = 600, type = "cairo-png")
