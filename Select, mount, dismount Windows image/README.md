# DISM: Select, mount, dismount Windows image

<b>Documentation:</b>

* [Get-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/get-windowsimage?view=windowsserver2025-ps)
* [Mount-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/mount-windowsimage?view=windowsserver2025-ps)
* [Dismount-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/dismount-windowsimage?view=windowsserver2025-ps)
* [Split-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/split-windowsimage?view=windowsserver2025-ps)

<b>Get-WindowsImage:</b>

```powershell
$image = @{
    ImagePath = "Q:\Downloads\install.wim"
}
Get-WindowsImage @image
```

<b>Mount-WindowsImage:</b>

```powershell
$mount_windows_image = @{
    ImagePath = "Q:\Downloads\install.wim"
    Index     = 6 # Windows 11 Pro
    Path      = "Q:\Downloads\windows"
}
Mount-WindowsImage @mount_windows_image
```

<b>Dismount-WindowsImage:</b>

```powershell
$dismount_windows_image = @{
    Path = "Q:\Downloads\windows"
    Save = $true
}
Dismount-WindowsImage @dismount_windows_image
```

<b>Split-WindowsImage:</b>

```powershell
$split_image = @{
    ImagePath      = "Q:\Downloads\install.wim"
    SplitImagePath = "Q:\Downloads\install.swm"
    FileSize       = 1024
    CheckIntegrity = $true
}
Split-WindowsImage @split_image
```

## Related videos

<b>DISM:</b>

* [Preparing Windows USB and Install.wim](https://youtu.be/rdrO4Cqaow4)
* [Reduce Install.wim size by splitting it into multiple files]()
