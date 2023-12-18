<#

    .SYNOPSIS
    Author:  Gavin Whitson
    Date:    11/28/2023

    Purpose: Monitor an account for a specified amount of time and check in a 
             specified interval whether the account has been locked out.
    
    .DESCRIPTION
    The 'Montitor-Account' function takes in 4 string parameters, the length of time the 
	script runs, the amount of time to wait between checks, the name of the account to check,
	and an array of email addresses to alert when the given account is locked. The parameters specifying
	the times the functions acts with are checked with regexes verifying that they consist of some digit, and 
	a letter (either m for minutes, h for hours, or s for seconds). The array for recipients can contain one or
	more email addresses. For multiple email addresses, to declare an array of addresses would be 
	@("address1@test.com", "address2@test.com", "address3@test.com"). The name parameter must be a valid account
	findable to the get-aduser command. This is built for personal use so I did not built any checks. To setup,
	edit the 'SMTP_SERVER' and 'OUTBOUND_EMAIL_ADDR' variables to be valid according to your domain.
	
    .PARAMETER Time
    String parameter bound to a specific pattern. Input string MUST consist of any
    number of digits followed by a single character (s,m,h) specifying the unit of time
    being used, either seconds, minutes, or hours.

	.PARAMETER Check_Interval
    String parameter bound to a specific pattern. Input string MUST consist of any
    number of digits followed by a single character (s,m,h) specifying the unit of time
    being used, either seconds, minutes, or hours.
	 
	.PARAMETER Recipients
    String parameter that is able to intake arrays of strings. Input strings should be 
    valid email addresses that are reachable by the SMTP server specified.
	 
	.PARAMETER Name
    String parameter representitive of an Active Directory object's 'name' field. If an AD object
    is piped into the function, the parameter attribute 'ValueFromPipelineByPropertyName' selects out the
    name field. Otherwise can recieve a string input along side other command line arguments.

    .EXAMPLE
    Each of the following calls will monitor account 'it-test123' for 15 minutes
    checking every 2.5 minutes if the account is locked out and alerts 'gwhitson@test.com'. 

    --Piping AD Object into function--
    (get-aduser 'it-test123') | monitor-account '15m' '150s' 'gwhitson@test.com'

    --Naming Parameters--
    monitor-account -time 15m -check_interval 150s -recipients gwhitson@test.com -name it-test123

    --Using Parameters bound by CLI Agument Position--
    monitor-account 15m 150s gwhitson@test.com it-test123

    --Alerting Multiple Inboxes--
    monitor-account -time 15m -check_interval 150s -recipients @('gwhitson@test.com', 'gavin.whitson@test.com') -name it-test123

	.NOTES
	Change Log:
		
#>

$SMTP_SERVER = "smtpserver.test.com"                  # Accessible SMTP Server
$OUTBOUND_EMAIL_ADDR = "Account.Monitoring@test.com"  # Account emails will be sent as

function Monitor-Account{
    param(
        [Parameter(Mandatory, position=0)]
        [ValidatePattern("[0-9]*[s,m,h]{1}")]
        [string]$time = "300s",
        [Parameter(Mandatory, position=1)]
        [ValidatePattern("[0-9]*[s,m,h]{1}")]
        [string]$check_interval = "30",
        [Parameter(Mandatory = $false, position=2)]
        [string[]]$recipients = @(""),
        [Parameter(Mandatory = $true, position=3, ValueFromPipelineByPropertyName)]
        [PSDefaultValue(Help='Current account being monitored, null if not specified', value="")]
        [string]$name
    )
    
######################  EMAIL DETAILS   #######################
    $body = ("Account: " + $name + "`nhas been locked out. Investigate this account at earliest convenience.")
    $subject = ("Account Monitoring: " + $name)

###################### TIME CONVERSION  #####################
    $convertedTime = [int]$time.Substring(0, ($time.Length - 1))
    if ($time[-1] -eq "s"){
        $convertedTime = $convertedTime * 1
    } elseif ($time[-1] -eq "m"){
        $convertedTime = $convertedTime * 60
    } elseif ($time[-1] -eq "h"){
        $convertedTime = $convertedTime * 3600
    } else {
        throw "fatal error in time conversion processing"
    }


###################### CHECK CONVERSION #####################
    $convertedInterval = [int]$check_interval.Substring(0, ($check_interval.Length - 1))
    if ($check_interval[-1] -eq "s"){
        $convertedInterval = $convertedInterval * 1
    } elseif ($check_interval[-1] -eq "m"){
        $convertedInterval = $convertedInterval * 60
    } elseif ($check_interval[-1] -eq "h"){
        $convertedInterval = $convertedInterval * 3600
    } else {
        throw "fatal error in check interval processing"
    }
    

###################### LOOP PROCESSING  ######################
    $elapsedTime = 0
    while ($elapsedTime -le $convertedTime){
        if ($elapsedTime % $convertedInterval -eq 0 -and $elapsedTime -ne 0){
            write-verbose "check-now"
            if ($name -eq ""){
                write-verbose "cn is null"
            } else {
                $isAccountLocked = (get-aduser -Identity $name -Properties LockedOut).LockedOut
                if ($isAccountLocked){

                    send-mailmessage -from $OUTBOUND_EMAIL_ADDR -to $recipients -Body $body -SmtpServer $SMTP_SERVER -Subject $subject
                }
            }
        } else {
            write-verbose $elapsedTime
        }
        
        sleep -Seconds 1
    
        $elapsedTime += 1
    }
}