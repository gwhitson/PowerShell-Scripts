# Gavin Whitson
# January 4, 2023 
# Generate CSV of all users in a specific OU 

$OUpath = Read-Host "Distinguished name of OU"
$ExportPath = Read-host "Filepath to store output"

Get-ADUser -Filter * -SearchBase $OUpath -Properties * | Select-Object name, Description  | export-csv -path $ExportPath