print(sort(table(glbObsAll$.src, glbObsAll$labels, useNA = "ifany")))
print(sort(table(glbObsTrn$labels, useNA = "ifany")))
print(table(glbObsTrn$labels, useNA = "ifany"))

for (feat in c("good_for_lunch", "good_for_dinner")) {
    print(sprintf("Summary for %s:", feat))
    print(table(glbObsAll$.src, glbObsAll[, feat], useNA = "ifany"))
}

myplot_violin(glbObsTrn, "resXY.mad", glb_rsp_var)
myplot_violin(glbObsTrn, "resXY.mean", glb_rsp_var)
glbObsTrn$resXY.mean.log1p <- log1p(glbObsTrn$resXY.mean)
myplot_violin(glbObsTrn, "resXY.mean.log1p", glb_rsp_var)

print(myplotImg(img <- readJPEG("data/photos/426819.jpg")))
print(img[1:5, 1:5, 1])
print(img[1:5, 1:5, 2])
proxy::simil(x = as.vector(img[,,1]), y = as.vector(img[,,2]), method = "cosine")
proxy::simil(x = as.vector(img[,,1])[1:5], y = as.vector(img[,,2])[1:5], method = "cosine")
xy5 = rbind(as.vector(img[,,1])[1:5], as.vector(img[,,2])[1:5])
as.vector(proxy::simil(rbind(as.vector(img[,,1])[1:5], as.vector(img[,,2])[1:5]), method = "cosine"))
as.vector(proxy::simil(rbind(as.vector(img[,,1]), as.vector(img[,,2])), method = "cosine"))

startTm = proc.time()["elapsed"]
tst_vctr = feats_vctr[1:21]
print(dsp_numeric_feats_dstrb(tst_vctr))
print(sprintf("Elapsed seconds: %0.4f", proc.time()["elapsed"] - startTm))

dplyr::arrange(glb_feats_df[, c("id", "shapiro.test.p.value")], id, shapiro.test.p.value)
