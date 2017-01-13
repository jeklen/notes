library(ggplot2)
USArrests[1:10,]
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
library(maps)
states_map <- map_data("state") # Merge the data sets together 
crime_map <- merge(states_map, crimes, by.x="region", by.y="state")
# After merging, the order has changed, which would lead to polygons drawn in the incorrect order. So, we sort the data.
library(plyr)  # For arrange() function. Sort by group, then order
crime_map <- arrange(crime_map, group, order)
ggplot(crime_map, aes(x=long, y=lat, group=group, fill=Assault)) +geom_polygon(colour="black") +coord_map("polyconic")
ggplot(crime_map, aes(x=long, y=lat, group=group, fill=Assault)) +geom_polygon(colour="black")
