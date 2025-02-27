# DISM: Removing OneDrive from Windows Image

<b>Objectives:</b>

* Remove OneDrive from Windows Image
    * Mount Windows image
    * Mount Default users registry
    * Remove OneDrive installation registry
    * Dismount registry
    * Dismount Windows image
    * Split Install.wim and test changes

<b>Mount-WindowsImage:</b>

```powershell
$mount_windows_image = @{
    ImagePath = "Q:\Downloads\install.wim"
    Index     = 6 # Windows 11 Pro
    Path      = "Q:\Downloads\windows"
}

Mount-WindowsImage @mount_windows_image
```

<b>Load default user registry:</b>

```batch
REG load HKLM\image Q:\Downloads\windows\Users\Default\NTUSER.DAT
```

<b>Remove OneDrive installation registry:</b>

```powershell
$remove_onedrive = @{
    Path = "HKLM:\image\Software\Microsoft\Windows\CurrentVersion\Run"
    Name = "OneDriveSetup"
}
Remove-ItemProperty @remove_onedrive
```

<b>Unload default user registry:</b>

```batch
REG unload HKLM\image
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
* [Reduce Install.wim size by splitting it into multiple files](https://youtu.be/fwQ1VlJvnSw)

<b>Full playlist</b>

* [DISM](https://www.youtube.com/playlist?list=PLVncjTDMNQ4T4z0LjSzfiz6yH841Itbzr)