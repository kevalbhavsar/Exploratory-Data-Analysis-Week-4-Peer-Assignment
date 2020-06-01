library(dplyr)
library(ggplot2)

# activity monitoring data
get.data.project <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(get.data.project,destfile="./dataStore/exdata-data-NEI_data.zip",method="auto")  

# zipfile.data is the variable to keep the *.zip file
zipfile.data = "exdata-data-NEI_data.zip"

# unzip the zipfile.data
unzip(zipfile="./dataStore/exdata-data-NEI_data.zip",exdir="./dataStore")

path_rf <- file.path("./dataStore" , "exdata-data-NEI_data")
files<-list.files(path_rf, recursive=TRUE)
files

# Read data files
# read national emissions data
NEI <- readRDS("dataStore/summarySCC_PM25.rds")

#read source code classification data
SCC <- readRDS("dataStore/Source_Classification_Code.rds")

# visualization
number.add.width<-800         # width length to make the changes faster
number.add.height<-800        # height length to make the changes faster

png("Plot_6.png", width=number.add.width, height=number.add.height)

baltcitymary.emissions<-summarise(group_by(filter(NEI, fips == "24510"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))
losangelscal.emissions<-summarise(group_by(filter(NEI, fips == "06037"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))

baltcitymary.emissions$County <- "Baltimore City, MD"
losangelscal.emissions$County <- "Los Angeles County, CA"
both.emissions <- rbind(baltcitymary.emissions, losangelscal.emissions)

ggplot(both.emissions, aes(x=factor(year), y=Emissions, fill=County,label = round(Emissions,2))) +
  geom_bar(stat="identity") + 
  facet_grid(County~., scales="free") +
  ylab(expression("total PM"[2.5]*" emissions in tons")) + 
  xlab("year") +
  ggtitle(expression("Motor vehicle emission variation in Baltimore and Los Angeles in tons"))+
  geom_label(aes(fill = County),colour = "white", fontface = "bold")
dev.off()