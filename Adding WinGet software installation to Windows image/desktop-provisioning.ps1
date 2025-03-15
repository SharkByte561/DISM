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

# Wait for winget to be installed
do {
    try {
        Start-Process "winget" -ea Stop
        break
    }
    catch [System.InvalidOperationException] {
        'Wainting for winget' | Out-Host
        sleep -s 30
    }
} while(1)

# Scope user or machine
$scope = 'machine'

$packages = 
[PSCustomObject]@{
    Name  = "Adobe.Acrobat.Reader.64-bit"
    Scope = $scope
},
[PSCustomObject]@{
    Name  = "Google.Chrome"
    Scope = $scope
},
[PSCustomObject]@{
    Name  = "7zip.7zip"
    Scope = $scope
},
[PSCustomObject]@{
    Name  = "Mozilla.Firefox"
    Scope = $scope
},
[PSCustomObject]@{
    Name  = "Zoom.Zoom"
    Scope = $scope
},
[PSCustomObject]@{
    Name  = "Notepad++.Notepad++"
    Scope = $scope
}

foreach($package in $packages){
    if($package.Scope){
        winget install -e --id $package.Name --scope 'machine' --silent --accept-source-agreements
    }
    else{
        winget install -e --id $package.Name --silent --accept-source-agreements
    }
}

Read-Host