@{
    # Directory containing STIG files
    STIGDirectory = "stigs"
    
    # Reports directory
    ReportDirectory = "reports"
    
    # Logs directory
    LogDirectory = "logs"
    
    # Default severity to scan (Low, Medium, High, All)
    DefaultSeverity = "High"
    
    # Report formats (HTML, CSV, JSON)
    ReportFormats = @("HTML", "CSV")
    
    # Maximum number of parallel scans
    MaxParallelScans = 4
}
