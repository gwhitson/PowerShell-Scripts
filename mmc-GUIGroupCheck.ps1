<#
    Author:  Gavin Whitson
    Date:    05/31/2023

    Purpose: make a function that can be called with the common name of a group
             to make a pop-up displaying the members and memberOf for the group

    Change Log:
        
#>

function mmc-GUIGroupCheck{

    [cmdletBinding()]
    param (
        [parameter(mandatory=$true)]
        [string]$groupName
    )
    $group = get-adGroup -Identity $groupName -Properties members, memberOf
    $testertester = @{
        out = "More than 500 results"
        test = 'test'
    }

    #### variables to make setting sizes easier
    $displayxval = 350
    $displayyval = 450
    $font = New-Object System.Drawing.Font("Courier", 10,[System.Drawing.FontStyle]::Regular)

    #### Generate inital box
    $DisplayBox = new-object System.Windows.Forms.Form -Property @{
        text = [string]($group.name)
        size = New-Object System.Drawing.Size($displayxval,$displayyval)
        startPosition = "CenterScreen"
    }


    $ApplyButton = new-object System.windows.forms.button -Property @{
        Text = "Okay"
        size = new-object System.Drawing.Size(75, 23)
        Location = New-Object System.Drawing.Size(20, ($displayyval - 75))
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $ApplyButton.Add_Click({$DisplayBox.Close()})

    $cancelButton = new-object System.windows.forms.button -Property @{
        Text = "Cancel"
        size = new-object System.Drawing.Size(75, 23)
        Location = New-Object System.Drawing.Size(105, ($displayyval - 75))
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $cancelButton.Add_Click({$DisplayBox.Close()})
    
    $DisplayBox.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
        {
            $DisplayBox.close()
        }})

    $DisplayBox.Controls.Add($ApplyButton)
    $DisplayBox.Controls.Add($cancelButton)


    #### Members Section
    $membersLabel = new-object System.windows.forms.label -Property @{
        text = "Members:"
        size = new-object System.Drawing.Size(305, 15)
        Location = New-Object System.Drawing.Size(15,10)
    }
    $MembersBox = new-object System.windows.forms.listbox -Property @{
        size = new-object System.Drawing.Size(305, 150)
        Location = New-Object System.Drawing.Size(15,25)
        font = New-Object System.Drawing.Font("Courier", 9,[System.Drawing.FontStyle]::Regular)
    }
    $DisplayBox.Controls.Add($MembersBox)
    $displayBox.Controls.Add($membersLabel)
    #($group.members) | % {
    #    $MembersBox.items.add((get-adobject -Identity $_).name)
    #    if ($membersBox.items.length -gt 500)
    #    {
    #        break
    #    }
    #}
    $i = 0
    while ($i -lt 500 -and $group.members[$i] -ne $null)
    {
        #$membersBox.items.add((get-adobject -Identity $group.members[$i]).name)
        #$i += 1
        try{
            $membersBox.items.add((get-adobject -Identity $group.members[$i]).name)
        }
        catch
        {
        }
        $i += 1
    }
    if ($i -ge 500)
    {
        $membersBox.items.add("More than 500 results")
    }

    #### Member Of section
    $MemberOfLabel = new-object System.windows.forms.label -Property @{
        text = "Member Of:"
        size = new-object System.Drawing.Size(305, 15)
        Location = New-Object System.Drawing.Size(15,200)
    }
    $MemberOfBox = new-object System.windows.forms.listbox -Property @{
        size = new-object System.Drawing.Size(305, 150)
        Location = New-Object System.Drawing.Size(15,215)
        font = New-Object System.Drawing.Font("Courier", 9,[System.Drawing.FontStyle]::Regular)
    }
    $DisplayBox.Controls.Add($MemberOfBox)
    $displayBox.Controls.Add($MemberOfLabel)
    #($group.memberOf) | % {
    #    $MemberOfBox.items.add((get-adobject -Identity $_).name)
    #    write-host $memberOfBox.items.length
    #    if ($MemberOfBox.items.length -gt 500)
    #    {
    #        break
    #    }
    #}
    $i = 0
    while ($i -lt 500 -and $group.memberof[$i] -ne $null)
    {
        #if ($group.memberOf[$i] -ne $null)
        try{
            $MemberOfBox.items.add((get-adobject -Identity $group.memberOf[$i]).name)
        }
        catch
        {
        }
        $i += 1
    }
    if ($i -ge 500)
    {
        $MemberOfBox.items.add("More than 500 results")
    }

    $DisplayBox.Topmost = $True
    $DisplayBox.ShowDialog() | out-null
    $displayBox.Dispose()

}