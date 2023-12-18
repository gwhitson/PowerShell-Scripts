#Gavin Whitson
#Jan 4, 2023
#
#Supply group name and get all users who have that group

cls

write-host "Inputs must be exact for script to work"
$groupname = read-host "common name of group: "
$flag = read-host "change export location? (y/n)"

#default export path
$exportpath = "C:\temp\groupaccess.csv"

if ($flag -eq 'y') #for a new file location, it has to be the full network location, with the servername, or with the drive letter at the front of it.
{
    $exportpath = read-host "exact file location (csv name included):"
}



$dn = (get-adgroup -Identity $groupname -Properties distinguishedName).distinguishedName


(get-aduser -ldapfilter "(&(&(&(samAccountType=805306368)(memberOf:1.2.840.113556.1.4.1941:=$dn))))" -Properties DisplayName,employeeNumber | Select DisplayName, name, employeeNumber) | export-csv -Path $exportpath

write-host "done, check $exportpath"