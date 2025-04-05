Import-Module "$PSScriptRoot\Utils.psm1"

function Get-DockerContainers {
    [CmdletBinding()]
    param(
        [switch]$Running
    )
    
    try {
        Write-Log "Retrieving Docker containers..."
        $Filter = if ($Running) { "--filter status=running" } else { "" }
        $Command = "docker ps $Filter --format '{{.ID}},{{.Image}},{{.Names}},{{.Status}}'"
        
        $ContainersOutput = Invoke-Expression -Command $Command
        $Containers = @()
        
        foreach ($Line in $ContainersOutput) {
            if (-not [string]::IsNullOrWhiteSpace($Line)) {
                $Parts = $Line.Replace("'", "").Split(",")
                $Container = [PSCustomObject]@{
                    ID = $Parts[0]
                    Image = $Parts[1]
                    Name = $Parts[2]
                    Status = $Parts[3]
                }
                $Containers += $Container
            }
        }
        
        Write-Log "Found $($Containers.Count) containers"
        return $Containers
    }
    catch {
        Write-Log "Error retrieving Docker containers: $_"
        return @()
    }
}

function Get-DockerContainerInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ContainerID
    )
    
    try {
        Write-Log "Getting information for container: $ContainerID"
        
        # Get container details
        $InfoCommand = "docker inspect $ContainerID"
        $InfoJson = Invoke-Expression -Command $InfoCommand
        $ContainerInfo = $InfoJson | ConvertFrom-Json
        
        return $ContainerInfo
    }
    catch {
        Write-Log "Error getting container info: $_"
        return $null
    }
}

function Invoke-DockerCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ContainerID,
        
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    
    try {
        Write-Log "Executing command in container $ContainerID: $Command"
        $ExecCommand = "docker exec $ContainerID $Command"
        $Output = Invoke-Expression -Command $ExecCommand
        
        return $Output
    }
    catch {
        Write-Log "Error executing Docker command: $_"
        return $null
    }
}

function Test-DockerSTIG {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ContainerID,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$STIGItems
    )
    
    Write-Log "Starting STIG compliance check for container: $ContainerID"
    $Results = @()
    
    foreach ($Item in $STIGItems) {
        $Result = [PSCustomObject]@{
            STIGItem = $Item
            ContainerID = $ContainerID
            Status = "NotReviewed"
            Details = "Not implemented"
            Timestamp = Get-Date
        }
        
        # Add actual checking logic here based on STIG requirements
        # For example, checking file permissions, running processes, etc.
        
        $Results += $Result
    }
    
    Write-Log "Completed STIG compliance check for container: $ContainerID"
    return $Results
}

Export-ModuleMember -Function Get-DockerContainers, Get-DockerContainerInfo, Invoke-DockerCommand, Test-DockerSTIG