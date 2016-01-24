# Create data/test.csv from data/test_photo_to_biz.csv
obs <- read.csv("data/test_photo_to_biz.csv")
obsNew <- dplyr::group_by(obs, business_id) %>%
    dplyr::count(business_id) %>%
    as.data.frame()
print(myprint_df(obsNew))
write.csv(obsNew[, "business_id", FALSE], "data/test.csv", row.names = FALSE)
