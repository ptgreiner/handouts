## Importing vector data

library(sf)
library(rgdal)

shp <- 'data/cb_2016_us_county_5m'
counties <- st_read(shp, stringsAsFactors = FALSE)
class(counties)

## Bounding box

library(dplyr)
counties_md <- filter(counties, STATEFP=="24")
plot(counties_md$geometry)
## Grid

grid_md <- st_make_grid(counties_md, n=4)
st_bbox(grid_md)


## Plot layers

plot(grid_md)
plot(counties_md$geometry, add=TRUE)

## Create geometry

sesync <- st_sfc(
    st_point(c(-76.503394, 38.976546)),
        crs=4326)


counties_md <- st_transform(counties_md, crs=st_crs(sesync))
plot(counties_md$geometry)
plot(sesync, col = "green", pch = 20, add = T)

## Exercise 1
plot(counties_md$geometry)
overlay	<- st_within(sesync, counties_md)
counties_sesync <- counties_md[overlay[[1]], 'geometry']
plot(counties_sesync, col = "red", add = TRUE)
plot(sesync, col = 'green', pch = 20, add = TRUE)

#st_within(sesync, counties_md)

## Coordinate transforms

shp <- 'data/huc250k'
huc <- st_read(shp)
plot(huc$geometry)

st_crs(huc)

prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'

counties_md <- st_transform(counties_md, crs=prj)
huc <- st_transform(huc,crs=prj)
sesync <- st_transform(sesync, crs=prj)
#check prjection transormations above
st_crs(counties_md)
st_crs(huc)
st_crs(sesync)
#plot newly transformed objects
plot(counties_md$geometry)
plot(huc, border = 'blue', add = TRUE)
plot(sesync, col = 'green', pch = 20, add = TRUE)


###### Geometric operations on vector layers
#clip inner boundaries
state_md<- st_union(counties_md)
plot(state_md)

huc_md <- st_intersection(huc, state_md)
plot(huc_md, border = 'blue', col = NA, add = TRUE)

## Exercise 2

bubble_md <- st_buffer(state_md, 5000)
plot(state_md)
plot(bubble_md, lty = 'dotted', add = TRUE)

## Working with raster data

library(raster)
nlcd <- raster("data/nlcd_agg.grd")
class(nlcd)
nlcd
plot(nlcd)
plot(huc_md, add=TRUE)


## Crop

extent <- matrix(st_bbox(huc_md), nrow=2)
extent
nlcd <- crop(nlcd, extent)
plot(nlcd)
plot(huc_md, add=T)
plot(nlcd)
plot(state_md, add=T)

## Raster data attributes

lc_types <- nlcd@data@attributes[[1]]$Land.Cover.Class
lc_types
## Raster math

pasture <- mask(nlcd, nlcd == 81, maskvalue = FALSE)
plot(pasture)

nlcd_agg <- ...(nlcd, ..., ...)
...
plot(nlcd_agg)

## Exercise 3

...

## Mixing rasters and vectors: prelude

sesync <- as(..., "Spatial")
huc_md <- as(..., "Spatial")
counties_md <- ...

## Mixing rasters and vectors

plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, ...)

sesync_lc <- ...(nlcd, sesync)

county_nlcd <- ...

modal_lc <- extract(...)
... <- lc_types[modal_lc + 1]

