# Import data from the working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Loading the dplyr library to manipulate the data (install if required)
## install.packages("dplyr")
library(dplyr)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Group data by year and summarize the total Emissions
year_sum <- group_by(nei, year) %>%
        summarize(emissions=sum(Emissions))
# Creating plot with base to a PNG file in the working directory
png("plot1.png")
with(year_sum, plot(year,emissions, type="b",
     main="Total PM2.5 emissions have decreased",
     xlab="year",
     ylab="total PM2.5 emission from all sources (tons)"))
dev.off()