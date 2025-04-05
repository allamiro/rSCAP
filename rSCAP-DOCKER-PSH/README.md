# rSCAP Docker PowerShell Scanner

A PowerShell implementation of the rSCAP tool for scanning Docker containers against Security Technical Implementation Guides (STIGs).

## Overview

This tool allows you to check Docker containers for compliance with security benchmarks defined in STIG files. It can scan one or multiple containers, generate detailed reports, and identify security issues in your containerized environments.

## Prerequisites

- Windows PowerShell 5.1 or PowerShell Core 6.0+
- Docker installed and running
- Administrative privileges (for some STIG checks)

## Installation

1. Clone this repository or download the files
2. Ensure you have STIG XML files in the `stigs` directory
3. Make sure Docker is running

## Usage

The scanner can be run with different parameters to specify which containers to scan and how to generate reports.

### Basic Usage

```powershell
# Scan a specific container
.\rSCAP.ps1 -ContainerID <container_id>

# Scan all containers using a specific image
.\rSCAP.ps1 -ImageName <image_name>

# Scan all running containers
.\rSCAP.ps1 -ScanAllContainers
```

### Advanced Options

```powershell
# Specify severity level to check (Low, Medium, High, All)
.\rSCAP.ps1 -ContainerID <container_id> -Severity High

# Specify report format (HTML, CSV, JSON)
.\rSCAP.ps1 -ContainerID <container_id> -ReportFormat HTML

# Specify a custom path for STIG files
.\rSCAP.ps1 -ContainerID <container_id> -STIGPath C:\path\to\stigs
```

## Configuration

You can modify the `config/rscap-config.psd1` file to change default settings:

- `STIGDirectory`: Directory containing STIG files
- `ReportDirectory`: Directory where reports will be saved
- `LogDirectory`: Directory for log files
- `DefaultSeverity`: Default severity level to check
- `ReportFormats`: Default report formats to generate
- `MaxParallelScans`: Maximum number of parallel scans

## Project Structure

- `rSCAP.ps1`: Main script file
- `modules/`: PowerShell modules
  - `DockerScannner.psm1`: Functions for interacting with Docker
  - `STIGParser.psm1`: Functions for parsing STIG files
  - `Utils.psm1`: Utility functions
- `config/`: Configuration files
- `stigs/`: Directory to store STIG XML files
- `reports/`: Generated reports
- `logs/`: Log files

## Extending the Tool

You can extend the tool by:

1. Adding new STIG checks in the `Test-DockerSTIG` function in `DockerScannner.psm1`
2. Implementing new report formats in the main script
3. Adding support for additional container runtimes beyond Docker

## Troubleshooting

If you encounter issues:

1. Check that Docker is running and your user has permissions to access it
2. Ensure STIG XML files are properly formatted
3. Review logs in the `logs` directory for detailed error messages
4. Run PowerShell with administrative privileges if needed

## License

See the LICENSE file for details.