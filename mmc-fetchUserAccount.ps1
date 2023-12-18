<#
    Author:  Gavin Whitson
    Date:    05/15/2023
    Purpose: create a find function that can be used in tandem with other scripts written for the custom MMC
             I have been making. Can find accounts through various means, will have pop-ups when needed to have
             the user confirm which account is the one they want, before returning the full adobject for user 
             in other scripts

             works by building a string that is the get-aduser command we want to run, uses invoke expression to 
             call the command we create, if theres more than one account returned, call prompt-userChoice
             to select which one we want. Then outputs.

    Change Log:
#>

function mmc-fetchUserAccount
{
    [cmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [Alias('employeeNumber','username','samAccountName')]
        [string]$userInput,

        [Parameter(Mandatory=$false)]
        [Alias('use')]
        [String]$findBy,

        [Parameter(Mandatory=$false)]
        [Alias('eP')]
        [switch]$extendedProperties,

        [Parameter(Mandatory=$false)]
        [Alias('P')]
        [string]$properties
    )

    $query = "get-aduser "
    if ($userInput.Length -gt 1)
    {
        $userInput = "`'" + $userInput + "`'"
    }

    #### FIND ACCOUNTS BY CID
    if ($findBy -eq "CID")
    {
        if ($userInput -eq "")
        {
            $userInput = prompt-userInput "enter CID"
        }
    
        $query += "-Filter {employeeNumber -like " + $userInput + "}"
    }
    
    #### FIND ACCOUNTS BY OTHER ATTRIBUTE
    elseif ($findBy -ne "")
    {
        $query += " -filter {" + $findBy + " -like " + $userInput + "}"
    }

    #### BASE CASE -- get account by username
    elseif ($findBy -eq "")
    {
        $query += "-Filter {name -like " + $userInput + "}"
    }

    #### ADD PROPERTIES TO QUERY
    if ($extendedProperties.IsPresent)
    {
        $query += " -properties *"
    }
    elseif ($properties -ne "")
    {
        $query += (" -properties " + $properties)
    }

    #### VALIDATE/CLARIFY ACCOUNTS
    $queryRun = Invoke-expression $query
    if ($queryRun.length -gt 1)
    {
        $queryRun = prompt-userChoice $queryRun
    }

    if ($queryRun.length -eq 0)
    {
        display-CustomError ("No Accounts Found with query`n" + $query) 250 150
    }

    write-host $query
    return [Microsoft.ActiveDirectory.Management.ADUser]$queryRun
}