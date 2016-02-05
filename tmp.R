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
