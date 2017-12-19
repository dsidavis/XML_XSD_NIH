gen =
function(xlFile)
{
    d = read_excel(xlFile)
    fillInXML(d)
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
function(data, name = c("Duncan", "Temple Lang"), email = "dtemplelang@ucdavis.edu",
         target_db = "BioSample",
         doc = xmlParse(templateFile), templateFile = "template.xml")
{
    con = getNodeSet(doc, "//Contact")[[1]]
    xmlAttrs(con) = c(email = email)
    f = getNodeSet(doc, "//Contact//First")[[1]]
    xmlValue(f) = name[1]
    f = getNodeSet(doc, "//Contact//Last")[[1]]
    xmlValue(f) = name[2]

    h = getNodeSet(doc, "//Description//Hold")
    if(!is.na(data[1, "Hold"]))
       xmlAttrs(h[[1]]) = c("release_date" = data[1, "Hold"])
    else
       removeNodes(h)


    adata = getNodeSet(doc, "//Action/AddData")[[1]]
    xmlAttrs(adata) = c("target_db" = target_db)

      # Now the Data node.
    data = adata[["Data"]]
    xmlAttrs(data) = c("content_type" = )
    
    doc
}




