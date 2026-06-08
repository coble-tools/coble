# from folder 06_velton

library(Seurat)
library(ggplot2)
library(viridis)
library(patchwork)
#library(corrplot)
#library(harmony)
#library(infotheo)
#library(caret)
#library(randomForest)
library(ComplexHeatmap)
#library(uwot)

plot_theme_legend <- theme(panel.background = element_rect(color='black',fill='white'),
                          panel.grid=element_blank(),
                          text=element_text(color='black',size=10),
                          axis.text=element_text(color='black',size=10),
                          axis.ticks=element_line(color='black', size=.1),
                          strip.background = element_blank(),
                          legend.key=element_rect(color='black', fill=NA),
                          legend.key.size = unit(5, 'mm'),
                          strip.text = element_text(color='black',size=12))
plot_theme_title <- theme(panel.background = element_blank(),
                    panel.grid=element_blank(),
                    text=element_text(color='black',size=10),
                    axis.text=element_blank(),
                    axis.ticks=element_blank(),
                    axis.title=element_blank(),
                    strip.background = element_blank(),
                    legend.key=element_rect(color='black', fill=NA),
                    legend.key.size = unit(5, 'mm'),
                    legend.position = 'none',
                    strip.text = element_text(color='black',size=12),
                    plot.title = element_text(color='black',size=10))
plot_theme <- theme(panel.background = element_rect(color='black',fill='white'),
                    panel.grid=element_blank(),
                    text=element_text(color='black',size=12),
                    axis.text=element_text(color='black',size=10),
                    axis.ticks=element_line(color='black', size=.1),
                    strip.background = element_blank(),
                    legend.key=element_rect(color='black', fill=NA),
                    legend.key.size = unit(5, 'mm'),
                    plot.title=element_blank(),
                    legend.position = 'none',
                    strip.text = element_text(color='black',size=12))
color_map <- c("HSC/MPP1"="maroon4",
  "MPP2" ="darkgrey",
  "MPP3" = "darkblue",
  "MPP4" = "darkgreen",
  "pre/pro-B" ="#94B1F9",
  "GMP" = "#C3C380",
  'Myeloid Progenitors'="#C3C380",
  'Myelocytes'='#e5e500',
  "MEP"="#D5392C",
  "EryP" = "#ED7950",
  "MkP 1" = "#BDA8CB",
  "MkP" = "#BDA8CB",
  "MkP 2" = "#D36494"
  )
source('GitHub/EPI-clone/scripts/helper_functions.R')
#source('EPI-clone/scripts/EPIClone.R')