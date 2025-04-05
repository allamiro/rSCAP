#
# rSCAP - Docker Container STIG Compliance Scanner
# PowerShell Implementation
#

param(
    [Parameter()]
    [string]$ContainerID,
    
    [Parameter()]
    [string]$ImageName,
    
    [Parameter()]
    [string]$STIGPath,
    
    [Parameter()]
    [ValidateSet("Low", "Medium", "High", "All")]
    [string]$Severity,
    
    [Parameter()]
    [ValidateSet("HTML", "CSV", "JSON")]
    [string]$ReportFormat = "HTML",
    
    [Parameter()]
    [switch]$ScanAllContainers
)

# Import modules
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$PSScriptRoot\modules\Utils.psm1" -Force
Import-Module "$PSScriptRoot\modules\STIGParser.psm1" -Force
Import-Module "$PSScriptRoot\modules\DockerScannner.psm1" -Force

# Load configuration
$ConfigPath = "$PSScriptRoot\config\rscap-config.psd1"
if (Test-Path -Path $ConfigPath) {
    $Config = Import-PowerShellDataFile -Path $ConfigPath
} else {
    Write-Host "Error: Configuration file not found: $ConfigPath"
    exit 1
}

# Create necessary directories
$LogDir = Join-Path -Path $PSScriptRoot -ChildPath $Config.LogDirectory
$ReportDir = Join-Path -Path $PSScriptRoot -ChildPath $Config.ReportDirectory
$STIGDir = Join-Path -Path $PSScriptRoot -ChildPath $Config.STIGDirectory

if (-not (Test-Path -Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path -Path $ReportDir)) {
    New-Item -Path $ReportDir -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path -Path $STIGDir)) {
    New-Item -Path $STIGDir -ItemType Directory -Force | Out-Null
}

# Set severity if not specified
if (-not $Severity) {
    $Severity = $Config.DefaultSeverity
}

Write-Log "Starting rSCAP Docker STIG compliance scanner"
Write-Log "Configuration loaded from: $ConfigPath"

# Get Docker containers to scan
$ContainersToScan = @()

if ($ContainerID) {
    Write-Log "Scanning specific container: $ContainerID"
    $Container = Get-DockerContainerInfo -ContainerID $ContainerID
    if ($Container) {
        $ContainersToScan += @{
            ID = $ContainerID
            Info = $Container
        }
    } else {
        Write-Log "Error: Container not found with ID: $ContainerID"
        exit 1
    }
} elseif ($ImageName) {
    Write-Log "Scanning containers with image: $ImageName"
    $Containers = Get-DockerContainers -Running
    $Filtered = $Containers | Where-Object { $_.Image -like "*$ImageName*" }
    
    foreach ($Container in $Filtered) {
        $Info = Get-DockerContainerInfo -ContainerID $Container.ID
        $ContainersToScan += @{
            ID = $Container.ID
            Info = $Info
        }
    }
    
    if ($ContainersToScan.Count -eq 0) {
        Write-Log "No running containers found with image: $ImageName"
        exit 1
    }
} elseif ($ScanAllContainers) {
    Write-Log "Scanning all running containers"
    $Containers = Get-DockerContainers -Running
    
    foreach ($Container in $Containers) {
        $Info = Get-DockerContainerInfo -ContainerID $Container.ID
        $ContainersToScan += @{
            ID = $Container.ID
            Info = $Info
        }
    }
    
    if ($ContainersToScan.Count -eq 0) {
        Write-Log "No running containers found"
        exit 1
    }
} else {
    Write-Log "Error: No container specified. Use -ContainerID, -ImageName, or -ScanAllContainers"
    Write-Host "Usage: ./rSCAP.ps1 -ContainerID <id> | -ImageName <name> | -ScanAllContainers [-Severity <Low|Medium|High|All>] [-ReportFormat <HTML|CSV|JSON>]"
    exit 1
}

Write-Log "Found $($ContainersToScan.Count) containers to scan"

# Find STIG files
$STIGFiles = @()
if ($STIGPath) {
    if (Test-Path -Path $STIGPath) {
        $STIGFiles += Get-ChildItem -Path $STIGPath -Filter "*.xml" -Recurse
    } else {
        Write-Log "Error: STIG path not found: $STIGPath"
        exit 1
    }
} else {
    if (Test-Path -Path $STIGDir) {
        $STIGFiles += Get-ChildItem -Path $STIGDir -Filter "*.xml" -Recurse
    } else {
        Write-Log "Error: Default STIG directory not found: $STIGDir"
        exit 1
    }
}

if ($STIGFiles.Count -eq 0) {
    Write-Log "Error: No STIG files found"
    exit 1
}

Write-Log "Found $($STIGFiles.Count) STIG files"

# Process each container
$AllResults = @()

foreach ($Container in $ContainersToScan) {
    Write-Log "Processing container: $($Container.ID)"
    
    # Process each STIG file
    foreach ($STIGFile in $STIGFiles) {
        Write-Log "Processing STIG file: $($STIGFile.FullName)"
        
        # Parse STIG items
        $STIGItems = Get-STIGItems -STIGFile $STIGFile.FullName
        
        if ($null -eq $STIGItems -or $STIGItems.Count -eq 0) {
            Write-Log "No STIG items found in file: $($STIGFile.FullName)"
            continue
        }
        
        # Filter by severity if specified
        if ($Severity -ne "All") {
            $STIGItems = $STIGItems | Where-Object { $_.Severity -eq $Severity }
        }
        
        Write-Log "Found $($STIGItems.Count) applicable STIG items"
        
        # Test compliance
        $Results = Test-DockerSTIG -ContainerID $Container.ID -STIGItems $STIGItems
        $AllResults += $Results
    }
}

# Generate report
$ReportTimestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ReportFileName = "rSCAP-Report-$ReportTimestamp"

switch ($ReportFormat) {
    "HTML" {
        $HTMLReportPath = Join-Path -Path $ReportDir -ChildPath "$ReportFileName.html"
        
        $HTMLHeader = @"
<!DOCTYPE html>
<html>
<head>
    <title>rSCAP Docker STIG Compliance Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2 { color: #333366; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        .Pass { background-color: #dff0d8; }
        .Fail { background-color: #f2dede; }
        .NotApplicable { background-color: #fcf8e3; }
        .NotReviewed { background-color: #d9edf7; }
    </style>
</head>
<body>
    <h1>rSCAP Docker STIG Compliance Report</h1>
    <p>Generated: $(Get-Date)</p>
"@
        
        $HTMLFooter = @"
</body>
</html>
"@
        
        $HTMLBody = ""
        
        foreach ($Container in $ContainersToScan) {
            $ContainerResults = $AllResults | Where-Object { $_.ContainerID -eq $Container.ID }
            
            $HTMLBody += @"
    <h2>Container: $($Container.ID)</h2>
    <p>Image: $($Container.Info.Config.Image)</p>
    <table>
        <tr>
            <th>STIG ID</th>
            <th>Title</th>
            <th>Severity</th>
            <th>Status</th>
            <th>Details</th>
        </tr>
"@
            
            foreach ($Result in $ContainerResults) {
                $HTMLBody += @"
        <tr class="$($Result.Status)">
            <td>$($Result.STIGItem.ID)</td>
            <td>$($Result.STIGItem.Title)</td>
            <td>$($Result.STIGItem.Severity)</td>
            <td>$($Result.Status)</td>
            <td>$($Result.Details)</td>
        </tr>
"@
            }
            
            $HTMLBody += @"
    </table>
"@
        }
        
        $HTMLReport = $HTMLHeader + $HTMLBody + $HTMLFooter
        $HTMLReport | Out-File -FilePath $HTMLReportPath -Encoding utf8
        
        Write-Log "HTML report generated: $HTMLReportPath"
    }
    
    "CSV" {
        $CSVReportPath = Join-Path -Path $ReportDir -ChildPath "$ReportFileName.csv"
        
        $CSVData = $AllResults | Select-Object @{Name='ContainerID';Expression={$_.ContainerID}}, 
                                               @{Name='STIGID';Expression={$_.STIGItem.ID}},
                                               @{Name='Title';Expression={$_.STIGItem.Title}},
                                               @{Name='Severity';Expression={$_.STIGItem.Severity}},
                                               @{Name='Status';Expression={$_.Status}},
                                               @{Name='Details';Expression={$_.Details}},
                                               @{Name='Timestamp';Expression={$_.Timestamp}}
        
        $CSVData | Export-Csv -Path $CSVReportPath -NoTypeInformation
        
        Write-Log "CSV report generated: $CSVReportPath"
    }
    
    "JSON" {
        $JSONReportPath = Join-Path -Path $ReportDir -ChildPath "$ReportFileName.json"
        
        $AllResults | ConvertTo-Json -Depth 4 | Out-File -FilePath $JSONReportPath -Encoding utf8
        
        Write-Log "JSON report generated: $JSONReportPath"
    }
}

Write-Log "rSCAP Docker STIG compliance scan complete"
Write-Log "Scanned $($ContainersToScan.Count) containers with $($STIGFiles.Count) STIG files"
Write-Log "Total findings: $($AllResults.Count)"

# Summary
$PassCount = ($AllResults | Where-Object { $_.Status -eq "Pass" }).Count
$FailCount = ($AllResults | Where-Object { $_.Status -eq "Fail" }).Count
$NACount = ($AllResults | Where-Object { $_.Status -eq "NotApplicable" }).Count
$NRCount = ($AllResults | Where-Object { $_.Status -eq "NotReviewed" }).Count

Write-Host ""
Write-Host "Scan Summary:"
Write-Host "=============="
Write-Host "Pass: $PassCount"
Write-Host "Fail: $FailCount"
Write-Host "Not Applicable: $NACount"
Write-Host "Not Reviewed: $NRCount"
Write-Host "Total: $($AllResults.Count)"
Write-Host ""
Write-Host "Report saved to: $ReportDir"