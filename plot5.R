# Import data from the working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Loading the dplyr library to manipulate the data (install if required)
## install.packages("dplyr")
library(dplyr)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)


# Fiter the emissions from motor vehicle sources using the SCC file
vehicle <- as.character(SCC$SCC[grep("Vehicle", SCC$EI.Sector)])
# Filter the data corresponding to Baltimore City, group by year, and summarize
year_vehicle <- filter(nei, SCC %in% vehicle) %>%
        filter(fips=="24510") %>%
        group_by(year) %>% summarize(emissions=sum(Emissions))
# Creating plot with base to a PNG file in the working directory
png("plot5.png")
with(year_vehicle, plot(year,emissions, type="b",
                     main="Motor vehicle emissions have decreased in Baltimore City",
                     xlab="year",
                     ylab="total PM2.5 emission from motor vehicle sources in Baltimore City (tons)"))
dev.off()