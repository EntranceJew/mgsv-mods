$config = Get-Content ".\.config.json" | ConvertFrom-Json
$dirs = Get-ChildItem -Path "$PSScriptRoot" | Where-Object {$_.PSIsContainer -and ($_.Name.StartsWith("_") -ne $true)}

foreach($dir in $dirs){
    # read metadata
    [xml]$metadata = Get-Content -Path "$PSScriptRoot\$dir\metadata.xml"
    $file_name = "$($metadata.ModEntry.Name -replace " ", "_")_v$($metadata.ModEntry.Version)"
    Write-Host "Building: $file_name"
    
    # remove old artifacts (if the process got choked up for some reason)
    $mod_source = "$PSScriptRoot\$dir\mod.mgsv"
    if (Test-Path "$mod_source") {
        Remove-Item -Path "$mod_source"
    }

    # run makebite (wait for exit)
    $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
    $StartInfo.FileName = $config.makebite_path
    $StartInfo.Arguments = "$PSScriptRoot\$dir\"
    $StartInfo.LoadUserProfile = $false
    $StartInfo.UseShellExecute = $false
    $StartInfo.WorkingDirectory = Split-Path -Path "$($config.makebite_path)"
    $proc = [System.Diagnostics.Process]::Start($StartInfo).WaitForExit()

    # move the mod to the root
    $mod_dest = "$PSScriptRoot\$file_name.mgsv"
    if (Test-Path "$mod_dest") {
        Remove-Item -Path "$mod_dest"
    }
    Move-Item -Path "$mod_source" -Destination "$mod_dest"

    # convert to zip
    &"$($config.sevenzip_path)" a "$file_name.zip" "$mod_dest" | Out-Null
    Remove-Item -Path "$mod_dest"
}