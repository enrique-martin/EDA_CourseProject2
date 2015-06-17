# Import data from the working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Loading the dplyr library to manipulate the data (install if required)
## install.packages("dplyr")
library(dplyr)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Filter Baltimore data, group by year and by type and summarize the total Emissions
baltimore_type <- filter(nei, fips=="24510") %>%
        group_by(type, year) %>% summarize(emissions=sum(Emissions))
# Creating plot with ggplot2 to a PNG file in the working directory
library(ggplot2)
png("plot3.png")
g <- qplot(year, emissions, data=baltimore_type, geom=c("point", "smooth"), color=type)
g + labs(x = "year", y = "total PM2.5 emission in Baltimore City, by type, from all sources (tons)")
dev.off()