# Create data/train_imgids.csv from data/train.csv & data/train_photo_to_biz.csv

obsTrn <- read.csv("data/train.csv")
obsTrnImg <- read.csv("data/train_photo_to_biz_ids.csv")
obsNew <- read.csv("data/test.csv")
obsNewImg <- read.csv("data/test_photo_to_biz.csv")

obsTrn$.src <- "Train"
obsTrnImg$.src <- "Train"
obsNew$.src <- "Test"
obsNewImg$.src <- "Test"

obsAll <- myrbind_df(obsTrn, obsNew)
print(table(obsAll$.src, useNA = "ifany"))
obsAllImg <- myrbind_df(obsTrnImg, obsNewImg)
print(table(obsAllImg$.src, useNA = "ifany"))

obsAllImg$chn <- gdata::duplicated2(obsAllImg$photo_id)
print(table(obsAllImg$chn, obsAllImg$.src, useNA = "ifany"))

# Diagnostics
# Non-chain images in Train
print(head(obsAllImg[!obsAllImg$chn & obsAllImg$.src == "Train", ]))
print(obsAllImg[obsAllImg$photo_id %in% c(204149,52779,278973,195284,19992,80748), ])

# chain images in Train
print(head(obsAllImg[obsAllImg$chn & obsAllImg$.src == "Train", ]))
#print(obsAllImg[obsAllImg$photo_id %in% c(204149,52779,278973,195284,19992,80748), ])

# Non-chain images in Test
print(head(obsAllImg[!obsAllImg$chn & obsAllImg$.src == "Test", ]))
print(obsAllImg[obsAllImg$photo_id %in% c(243117,111793,405796,347606,439834,272107), ])

# chain images in Train
print(head(obsAllImg[obsAllImg$chn & obsAllImg$.src == "Test", ]))
print(obsAllImg[obsAllImg$photo_id %in% c(317818), ])
print(obsAllImg[obsAllImg$photo_id %in% c(30679), ])
print(obsAllImg[obsAllImg$photo_id %in% c(455084), ])

# Dups by business_id ?
print(sum(obsDup <- gdata::duplicated2(obsAll$business_id)))

nImgsAll <-
    #obsAllImg[1:10, c("photo_id", "business_id")] %>%
    obsAllImg[, c("photo_id", "business_id")] %>%
    dplyr::group_by(business_id) %>%
    dplyr::summarize(nImgs = n_distinct(photo_id))
    #tidyr::spread(value = photo_id)

print(summary(nImgsAll$nImgs))

imgAll <-
    obsAllImg[, c("photo_id"), FALSE] %>%
    dplyr::distinct(photo_id)

require(jpeg)
img <- readJPEG("data/photos/204149.jpg")
img <- readJPEG("data/photos/52779.jpg")
img <- readJPEG("data/photos/278973.jpg")
image <- apply(img, 1:2, function(v) rgb(v[1], v[2], v[3]))
image <- melt(image)
ggplot(image, aes(Var2, -Var1, fill = value)) + geom_raster() + scale_fill_identity()

topNImgsAll <-
    #obsAllImg[1:10, c("photo_id", "business_id")] %>%
    obsAllImg[, c("photo_id", "business_id")] %>%
    dplyr::group_by(business_id) %>%
    dplyr::top_n(3, photo_id) %>%
    dplyr::mutate(imgIx = row_number()) %>%
    tidyr::spread(key = imgIx, value = photo_id)

names(topNImgsAll)[2:length(names(topNImgsAll))] <-
    paste("imgId", names(topNImgsAll)[2:length(names(topNImgsAll))], sep = ".")

myprint_df(topNImgsAll)

obsAll <- dplyr::left_join(obsAll, sprAll)
print(tapply(obsAll$nImgs, obsAll$.src, summary))
myprint_df(obsAll)

write.csv(subset(obsAll, .src == "Train", select = -.src),
          "data/train_nImgs.csv", row.names = FALSE)
write.csv(subset(obsAll, .src == "Test" , select = -.src) %>% subset(select = -labels),
          "data/test_nImgs.csv" , row.names = FALSE)