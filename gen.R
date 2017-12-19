library(XML)
# Don't need XMLSchema unless we want to automate the generation
# of the Excel and/or the code in fillInXML().
#library(XMLSchema)

gen =
function(xlFile, ...)
{
    d = read_excel(xlFile)
    # Drop the first k rows corresponding to the comments.
    fillInXML(d, ...)
    # Then can saveXML() to a file or POST it to an API.
}

createXML =
    #
    # One approach is to construct the entire document programmatically...
    # The other (in fillInXML) is to use a template and fill in the parts we need to
    # This may involve programmatically creating some nodes, but not all the nodes.
    #
function(d)
{
    sub = newXMLNode("Submission")
    desc = newXMLNode("Description", parent = sub)
    # ...
}

fillInXML =
function(data, name = getData(data, "name", c("Duncan", "Temple Lang")),
         email = getData(data, "email", "dtemplelang@ucdavis.edu"),
         target_db = getData(data, "target_db", "BioSample"),
         doc = xmlParse(templateFile),
         templateFile = "template.xml")
{
     # Fill in the required email
    con = getNodeSet(doc, "//Contact")[[1]]
    xmlAttrs(con) = c(email = email)

    # If provided a non-empty name, either in the excel/data.frame
    # or in the call to fillInXML
    if(length(name)) {
        name = rev(name)
        f = getNodeSet(doc, "//Contact//First")[[1]]
        xmlValue(f) = name[1]
        if(length(name) > 1) {
            f = getNodeSet(doc, "//Contact//Last")[[1]]
            xmlValue(f) = name[2]
        }
    }
    

    h = getNodeSet(doc, "//Description//Hold")
    if(!is.na(getData(data, "Hold")))
       xmlAttrs(h[[1]]) = c("release_date" = data[1, "Hold"])
    else
       removeNodes(h)


    adata = getNodeSet(doc, "//Action/AddData")[[1]]
    xmlAttrs(adata) = c("target_db" = target_db)

    # Now the Data node.
    xdata = adata[["Data"]]
    dataFile = data[, "file"]        
    is.xml = isXML(dataFile)
    if(is.xml) {
        xmlAttrs(xdata) = c("content_type" = "XML")
        root = xmlRoot(xmlParse(dataFile))
        x = newXMLNode("XmlContent", root, parent = xdata)
    } else {
       library(base64enc)
       xmlAttrs(xdata) = c("content_type" = "text", content_encoding = "base64")
       # For now pretend data is a character vector. Could be a raw or file connection.

       b64 = base64encode(dataFile)
       x = newXMLNode("DataContent", b64, parent = xdata)
   }
    
    doc
}

isXML =
    #
    # We almost definitely know if the data are in XML form or binary. 
    #
    #
function(file)
{
      # Silly way to detect XML or not. Just for example.
   grepl("xml", tolower(file))
}

getData =
function(data, field, default = NA)    
{
    if(field %in% names(data) && !is.null(val  <- data[1, field]))
        return(val)
    else
       default
}


