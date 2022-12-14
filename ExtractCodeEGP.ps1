# Provide the filename (without extention)
$filename = ""

# Create zip from egp
Copy-Item "$filename.egp" "$filename.zip"

# Unzip
Expand-Archive -Force "$filename.zip" "$filename\"

# Continue to folder
Set-Location $filename

# Get objects in folder
$list = Get-ChildItem .

# Loop through
$list | ForEach-Object {
    if ($_.Name -like "Codetask*") {
        # Case 1: Codetask* - extact and rename
        $array = $_.Name.Split("-")
        $srcfile = "$_\code.sas"
        $dstfile = $array[2]+".sas"

        Move-Item $srcfile $dstfile
        Remove-Item -Recurse $_
    } else {
        # Case 2: Else -remove
        Remove-Item -Recurse $_
    }
}

Set-Location ..

Remove-Item "$filename.zip"