# Execute software installation
$packages =
[PSCustomObject]@{
    Name         = "VMware tools"
    Exe          = "setup.exe"
    SilentSwitch = "/s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1"
},
[PSCustomObject]@{
    Name         = "Google Chrome"
    Exe          = "googlechromestandaloneenterprise64.msi"
    SilentSwitch = "/qn /norestart"
},
[PSCustomObject]@{
    Name         = "Zoom"
    Exe          = "ZoomInstallerFull.msi"
    SilentSwitch = "/qn /norestart"
},
[PSCustomObject]@{
    Name         = "Adobe Reader"
    Exe          = "AcroRdrDC.exe"
    SilentSwitch = "/sAll /rs /msi EULA_ACCEPT=YES"
},
[PSCustomObject]@{
    Name         = "Firefox"
    Exe          = "Firefox Setup.msi"
    SilentSwitch = "/qn /norestart"
},
[PSCustomObject]@{
    Name         = "7-Zip"
    Exe          = "7z.exe"
    SilentSwitch = "/S"
},
[PSCustomObject]@{
    Name         = "Notepad++"
    Exe          = "npp.exe"
    SilentSwitch = "/S"
}

foreach ($package in $packages) {
    Write-Host "Executing $($package.Name) installation."
    if ($package.exe -Like "*.msi") {
        $execute = @{
            FilePath     = "msiexec"
            ArgumentList = "/i $($env:ProgramData)\provisioning\package.exe) $($package.SilentSwitch)"
            NoNewWindow  = $true
            PassThru     = $true
            Wait         = $true
        }
    }
    else {
        $execute = @{
            FilePath    = "$($env:ProgramData)\provisioning\$($package.exe)"
            NoNewWindow = $true
            PassThru    = $true
            Wait        = $true
        }
        if (![string]::IsNullOrEmpty($package.SilentSwitch)) {
            $execute.ArgumentList = $package.SilentSwitch
        }
    }
    $result = Start-Process @execute
    Write-Host "    ExitCode: $($result.ExitCode)"
}

Read-Host