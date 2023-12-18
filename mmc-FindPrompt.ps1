<#
    Author:  Gavin Whitson
    Date:    06/15/2023

    Purpose: create a pop up to take in an attribute and a value 
             to search for in AD

    Change Log:
        
#>

function mmc-FindPrompt
{
    [cmdletBinding()]
    param()


    $queryToRun = "mmc-fetchUserAccount -ep "

    #### Box
    $findPrompt = new-object System.Windows.Forms.Form -Property @{
        text = "Find"
        size = new-object System.Drawing.size(250, 150)
        startPosition = "CenterScreen"
    }
    
    #### Find Button
    $findButtonClick = {$findPrompt.close()}
    $FindButton = new-object System.windows.forms.button -Property @{
        Text = "Find"
        size = new-object System.Drawing.Size(72, 23)
        Location = New-Object System.Drawing.Size(60, 80)
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $FindButton.Add_Click($findButtonClick)
    $findPrompt.Controls.Add($FindButton)


    #### Cancel Button
    $cancelButton = new-object System.windows.forms.button -Property @{
        Text = "Cancel"
        size = new-object System.Drawing.Size(72, 23)
        Location = New-Object System.Drawing.Size(138, 80)
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $cancelButton.Add_Click({$findPrompt.Close()})
    $findPrompt.Controls.Add($cancelButton)

    #### Find By - Drop Down Menu
    $findByChoices = @("Username", "CID", "FullName", "Title (slow)", "Department")
    $findByDropDown = New-Object System.windows.forms.ComboBox -Property @{
        location = New-Object System.Drawing.Size(60,10) 
        size = New-Object System.Drawing.Size(150,30)
    }
    $findByDropDown.AutoCompleteSource = 'ListItems'
    $findByDropDown.AutoCompleteMode = 'Append'
    $findByChoices | % {[void]$findByDropDown.Items.Add($_)}
    $findByDropDown.SelectedIndex = 0
    $findPrompt.Controls.Add($findByDropDown)
    
    #### Find By - Drop Down Label
    $FindByLabel = new-object System.windows.forms.label -Property @{
        text = "Find By: "
        size = new-object System.Drawing.Size(50, 20)
        Location = New-Object System.Drawing.Size(10, 10)
        #backColor = "white"
    }
    $findPrompt.Controls.Add($FindByLabel)

    #### Find By - Value Text Box
    $findValue = New-Object System.windows.forms.textBox -Property @{
        location = New-Object System.Drawing.Size(60,40) 
        size = New-Object System.Drawing.Size(150,30)

    }
    $findPrompt.Controls.Add($findValue)
    
    #### Find By - Value Label
    $FindValueLabel = new-object System.windows.forms.label -Property @{
        text = "Value : "
        size = new-object System.Drawing.Size(50, 35)
        Location = New-Object System.Drawing.Size(10, 40)
        #backColor = "white"
    }
    $findPrompt.Controls.Add($FindValueLabel)

    
    #### Key Controls    
    $findValue.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
        {$findPrompt.close()}})
    $findValue.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
        {$findPrompt.Close()}})

    $findPrompt.add_shown({$findValue.select()})
    $findPrompt.ShowDialog() | out-null
    $findPrompt.Dispose()
    
    $chosenOption = $findByChoices[$findByDropDown.SelectedIndex]
    switch ($chosenOption)
    {
           ("CID")
           {
                $queryToRun = $queryToRun + " -findBy `'employeeNumber`' `'" + $findValue.Text + "`'"
           }
           ("Username")
           {
                $queryToRun = $queryToRun + "`'" + $findValue.Text + "*`'"
           }
           ("FullName")
           {
                $queryToRun = $queryToRun + " -findBy `'DisplayName`' `'" + $findValue.Text + "`'"
           }
           ("Title (slow)")
           {
                $queryToRun = $queryToRun + " -findBy `'Title`' `'" + $findValue.Text + "`'"
           }("Department")
           {
                $queryToRun = $queryToRun + " -findBy `'Department`' `'" + $findValue.Text + "`'"
           }
    }

    #write-host $queryToRun
    return $queryToRun
}