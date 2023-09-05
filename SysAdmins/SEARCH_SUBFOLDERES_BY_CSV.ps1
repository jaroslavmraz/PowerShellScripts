param(
    [Parameter(Mandatory=$true)]
    [string]$from,

    [Parameter(Mandatory=$true)]
    [string]$to,

    [Parameter(Mandatory=$false)]
    [string]$CsvFile,

    [Parameter(Mandatory=$false, Alias='csv-line')]
    [string]$CsvLine
)


##############################################
## SCRIPT TO SEARCH FOR FILES FROM CSV FILE ##
##############################################
# Autor: Jaroslav Mraz                       #
##############################################
# V2                                         #
##############################################
#            SAMPLE CSV FILE                 #
#                                            #
#    IDr,                                    #
#    filename.extension,                     #
#    filename2.extension,                    #
#                                            #
##############################################
<#
.SYNOPSIS
A script to recursive search and copy files based on input from either a CSV file or direct CSV data.

.DESCRIPTION
This script search recurs files and copies them from a specified source directory to a specified destination directory. The files to copy are determined by an 'CsvFile' value either in a CSV file or provided directly as CSV data.

.PARAMETER from
The source directory where the script looks for files to copy.

.PARAMETER to
The destination directory where the files are copied.

.PARAMETER CsvFile
The path to the CSV file that contains the filenames of the files to be copied.

.PARAMETER csv-line
Direct CSV data that contains the filenames of the files to be copied. This parameter cannot be used together with the CsvFile parameter.

.EXAMPLE
.\SEARCH_SUBFOLDERES_BY_CSV.ps1 -from "C:\Shares\Share\" -to "C:\FOUND" -CsvFile "E:\CsvFile.csv"

.EXAMPLE
.\SEARCH_SUBFOLDERES_BY_CSV.ps1 -from "C:\Shares\Share\" -to "C:\FOUND" --csv-line "CsvFile`nfilename1.ext`nfilename2.ext"

.NOTES
Either the 'CsvFile' parameter or the 'csv-line' parameter must be provided, not both.
#>

# Check if both CsvFile and csv-line are provided or neither
if (($CsvFile -and $CsvLine) -or (-not $CsvFile -and -not $CsvLine)) {
    Write-Error "Please provide either CsvFile or --csv-line, not both or neither."
    exit
}

$IDArray = if ($CsvFile) {
    Import-Csv -Path $CsvFile
} elseif ($CsvLine) {
    $CsvLine | ConvertFrom-Csv
}

$foundCount = 0
$notFoundCount = 0
$notFoundFiles = @()

foreach ($row in $IDArray) {
    Write-Host "Searching for files that match: $($row.CsvFile)"
    $matchingFiles = Get-ChildItem -Path $from -Recurse | Where-Object { $_.Name -eq $row.CsvFile }

    if ($matchingFiles) {
        Write-Host "Found $($matchingFiles.Count) file(s)"
        $matchingFiles | ForEach-Object {
            $sourcePath = Join-Path -Path $_.Directory -ChildPath $_.Name
            Write-Host "Copying $sourcePath to $to"
            Copy-Item -Path $sourcePath -Destination $to
        }
        $foundCount += $matchingFiles.Count
    } else {
        Write-Host "No files found that match: $($row.CsvFile)"
        $notFoundFiles += $row.CsvFile
        $notFoundCount++
    }
}

Write-Host "Summary: Found and copied $foundCount file(s). Did not find $notFoundCount file(s)."

if ($notFoundCount -gt 0) {
    Write-Host "The following files were not found:"
    $notFoundFiles | Format-Table
}
