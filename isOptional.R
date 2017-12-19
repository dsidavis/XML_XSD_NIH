setGeneric("isOptional", function(x) standardGeneric("isOptional"))

setMethod("isOptional", "GenericAttributeType", function(x) x@use != "required")
setMethod("isOptional", "SchemaTypeReference", function(x) x@optional)


setMethod("isOptional", "SchemaType", function(x) unname(length(x@count) > 0 && x@count[1] == 0L))

