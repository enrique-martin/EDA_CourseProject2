# Import data from the working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Loading the dplyr library to manipulate the data (install if required)
## install.packages("dplyr")
library(dplyr)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)


# Fiter the emissions from motor vehicle sources, in Baltimore City, group by year, and summarize
vehicle <- as.character(SCC$SCC[grep("Vehicle", SCC$EI.Sector)])
vehicle_Baltimore <- filter(nei, SCC %in% vehicle) %>%
        filter(fips=="24510") %>%
        group_by(year) %>% summarize(emissions=sum(Emissions))
# Same for Los Angeles County
vehicle_LA <- filter(nei, SCC %in% vehicle) %>%
        filter(fips=="06037") %>%
        group_by(year) %>% summarize(emissions=sum(Emissions))
# Creating data frame to additionally plot absoulte increments
interval <- c(2002, 2005, 2008)
Baltimore <- vector("numeric",3)
for(j in 1:3){
        Baltimore[[j]] <- vehicle_Baltimore[[j+1,2]]-vehicle_Baltimore[[j,2]]
}
LA <- vector("numeric",3)
for(j in 1:3){
        LA[[j]] <- vehicle_LA[[j+1,2]]-vehicle_LA[[j,2]]
}
increments <- data.frame(interval, Baltimore, LA)

# Creating plot with base to a PNG file in the working directory
png("plot6.png", width = 960, height = 480)
par(mfrow = c(1, 2))
# Plot the absolute value evolution
plot(vehicle_LA$year, vehicle_LA$emissions, type="b", col="blue",
                        main="Total motor vehicle emissions",
                        ylim=c(0,4650),
                        xlab="year",
                        ylab="total PM2.5 emission from motor vehicle sources (tons)")
lines(vehicle_Baltimore$year, vehicle_Baltimore$emissions, type="b", col="black")
legend("right", lty=1, col=c("black","blue"), legend=c("Baltimore City", "Los Angeles County"))
# Plot the incremental evolution
plot(interval, LA, type="b", col="blue",
     main="Absolute change in motor vehicle emissions",
     xlab="end year of the period",
     ylab="absolute change in PM2.5 emission from motor vehicle sources (tons)",
     axes=FALSE)
axis(side = 1, at = c(2002,2005,2008))
axis(side = 2)
lines(interval, Baltimore, type="b", col="black")
legend("bottom", lty=1, col=c("black","blue"), legend=c("Baltimore City", "Los Angeles County"))
box()
dev.off()