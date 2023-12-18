<#
    Author:  Gavin Whitson
    Date:    05/15/2023
    Purpose: prompt user for input

    Change Log:
#>


function prompt-userInput
{    
    [cmdletBinding()]
    param(
        [parameter(Mandatory=$false)]
        $inputPrompt = "Input:"
    )

    $inputForm = new-object System.Windows.Forms.Form -Property @{
        text = "Input"
        size = New-Object System.Drawing.Size(250,150)
        startPosition = "CenterScreen"
    }


    $submitButton = new-object System.windows.forms.button -Property @{
        Text = "Submit"
        size = new-object System.Drawing.Size(75, 23)
        Location = New-Object System.Drawing.Size(20,85)
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $submitButton.Add_Click({$inputForm.Close()})

    $cancelButton = new-object System.windows.forms.button -Property @{
        Text = "Cancel"
        size = new-object System.Drawing.Size(75, 23)
        Location = New-Object System.Drawing.Size(105,85)
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $cancelButton.Add_Click({$inputForm.Close()})
    
    $inputForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
        {
            $inputForm.close()
        }})

    $inputForm.Controls.Add($submitButton)
    $inputForm.Controls.Add($cancelButton)


    $textBoxLabel = new-object System.windows.forms.label -Property @{
        text = $inputPrompt
        size = new-object System.Drawing.Size(200, 23)
        Location = New-Object System.Drawing.Size(15,20)
    }
    $inputForm.Controls.Add($textBoxLabel)


    $textBox = new-object System.windows.forms.textBox -Property @{
        size = new-object System.Drawing.Size(200, 23)
        Location = New-Object System.Drawing.Size(15,45)
    }
    $inputForm.Controls.Add($textBox)

    $textBox.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
        {$inputForm.Close()}})

    $inputForm.add_Shown({$textBox.Focus()})

    $inputForm.Topmost = $True
    if ($formResult -eq $null)
    {
        $formResult = $inputForm.ShowDialog()
    }

    return $textbox.Text
}
