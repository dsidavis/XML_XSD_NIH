
```
library(XMLSchema)
s = readSchema("submission.xsd")
```

```
names(s)
```

```
sapply(s[[1]], class)
```
Only one element of s[[1]] is of class Element, i.e., an XML element.
The others are ClassDefinition, ExtendedClassDefinition, UnionDefinition,
AttributeGroup and RestrictedStringDefinition objects.

So Submission is the top-level element for our XML document
which we knew from the sample document. But we have a mechanism to figure it out from
a schema also in this particular case. (For other cases, we may have to do a little more
work.)


```
sub = s[[1]]$Submission
```
This describes the Submission XML element, e.g., the name of
the element, its namespace, count and
also, most importantly, its possible attributes 
and the type information for the sub-elements.
We get these via 
```
sub@attributes
sub@type
```

sub@type is a ClassDefinition that describes the contents of a Submission.
We can explore its contents with
```
slotNames(sub@type)
 [1] "slotTypes"     "isAttribute"   "uris"          "fromConverter"
 [5] "toConverter"   "count"         "abstract"      "name"         
 [9] "ns"            "nsuri"         "default"       "Rname"        
[13] "documentation" "srcNode"      
```

The sub-elements are
```
names(sub@type@slotTypes)
[1] "Description"    "Action"         "schema_version"
[4] "resubmit_of"    "submitted"      "last_update"   
[7] "status"         "submission_id" 
```

Their types are
```
sapply(sub@type@slotTypes, class)
   Description         Action schema_version    resubmit_of 
     "Element"      "Element" "AttributeDef" "AttributeDef" 
     submitted    last_update         status  submission_id 
"AttributeDef" "AttributeDef" "AttributeDef" "AttributeDef" 
```
Again we see Element objects for possible sub-elements.
We also see the 6 possible attributes for the Submission again!


Looking at the Description element, we simply see
```
sub@type@slotTypes$Description
<Description>
```
The object contains a lot more information that is printed.

```
sub@type@slotTypes$Description@type
ListOfComment_Submitter_Organization_Hold_SubmissionSoftware (schema class Definition) 
                                 name              Rtype min max descriptionClass
Comment                       Comment          character   0   1     LocalElement
Submitter                   Submitter        typeAccount   0   1     LocalElement
Organization             Organization   typeOrganization   1 Inf     LocalElement
Hold                             Hold               Hold   0   1    SimpleElement
SubmissionSoftware SubmissionSoftware SubmissionSoftware   0   1    SimpleElement
```
The min/max fields tell us whether these elements are optional, required or can have multiple entries.


The Action object is an Element and its type slot has class
ExtendedClassDefinition.
```
sub@type@slotTypes$Action@type
Action extends  (schema class Definition) 
                                       name                      Rtype min max descriptionClass
action_id                         action_id                      token  NA  NA     AttributeDef
submitter_tracking_id submitter_tracking_id submitter_tracking_id.Enum  NA  NA     AttributeDef
```
Note that this inherits from another type. In this case, 
the type is defined in the schema's XML  for Action.
We can find this via the baseType slot:
```
sub@type@slotTypes$Action@type@baseType
An object of class "UnionDefinition"
Slot "slotTypes":
$AddFiles
<AddFiles>

$AddData
<AddData>

$ChangeStatus
<ChangeStatus>


Slot "isAttribute":
    AddFiles      AddData ChangeStatus 
       FALSE        FALSE        FALSE 

Slot "uris":
[1] NA NA NA

Slot "fromConverter":
function () 
NULL

Slot "toConverter":
function () 
NULL

Slot "count":
numeric(0)

Slot "abstract":
logical(0)

Slot "name":
[1] ".anon"

Slot "ns":
character(0)

Slot "nsuri":
[1] NA

Slot "default":
NULL

Slot "Rname":
[1] ".anon"

Slot "documentation":
character(0)

Slot "srcNode":
<xs:choice>
  <xs:element name="AddFiles">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="File" minOccurs="1" maxOccurs="unbounded">
          <xs:complexType>
            <xs:complexContent>
              <xs:extension base="typeFile">
                <xs:attribute name="target_db_label" use="optional">
                  <xs:annotation>
                    <xs:documentation>
                                File label the use of which is specific to target database. For example, for dbGaP genotype files, it can represent anonymized ids of dbGaP samples
                              </xs:documentation>
                  </xs:annotation>
                </xs:attribute>
              </xs:extension>
            </xs:complexContent>
          </xs:complexType>
        </xs:element>
        <xs:choice minOccurs="0" maxOccurs="unbounded">
          <xs:element name="Attribute" type="typeFileAttribute"/>
          <xs:element name="Meta" type="typeInlineData"/>
          <xs:element name="AttributeRefId" type="typeFileAttributeRefId"/>
          <xs:element name="SequenceData" type="typeSequenceData"/>
          <xs:element name="Publication" type="com:typePublication" maxOccurs="unbounded"/>
        </xs:choice>
        <xs:element name="Status" type="typeReleaseStatus" minOccurs="0" maxOccurs="1"/>
        <xs:element name="Identifier" type="com:typeIdentifier" minOccurs="0" maxOccurs="1"/>
      </xs:sequence>
      <xs:attributeGroup ref="attributesFileGroup"/>
    </xs:complexType>
  </xs:element>
  <xs:element name="AddData">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Data" minOccurs="1" maxOccurs="1">
          <xs:complexType>
            <xs:complexContent>
              <xs:extension base="typeInlineData">
                <xs:attribute name="target_db_label" use="optional">
                  <xs:annotation>
                    <xs:documentation>
                                Data label the use of which is specific to target database. Same as for AddFiles, but this is inlined data. 
                              </xs:documentation>
                  </xs:annotation>
                </xs:attribute>
              </xs:extension>
            </xs:complexContent>
          </xs:complexType>
        </xs:element>
        <xs:choice minOccurs="0" maxOccurs="unbounded">
          <xs:element name="Attribute" type="typeFileAttribute"/>
          <xs:element name="AttributeRefId" type="typeFileAttributeRefId"/>
          <xs:element name="SequenceData" type="typeSequenceData"/>
          <xs:element name="Publication" type="com:typePublication" maxOccurs="unbounded"/>
        </xs:choice>
        <xs:element name="Status" type="typeReleaseStatus" minOccurs="0" maxOccurs="1"/>
        <xs:element name="Identifier" type="com:typeIdentifier" minOccurs="0" maxOccurs="1"/>
      </xs:sequence>
      <xs:attributeGroup ref="attributesFileGroup"/>
    </xs:complexType>
  </xs:element>
  <xs:element name="ChangeStatus">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Target" type="com:typeRefId"/>
        <xs:choice>
          <xs:element name="Release"/>
          <xs:element name="SetReleaseDate">
            <xs:complexType>
              <xs:attribute name="release_date" type="xs:date"/>
            </xs:complexType>
          </xs:element>
          <xs:element name="Suppress" type="xs:string"/>
          <xs:element name="Withdraw" type="xs:string"/>
          <xs:element name="AddComment" type="xs:string"/>
        </xs:choice>
        <xs:element name="Identifier" type="com:typeIdentifier" minOccurs="0" maxOccurs="1"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:choice> 
```
This contains both the processed content extracted  (...???)

The type is a UnionDefinition. This means that this is a <choice> in the schema and
the element should be one of the types in the union, i.e., AddFiles, AddData or ChangeStatus.

In the example file, the content for this part is an AddData element.
We can look at this  type
```
sub@type@slotTypes$Action@type@baseType@slotTypes[[2]]
sub@type@slotTypes$Action@type@baseType@slotTypes[[2]]@type
```




For the Submission, what is required and what is optional

```
source("isOptional.R")
opt = sapply(sub@type@slotTypes, isOptional)
```

So the Description and Action are required.

Looking at the contents of Description, what is required:
```
sapply(sub@type@slotTypes$Description@type@slotTypes, isOptional)
```
So only Organization is required.

(We should be able to resolve the description for this with 
 resolve(sub@type@slotTypes$Description@type@slotTypes$Organization@type, s)
but it raises an error.)

org = s[[1]]$typeOrganization

sapply(org@slotTypes, isOptional)
```
    Name  Address  Contact     type     role   org_id      url group_id 
      NA     TRUE     TRUE    FALSE     TRUE     TRUE     TRUE     TRUE 
```
So we need a type for the organization.
And this is an attribute
class(org@slotTypes$type)

When we look at the type for this attribute
class(org@slotTypes$type@type)
we see it is a RestrictedStringDefinition. So there is a fixed set of possible values:
```
org@slotTypes$type@type@values
```

We can check that the values entered in the spreadsheet for this column are all in this set.
Ideally, Excel would prohibit entering a value not from this set and would also auto-complete.


(The role attribute should be owner or participant.)



What are the required components of Action?
```
sapply(sub@type@slotTypes$Action@type@slotTypes, isOptional)
```
This only gives us two items which are both attribute descriptions:
action_id  and submitter_tracking_id.

Note that submitter_tracking_id is an attribute whose type is a 
RestrictedStringLengthType, ensuring the string is between 1 and 255 characters.


What about the other elements in Action?
Remember the @type slot in Action is an ExtendedClassDefinition.
So we need to find the definition for the schema this schema type extends.
```
act@type@baseType
```
This is the UnionDefinition from above.
So we need one of the elements 
```
names(act@type@baseType@slotTypes)
[1] "AddFiles"     "AddData"      "ChangeStatus"
```


