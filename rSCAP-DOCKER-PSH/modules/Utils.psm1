function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [string]$LogFile = "$PSScriptRoot\..\logs\rscap_$(Get-Date -Format 'yyyy-MM-dd').log"
    )
    
    # Create logs directory if it doesn't exist
    $LogDir = Split-Path -Path $LogFile -Parent
    if (-not (Test-Path -Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }
    
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -FilePath $LogFile -Append
    Write-Host "$Timestamp - $Message"
}

function Get-ConfigValue {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [string]$ConfigFile = "$PSScriptRoot\..\config\rscap-config.psd1"
    )
    
    if (-not (Test-Path -Path $ConfigFile)) {
        Write-Log "Error: Configuration file not found: $ConfigFile"
        return $null
    }
    
    $Config = Import-PowerShellDataFile -Path $ConfigFile
    if ($Config.ContainsKey($Name)) {
        return $Config[$Name]
    }
    
    Write-Log "Warning: Configuration value not found: $Name"
    return $null
}

Export-ModuleMember -Function Write-Log, Get-ConfigValue