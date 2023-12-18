<#

    .SYNOPSIS
    Confirm-IsAscii checks the raw contents of the given file against the byte-codes casted to ASCII values
    
    .DESCRIPTION
    Requires a valid, accessible, filepath as a parameter
    
    .PARAMETER filepath
    File to be checked against ascii characters

    .EXAMPLE
    Confirm-IsAscii "C:\temp\test.txt"

#>

function Confirm-IsAscii{
    param(
        [Parameter(Mandatory, position=0, HelpMessage="Enter a filepath")]
        [ValidateNotNullOrEmpty()]
        [string]$filepath
        )

    $isAscii = $false

    if ((test-path $filepath) -eq $false){
        write-error "Invalid filepath"
        return $false
    }

    $fileContent = Get-Content $filepath -Raw -ErrorAction Stop
    $bytes = Get-Content -path $filepath -Encoding Byte -ErrorAction Stop
    $bytesconverted = ([System.Text.Encoding]::ASCII.GetString($bytes))
    $isAscii = $filecontent -eq $bytesconverted

    return $isAscii
}