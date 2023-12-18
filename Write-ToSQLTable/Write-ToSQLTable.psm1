function Write-ToSQLTable {
    param(
        [Parameter(Mandatory=$true, position=0)]
        [String]$database,
        [Parameter(Mandatory=$true, position=1)]
        [String]$table,
        [Parameter(Mandatory=$true, position=2)]
        [Array]$InsertKeys,
        [Parameter(Mandatory=$true, position=3)]
        [Array]$InsertValues,
        [Parameter(Mandatory=$false, position=4)]
        [String]$server,
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [System.Data.SqlClient.SqlConnection]$conn = $null
    )

    ############# INITIALIZE OBJECTS ######################################
    if ($conn -eq $null){
        $conn = New-Object System.Data.SqlClient.SqlConnection
        $conn.ConnectionString = "Server = $server; Database = $database; Integrated Security = True"
        $conn.open()
    }

    if ($conn.State -ne "Open"){
        $conn.Open()
    }

    $query = New-Object System.Data.SqlClient.SqlCommand
    $query.connection = $conn

    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $ds = New-Object System.Data.DataSet

    $tableTypeString = ""
    $inputTypeString = ""

    $KeysFormatted = ""
    $ValuesFormatted = ""

    ############# VERIFY INPUT VALUE TYPES ################################

    $query.CommandText = "Select * from [$database].[dbo].[$table];"
    $adapter.SelectCommand = $query
    $adapter.fill($ds)

    $ds.tables.Columns.DataType.Name | %{ $tableTypeString += $_ }
    $InsertValues | %{ $inputTypeString += $_.getType().name }

    if ($tableTypeString -eq $inputTypeString){
        # FORMAT INSERT KEYS
        $InsertKeys | % {
            if ($_ -ne $InsertKeys[-1]){
                $KeysFormatted += [string]($_.toString() +  ',')
            } else {
                $KeysFormatted += $_.toString()
            }
        }

        # FORMAT INSERT VALUES
        $InsertValues | % {
            if ($_ -ne $InsertValues[-1]){
                if ($_.getType().name -eq "String"){
                    $ValuesFormatted +=  [string]("`'" + $_.toString() +  "`',")    
                } elseif ($_.getType().name -eq "DateTime"){
                    $ValuesFormatted += [string](Convert-ToSQLDateTime $_ + ",")
                } else {
                    $ValuesFormatted += [string]($_.toString() +  ',')
                }
            } else {
                if ($_.getType().name -eq "String"){
                    $ValuesFormatted +=  [string]("`'" + $_.toString() +  "`'")
                } elseif ($_.getType().name -eq "DateTime"){
                    $ValuesFormatted += [string](Convert-ToSQLDateTime $_)
                } else {
                    $ValuesFormatted += [string]($_.toString())
                }
            }
        }

        # BUILD/EXECUTE QUERY
        write-host "INSERT INTO [$database].[dbo].[$table] ($KeysFormatted) VALUES ($ValuesFormatted);"
        $query.CommandText = "INSERT INTO [$database].[dbo].[$table] ($KeysFormatted) VALUES ($ValuesFormatted);"
        $query.ExecuteNonQuery()
    } else {
        write-error "Bad insert value passed in"
    }

    $conn.close()
}

function Convert-ToSQLDateTime ([datetime]$date){return ("`'" + (get-date $date -format "yyyy-MM-dd HH:mm:ss").ToString() + "`'")}