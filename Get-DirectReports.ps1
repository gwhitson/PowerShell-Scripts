<#
    Author:  Gavin Whitson
    Date:    06/15/2023

    Purpose: returns a list of all objects managed by the username 
             given as a parameter

    Change Log:
        
#>

function Get-DirectReports
{
    param([string]$username)
    $dn = (get-aduser -Identity $username).distinguishedname
	# default is root of domain
    $scope = (Get-ADDomain).distinguishedname

    $test2 = get-adobject -SearchBase $scope -SearchScope 2  -filter {manager -like $dn}

    return $test2
} 