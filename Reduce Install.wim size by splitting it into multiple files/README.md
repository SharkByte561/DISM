# DISM: Reduce Install.wim size by splitting it into multiple files

<b>Documentation:</b>

[Split-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/split-windowsimage?view=windowsserver2025-ps)

<b>Split-WindowsImage:</b>

```powershell
$split_image = @{
    ImagePath      = "Q:\Downloads\install.wim"
    SplitImagePath = "Q:\Downloads\install.swm"
    LogPath        = "Q:\Downloads\log.txt"
    FileSize       = 1024
    CheckIntegrity = $true
}
Split-WindowsImage @split_image
```

## Related videos

<b>DISM:</b>

* [Preparing Windows USB and Install.wim](https://youtu.be/rdrO4Cqaow4)