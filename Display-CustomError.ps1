<#
    Author:  Gavin Whitson
    Date:    05/15/2023
    Purpose: create a function that can be called with a error message and a size
             and dynamically create an error pop up with few lines of code

    Change Log:
#>

Invoke-Expression "Add-Type -AssemblyName System.Windows.Forms"
Invoke-Expression "Add-Type -AssemblyName System.Drawing"

function display-CustomError
{
    param(
        [Parameter(Mandatory=$false)]
        [string]$errorText = "Bad input, script cancelled",

        [Parameter(Mandatory=$false)]
        $x = 250,

        [Parameter(Mandatory=$false)]
        $y = 325,

        [Parameter(Mandatory=$false)]
        $title = "Error"
    )
    
    [System.Drawing.Size]$size = (New-Object System.Drawing.Size($x, $y))
    
    [int]$temp1 = (($size.Width) / 2) - 50
    [int]$temp2 = ($size.Height) - 65
    $okLocation = (New-Object System.Drawing.Size($temp1, $temp2))

    $errorOK  = new-object System.windows.forms.button -Property @{
        Text = "OK"
        size = new-object System.Drawing.Size(75, 23)
        Location = $okLocation
    }
    $errorForm = New-Object System.Windows.Forms.Form -Property @{
            text = $title
            size = $size
            startPosition = "CenterScreen"
    }
    $errorOK.Add_Click({$errorForm.Close()})
    $errorForm.Controls.Add($errorOK)

    $errorCode = New-Object System.Windows.Forms.Label -Property @{
        location = New-Object System.Drawing.Size(10,10)
        size = (New-Object System.Drawing.Size(($x - 20), ($y - 20)))
        Text = $errorText
    }
    $errorForm.controls.add($errorCode)

    $errorForm.topMost = $true
    $errorForm.ShowDialog()
}

#display-CustomError "test" 250 250