<#
.SYNOPSIS
    Enables .NET Framework 3.5 (includes .NET 2.0 and 3.0) on Windows 10/11/Server.

.DESCRIPTION
    This script uses DISM to enable the .NET Framework 3.5 feature.
    Designed for NinjaOne - can be run as a Script, in a Policy, or chained in an Application Installation.

    Exit Codes:
        0  = Success
        1  = Already enabled
        2  = Failed to enable
       99 = Error (requires elevation or other issue)

.NOTES
    Version: 1.1
    Requires: Administrator rights
#>

#Requires -RunAsAdministrator

param(
    [switch]$Quiet = $false   # Set to $true in NinjaOne parameters for silent run
)

try {
    Write-Host "=== Enabling .NET Framework 3.5 ===" -ForegroundColor Cyan

    # Check current state
    $feature = Get-WindowsOptionalFeature -Online -FeatureName "NetFx3" -ErrorAction Stop

    if ($feature.State -eq "Enabled") {
        Write-Host ".NET Framework 3.5 is already enabled." -ForegroundColor Green
        if (-not $Quiet) { Read-Host "Press Enter to exit" }
        exit 1
    }

    # Enable the feature
    Write-Host "Enabling NetFx3 feature via DISM..." -ForegroundColor Yellow
    $result = Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart -ErrorAction Stop

    if ($result.Success -eq $true) {
        Write-Host ".NET Framework 3.5 enabled successfully!" -ForegroundColor Green
        exit 0
    }
    else {
        Write-Host "Failed to enable .NET Framework 3.5." -ForegroundColor Red
        exit 2
    }
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Common causes: Not running as Administrator, or no internet/Windows installation source available." -ForegroundColor Yellow
    exit 99
}
