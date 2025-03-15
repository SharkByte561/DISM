# Install VMware tools
$install_vmware_tools = @{
    FilePath     = "$($env:ProgramData)\provisioning\setup.exe"
    ArgumentList = "/s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1"
    NoNewWindow  = $true
    PassThru     = $true
    Wait         = $true
}

Start-Process @install_vmware_tools

# Wait for network
$ProgressPreference_bk = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'
do{
    $ping = Test-NetConnection '8.8.8.8' -InformationLevel Quiet
    if(!$ping){
        cls
        'Wainting for network connection' | Out-Host
        sleep -s 5
    }
} while(!$ping)
$ProgressPreference = $ProgressPreference_bk

# Install chocolatey
$install_chocolatey = @{
    FilePath     = "$($env:SystemRoot)\system32\msiexec.exe"
    ArgumentList = "/i $($env:ProgramData)\provisioning\choco.msi /qn /norestart"
    NoNewWindow  = $true
    PassThru     = $true
    Wait         = $true
}
Start-Process @install_chocolatey | out-null

# Install chocolatey packages
$packages = 
"adobereader",
"7zip.install",
"googlechrome",
"zoom",
"notepadplusplus",
"firefox" -join " "

$install_software_packages = @{
    FilePath     = "$($env:ProgramData)\chocolatey\choco.exe"
    ArgumentList = "install {0} -y --no-progress --ignore-checksums" -f $packages
    NoNewWindow  = $true
    PassThru     = $true
    Wait         = $true
}

Start-Process @install_software_packages

Read-Host