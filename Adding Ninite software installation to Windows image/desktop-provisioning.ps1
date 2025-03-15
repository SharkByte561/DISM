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

# Execute Ninite
$execute_ninite = @{
    FilePath    = "$($env:ProgramData)\provisioning\ninite.exe"
    NoNewWindow = $true
    PassThru    = $true
    Wait        = $true
}
Start-Process @execute_ninite

Read-Host