<#
    takes a string for a file path as a parameter

    returns a boolean value representing whether file content is all ascii or not
#>

function verify-IsAscii
{
    param([string]$csvpath)

    $fileContent = Get-Content $csvpath -Raw
    $bytes = Get-Content -path $csvpath -Encoding Byte
    $bytesconverted = ([System.Text.Encoding]::ASCII.GetString($bytes))
    $isAscii = $filecontent -eq $bytesconverted

    return $isAscii
}

#$test = "C:\temp\userupdate3.csv"
#verify-csvIsAscii $test
