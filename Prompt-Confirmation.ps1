<#
    Author:  Gavin Whitson
    Date:    5/12/2023
    Purpose: prompt a user for confirmation with a graphical interface
#>

function prompt-confirmation{

    param([String]$displayString = "")

    $confirm
    $yesbuttonClick = {$confirm = "yes"}
    $nobuttonClick = {$confirm = "no"}

    $yesbutton = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Size(25,180)
        Size = New-Object System.Drawing.Size(75,23)
        Text = "Yes"
        DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    $yesbutton.Add_Click($yesbuttonClick)
    $yesbutton.Add_Click({$form.close()})
    $nobutton = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Size(105,180)
        Size = New-Object System.Drawing.Size(75,23)
        Text = "No"
    }
    $nobutton.add_Click($nobuttonClick)
    $nobutton.Add_Click({$form.Close()})

    $form = new-object System.Windows.Forms.Form -Property @{
        Text = "Confirm"
        size = new-object System.Drawing.Size(250,250)
        StartPosition = "CenterScreen"
        acceptButton = $yesbutton
        CancelButton = $nobutton
    }
    $textBox = new-object System.Windows.Forms.label -Property @{
        size = new-object System.Drawing.Size(250,150)
        location = new-object System.Drawing.Size(10,10)
        text = "Are you sure you want to proceed?$displayString"
    }
    $form.Controls.Add($yesbutton)
    $form.Controls.Add($nobutton)
    $form.Controls.Add($textBox)
    $form.TopMost = $true
    
    if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
    {
        return [bool]$true
    }
    else
    {
        return [bool]$false
    }
}

#prompt-confirmation