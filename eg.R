source("gen.R")

# This would come from a row of an excel file
d = data.frame(email = "bob@ucdavis.edu", file = "SampleData.gz", Hold = as.Date("2018-12-1"))


d$file = "SampleXMLData"
doc = fillInXML(d)

d$file = "SampleData.gz"
doc = fillInXML(d)
