<#
    Author:  Gavin Whitson
    Date:    08/21/2023
    Purpose: Display a simple box with a newly created account's username and password
             must be passed the strings to be displayed


    Change Log:
#>

function Display-Credentials([string]$givenUN, [string]$givenPW)
{
    $credsform = New-Object System.Windows.Forms.Form -Property @{
        size = New-Object System.Drawing.Size(250, 100)
    }
    $credsform.startPosition = "CenterScreen"
    
    $creds_unlabel = New-Object System.Windows.Forms.Label -Property @{
        location = New-Object System.Drawing.Size(10,10)
        size = New-Object System.Drawing.Size(30,20)
        Text = "UN:"
    }
    $credsform.Controls.Add($creds_unlabel)
    
    $creds_pwlabel = New-Object System.Windows.Forms.Label -Property @{
        location = New-Object System.Drawing.Size(10,30)
        size = New-Object System.Drawing.Size(30,20)
        Text = "PW:"
    }
    $credsform.Controls.Add($creds_pwlabel)
    
    $creds_unentry = New-Object System.Windows.Forms.TextBox -Property @{
        location = New-Object System.Drawing.Size(40,10)
        size = New-Object System.Drawing.Size(100,20)
        backColor = "white"
        readOnly = $true
        text = $givenUN
    }
    $credsform.Controls.Add($creds_unentry)
    
    $creds_pwentry = New-Object System.Windows.Forms.TextBox -Property @{
        location = New-Object System.Drawing.Size(40,30)
        size = New-Object System.Drawing.Size(100,20)
        backColor = "white"
        readOnly = $true
        text = $givenPW
    }
    $credsform.Controls.Add($creds_PWentry)
    $credsform.showDialog()
}