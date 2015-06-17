# Import data from the working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Loading the dplyr library to manipulate the data (install if required)
## install.packages("dplyr")
library(dplyr)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Filter Baltimore data, group by year and summarize the total Emissions
year_baltimore <- filter(nei, fips=="24510") %>%
        group_by(year) %>% summarize(baltimore_emissions=sum(Emissions))
# Creating plot with base to a PNG file in the working directory
png("plot2.png")
with(year_baltimore, plot(year,baltimore_emissions, type="b",
                          main="Total PM2.5 emissions have decreased in Baltimore City",
                          xlab="year",
                          ylab="total PM2.5 emission in Baltimore City from all sources (tons)"))
dev.off()