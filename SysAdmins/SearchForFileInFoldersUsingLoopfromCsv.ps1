##############################################
## SCRIPT TO SEARCH FOR FILES FROM CSV FILE ##
##############################################
# Autor: Jaroslav Mraz                       #
##############################################
#            SAMPLE CSV FILE                 #
#                                            #
#    IDr,                                    #
#    filename.extension,                     #
#    filename2.extension,                    #
#                                            #
##############################################


$to = "E:\DESTINATION FOLDER"
$from = "E:\SORUCE_FOLDER"

$IDArray = Import-CSV E:\IDr.csv
foreach ( $ROW in $IDArray)
{

 Get-ChildItem $ROW.IDr -Path $from -Recurse | %{Join-Path -Path $_.Directory -ChildPath $_.Name } | Copy-Item -Destination $to
 
}
 
