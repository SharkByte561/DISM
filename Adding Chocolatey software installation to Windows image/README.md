# DISM: Adding Chocolatey software installation to Windows image

<b>Documentation:</b>

* [Windows registry information for advanced users](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users)

<b>Objectives:</b>

* Add chocolatey software installation to windows image
  * Adobe Reader
  * 7-Zip
  * Google Chrome
  * Zoom
  * Notepad++
  * Firefox

<b>Downloads:</b>

* [Chocolatey](https://github.com/chocolatey/choco)

<b>Image modification:</b>

```powershell
$ErrorActionPreference = "Stop"

# MODIFY
$image_name = "Windows 11 Pro"
$image_path = "Q:\Downloads\install.wim"
$image_mount_path = "Q:\Downloads\mount"
$image_output_path = "Q:\Downloads\output"
$provisioning_files = "Q:\Downloads\provisioning"

# DO NOT MODIFY
# Create mount directory
[System.IO.DirectoryInfo]$image_mount_path = $image_mount_path
if (!$image_mount_path.Exists) {
    $image_mount_path.Create()
}

# Mount Windows image
$mount_windows_image = @{
    ImagePath = $image_path
    Path      = $image_mount_path
    Name      = $image_name
}
Mount-WindowsImage @mount_windows_image

# Create provisioning folder inside of Windows image
[System.IO.DirectoryInfo]$provisioning_folder = "$($image_mount_path.FullName)\ProgramData\provisioning"

if (!$provisioning_folder.Exists) {
    $provisioning_folder.Create()
}

# Move provisioning files to Windows image
foreach ($item in ([System.IO.DirectoryInfo]$provisioning_files).GetFiles()) {
    if ($item.name -match "chocolatey-(\d+[.]){4}") {
        [void]$item.CopyTo("$($provisioning_folder.FullName)\choco.msi", $true)
        continue
    }
    [void]$item.CopyTo("$($provisioning_folder.FullName)\$($item.Name)", $true)
}

# Load Windows image machine registry file
$load_windows_image_machine_registry = @{
    FilePath     = "reg"
    ArgumentList = "load HKLM\image $($image_mount_path.FullName)\Windows\System32\config\SOFTWARE"
    NoNewWindow  = $true
    Wait         = $true
}
Start-Process @load_windows_image_machine_registry

# Modify registry settings in Windows Image
$settings =
[PSCustomObject]@{ # Execute desktop-provisioning.ps1
    Path  = "image\Microsoft\Windows\CurrentVersion\RunOnce"
    Name  = "execute_provisioning"
    Value = "cmd /c powershell.exe -ExecutionPolicy Bypass -File C:\ProgramData\provisioning\desktop-provisioning.ps1"
} | group Path

foreach ($setting in $settings) {
    $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($setting.Name, $true)
    if ($null -eq $registry) {
        $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($setting.Name, $true)
    }
    $setting.Group | % {
        $registry.SetValue($_.name, $_.value)
    }
    $registry.Dispose()
}

# Unload Windows image machine registry file
$unload_windows_image_machine_registry = @{
    FilePath     = "reg"
    ArgumentList = "unload HKLM\image"
    NoNewWindow  = $true
    Wait         = $true
}
Start-Process @unload_windows_image_machine_registry

# Dismount Windows image
$dismount_windows_image = @{
    Path = $image_mount_path
    Save = $true
}
Dismount-WindowsImage @dismount_windows_image

# Split Windows image
[System.IO.DirectoryInfo]$image_output_path = $image_output_path
if(!$image_output_path.Exists){
    $image_output_path.Create()
}
$split_image = @{
    ImagePath      = $image_path
    SplitImagePath = "$($image_output_path.FullName)\install.swm"
    FileSize       = 1024
    CheckIntegrity = $true
}
Split-WindowsImage @split_image
```

## Related videos

<b>DISM:</b>

* [Preparing Windows USB and Install.wim](https://youtu.be/rdrO4Cqaow4)
* [Reduce Install.wim size by splitting it into multiple files](https://youtu.be/fwQ1VlJvnSw)

<b>Full playlist</b>

* [DISM](https://www.youtube.com/playlist?list=PLVncjTDMNQ4T4z0LjSzfiz6yH841Itbzr)