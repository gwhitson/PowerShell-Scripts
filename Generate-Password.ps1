<#
    Author:  Gavin Whitson
    Date:    08/21/2023
    Purpose: Generate a password as a plaintext string for use in other scripts


    Change Log:
#>

function Get-RandomCharacters($length, $characters) 
{
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString)
{
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}

function Generate-Password([int]$length){
    $i = 0
    $password = ""

    while($i -le $length){
        $password += Get-RandomCharacters -length 1 -characters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()"

    $i += 1
    }
    return $password
}