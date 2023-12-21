#
# Module manifest for module 'Write-ToSQLTable'
#
# Generated by: gwhitson
#
# Generated on: 12/18/2023
#

@{
    RootModule = 'PSSQLTools.psm1'
    ModuleVersion = '0.0.1.2'
    GUID = '50e7a05e-8366-4396-8cc5-f0c1f735deab'
    Author = 'Gavin Whitson'
    CompanyName = 'Gavin Whitson'
    Copyright = '(c) 2023 gwhitson. All rights reserved.'
    Description = 'Collection of functions for streamlining SQL Database interactions'
    FunctionsToExport = @("Write-ToSQLTable", "Read-FromSQLTable", "New-SQLTable", "Convert-ToSQLDateTime", "Convert-ToSQLString", "Convert-ToSQLColumnName")
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
        }
    }
}