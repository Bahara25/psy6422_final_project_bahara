## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -----------------------------------------------------------------------------
#setting the path for the data

file_path <- "~/gaming_project/data"

setwd(file_path)

#library here to tell R where my data is

library(here)

#load data into R

#separate the data with ; as the data is unclean and within one column

gamingdata <- read.csv(here("gaming_and_covid_raw.csv"), header = TRUE, sep = ";")


## -----------------------------------------------------------------------------
head(gamingdata)


## -----------------------------------------------------------------------------
#load tidyverse and dplyr

library(tidyverse)
library(dplyr)

gamingdatac <- gamingdata

#remove umlaut and dots from the age column

gamingdatac <- gamingdatac %>% rename(age = ï..age)


#select the variables wanted for the visualisations

gamingdatac <- gamingdatac %>%
  select(beh_ch_general, Loneliness_sum)

head(gamingdatac)


## -----------------------------------------------------------------------------

#library ggplot to create visualisations

library(ggplot2)

ggplot(data = gamingdatac, aes(x = beh_ch_general, fill = beh_ch_general)) +
  geom_bar(fill = "#9900FF", colour = "#9900FF") + 
  
#remove the grid lines, background colour and borderlines   
  
  theme(panel.background = element_blank()) +
  
#use scale_x_discrete to change labels of the values on the x axis
  
  scale_x_discrete(limit = c("Much Less Than Before", "Less Than Before", "Similar To Before","More Than Before","Much More Than Before")) +


#label axes, title and caption

  labs(x = "Time Spent on General Games Compared to Before COVID-19", 
       y = "Number of Participants",
       title = "Number of Participants and Changes in Time Spent Playing General Games",
       caption = "Figure 1") 

#save the visualisation as a png

ggsave("general_game_numbers.png")


## -----------------------------------------------------------------------------

#library gganimate

library(gganimate)

#stat_identity included rather than geom_bar(stat="identity") so that the y axis data isn't aggregated

ggplot() +
    stat_identity(data = gamingdatac,
                  aes(x = beh_ch_general, 
                      y = Loneliness_sum,
                      fill = factor(beh_ch_general)), 
                      geom = "col") +
  
#use transition states to have the bars transition in
  
    transition_states(beh_ch_general, wrap=FALSE) +
    shadow_mark() +
  
#use coord_cartesian to zoom into the y axis scale 
  
    coord_cartesian(ylim = c(50,80)) +
  
#scale_fill_manual allows the bars in the visualisation to be coloured manually
  
    scale_fill_manual(values = c("#CC00CC", "#CC00FF", "#9900FF", "#6600FF", "#3300FF")) +
  
#remove the grid lines, background colour and borderlines   
  
    theme(panel.background = element_blank()) +
  
#use scale_x_discrete to change labels of the values on the x axis
      
    scale_x_discrete(limit = c("Much Less Than Before", "Less Than Before", "Similar To Before","More Than Before","Much More Than Before")) +
      
#label the axes, title and caption
  
    labs(x = "Time Spent on General Games Compared to Before COVID-19", 
         y = "UCLA Loneliness Sum", 
         title = "Impact of Loneliness and COVID-19 on Time Spent Playing General Games", 
         caption = "Figure 2") +
  
#remove legend as provides unnecessary information
  
    theme(legend.position = "none")

#save visualisation as a gif

anim_save("general_games_loneliness_gif.gif")
 


## -----------------------------------------------------------------------------
#extract script

library(knitr)

options(knitr.duplicate.label = "allow")

purl("baharahaidari_psy6422_final_project.Rmd", output="gaming_project_psy6422_script.R")


