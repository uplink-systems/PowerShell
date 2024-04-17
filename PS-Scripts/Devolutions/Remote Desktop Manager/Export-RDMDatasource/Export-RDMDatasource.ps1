# Configuring environment requirements: requires, ErrorActionPreference...
#Requires -PSEdition Core
$ErrorActionPreference = 'SilentlyContinue'

# Checking if RDM PS module is installed; install if no, update if yes...
If(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module -Name "Devolutions.PowerShell" -Scope CurrentUser -Force
} Else {
    Update-Module -Name "Devolutions.Powershell" -Scope CurrentUser -Force
}

# Powershell module version info
$DevolutionsPsModuleVersion = (Get-InstalledModule -Name "Devolutions.Powershell").Version
Write-Host -Object "Using module version: $DevolutionsPsModuleVersion"

# Adapting data source, password and export path
$DataSourceName = Read-Host -Prompt "Enter data source name to export to file"
$ExportPwd = Read-Host -Prompt "Enter password to secure the export file" -AsSecureString
$ExportPath = "$ENV:temp\RDM-Backup-$DataSourceName.rdm"

# Exporting sessions...
Write-Host -Object "Exporting Sessions from Datasource $DataSourceName..."
Set-RDMCurrentDataSource -DataSource $(Get-RDMDataSource -Name $DataSourceName)
Export-RDMSession -Path $ExportPath -Sessions $(Get-RDMSession) -XML -IncludeCredentials -IncludeAttachements -IncludeDocumentation -Password $ExportPwd