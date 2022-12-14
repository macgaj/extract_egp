# -*- coding: utf-8 -*-
"""
Created on Thu Nov 22 11:36:11 2018
Following code can be used to extract *.sas codes from enterprise guide. 
@author: Maciej.Gajdulewicz
"""

import xml.etree.ElementTree as ET
import shutil
import zipfile

# INPUTS
## Define Enterprise Guide File
input_file = 'C:\\Users\\maciej.gajdulewicz\\Desktop\\SAS\\FM_Backup1.egp'
output_folder = input_file.replace('.egp','\\')

## Set Zip
with zipfile.ZipFile(input_file) as epg_file:
    
    ## Get code names from project.xml
    
    with epg_file.open('project.xml', mode='r') as xml:
        tree = ET.parse(xml)
        
        # Set root
        root = tree.getroot()
    
        # Get CodeTask
        code_tasks = root.findall('.//Element[@Type="SAS.EG.ProjectElements.CodeTask"]/Element')
    
        # Save names
        code_names = {e.find('ID').text : e.find('Label').text for e in code_tasks}
        
        code_names.items
        
        ## Get list of SAS codes
        code_files = [file for file in epg_file.namelist() if file.startswith('CodeTask') and file.endswith('code.sas')]
        
        # Prepare in-out list
        extract_map = [(x,code_names[x.replace('/code.sas','')]+'.sas') for x in code_files if x.replace('/code.sas','') in set(code_names.keys())]
    
        # Loop through 
        for in_f, out_f in extract_map:
                epg_file.extract(in_f,output_folder)
                
                # Replace any special charaters from output file name with #
                o_clean = "".join(i if i not in r'\/:*?"<>|' else '#' for i in out_f)
            
                shutil.copy(output_folder+in_f,output_folder+o_clean)
                shutil.rmtree(output_folder+in_f.replace('/code.sas',''))
                