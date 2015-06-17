# Import data from the working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Loading the dplyr library to manipulate the data (install if required)
## install.packages("dplyr")
library(dplyr)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)


# Fiter the Coal-Combustion related sources using the SCC file
coal_comb <- as.character(SCC$SCC[intersect(grep("Coal", SCC$EI.Sector), grep("Comb", SCC$EI.Sector))])
# Group by year and summarize
year_coal <- filter(nei, SCC %in% coal_comb) %>% group_by(year) %>% summarize(emissions=sum(Emissions))
# Creating plot with base to a PNG file in the working directory
png("plot4.png")
with(year_coal, plot(year,emissions, type="b",
                    main="Emission from coal combustion-related sources have decreased",
                    xlab="year",
                    ylab="total PM2.5 emission from coal combustion-related sources (tons)"))
dev.off()