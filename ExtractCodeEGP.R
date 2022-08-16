library(stringr)
library(dplyr)
library(xml2)

input_file <- 'C:/Users/maciej.gajdulewicz/Desktop/SAS/FarmerScoring20181105_1105.egp'
output_folder <- str_replace(input_file,fixed('.egp'),'')

# Set path to output folder
dir.create(output_folder)
setwd(output_folder)

# Extract project.xml
xml <- unzip(input_file,files='project.xml')

# Get code names
root <- read_xml(xml)
code_tasks = xml_find_all(root,'.//Element[@Type="SAS.EG.ProjectElements.CodeTask"]/Element')

code_names <- data.frame(ID=character(),Label=character(), stringsAsFactors = FALSE)

for (node in code_tasks) {
  Label = xml_text(xml_find_first(node,'Label'))
  ID = xml_text(xml_find_first(node,'ID'))
  row = list(ID=ID, Label=Label)
  code_names <- bind_rows(code_names, row)
}

# Build extract map

extract_map <- unzip(input_file, list=TRUE) %>%
  filter(str_detect(Name,'^Code.+sas$')) %>%
  mutate(ID=str_replace(Name,fixed('/code.sas'),'')) %>%
  select(Name, ID) %>%
  inner_join(code_names, by="ID")

#Extract files

for (row in 1:nrow(extract_map)){
  unzip(input_file, files=extract_map[row,'Name'], junkpaths = TRUE)
  clean_name=str_replace_all(extract_map[row,'Label'],'[/:*?"<>|]',"#")
  file.rename('code.sas',paste0(clean_name,'.sas'))
}
