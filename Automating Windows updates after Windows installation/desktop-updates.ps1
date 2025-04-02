# Install VMware tools
if (([System.IO.FileInfo]"$($env:ProgramData)\provisioning\setup.exe").Exists -and $null -eq (get-service VMTools -ea SilentlyContinue)) {
    $install_vmware_tools = @{
        FilePath     = "$($env:ProgramData)\provisioning\setup.exe"
        ArgumentList = "/s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1"
        NoNewWindow  = $true
        PassThru     = $true
        Wait         = $true
    }

    Start-Process @install_vmware_tools
}

# Wait for network
$ProgressPreference_bk = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'
do {
    $ping = Test-NetConnection '8.8.8.8' -InformationLevel Quiet
    if (!$ping) {
        cls
        'Wainting for network connection' | Out-Host
        sleep -s 5
    }
} while (!$ping)
$ProgressPreference = $ProgressPreference_bk

# Setup Windows Update
$nuget = Get-PackageProvider 'NuGet' -ListAvailable -ErrorAction SilentlyContinue

if ($null -eq $nuget) {
    Install-PackageProvider -Name NuGet -Confirm:$false -Force
}

$module = Get-Module 'PSWindowsUpdate' -ListAvailable

if ($null -eq $module) {
    Install-Module PSWindowsUpdate -Confirm:$false -Force
}
# Check for Windows Updates and install
$updates = Get-WindowsUpdate

if ($null -ne $updates) {
    Install-WindowsUpdate -AcceptAll -Install -IgnoreReboot | select KB, Result, Title, Size
}

$status = Get-WURebootStatus -Silent

if ($status) {
    $setup_runonce = @{
        Path  = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
        Name  = "execute_provisioning"
        Value = "cmd /c powershell.exe -ExecutionPolicy Bypass -File $($env:ProgramData)\provisioning\provisioning.ps1"
    }
    New-ItemProperty @setup_runonce | Out-Null
    Restart-Computer
}
else {
    Write-Host "All Done!" -ForegroundColor Green
    Read-Host
}