<#
    Author:  Gavin Whitson
    Date:    05/15/2023
    Purpose: take an array of objects and put them into a dropdown menu for the user
             to choose from

    Change Log:
#>

Invoke-Expression "Add-Type -AssemblyName System.Windows.Forms"
Invoke-Expression "Add-Type -AssemblyName System.Drawing"

function prompt-userChoice
{
    [cmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $availableChoices
    )

    ## OKAY BUTTON
    $OKButton = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Size(40,60)
        Size = New-Object System.Drawing.Size(75,23)
        Text = "OK"
        DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    $OKButton.Add_Click({$form.Close()})

    ## CANCEL BUTTON
    $CancelButton = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Size(125,60)
        Size = New-Object System.Drawing.Size(75,23)
        Text = "Cancel"
        DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    }
    $CancelButton.Add_Click({$form.Close()})

    ## POP-UP FORM BACKGROUND
    $form = new-object System.Windows.Forms.Form -Property @{
        startPosition = "CenterScreen"
        size = new-object system.drawing.size(500, 125)
        text = "Clarify Input"
    }
    $form.Controls.Add($OKButton)
    $form.Controls.Add($CancelButton)
    
    ## POP-UP FORM DROP DOWN Selection
    $comboBox = new-object System.Windows.Forms.ComboBox -Property @{
        location = New-Object System.Drawing.Size(10,10) 
        size = New-Object System.Drawing.Size(460,30)
    }
    
    $availableChoices | ForEach-Object {[void] $comboBox.Items.Add($_)}
    $comboBox.AutoCompleteMode = 'Append'
    $comboBox.AutoCompleteSource = 'ListItems'
    $comboBox.SelectedIndex = '0'


    $form.Controls.Add($comboBox)

    $form.Topmost = $True
    $form.ShowDialog() | out-null


    $userchoice = $comboBox.Text

    return $availableChoices[$comboBox.SelectedIndex]
}