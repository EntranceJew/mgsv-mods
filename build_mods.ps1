$config = Get-Content ".\.config.json" | ConvertFrom-Json
$dirs = Get-ChildItem -Path "$PSScriptRoot" | Where-Object {$_.PSIsContainer -and ($_.Name.StartsWith("_") -ne $true) -and ($_.Name.StartsWith(".") -ne $true)}

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

    # pull down files
    $game_dir = "$PSScriptRoot\$dir\GameDir"
    if (Test-Path "$game_dir") {
        Set-Location -Path "$game_dir"
        $game_dir_files = Get-ChildItem -Path "$game_dir" -File -Recurse | Resolve-Path -Relative
        foreach($game_dir_file in $game_dir_files){
            
            Write-Host "copying: $game_dir_file"
            Copy-Item "$($config.mgsvtpp_path)$game_dir_file" -Destination "$game_dir\$game_dir_file"
            # todo
        }
        Set-Location -Path "$PSScriptRoot"
    }
    

    # run makebite (wait for exit)
    $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
    $StartInfo.FileName = $config.makebite_path
    $StartInfo.Arguments = "$PSScriptRoot\$dir\"
    $StartInfo.LoadUserProfile = $false
    $StartInfo.UseShellExecute = $false
    $StartInfo.WorkingDirectory = Split-Path -Path "$($config.makebite_path)"
    $proc = [System.Diagnostics.Process]::Start($StartInfo).WaitForExit()

    # blank the xml description to reduce commit noise
    $metadata.ModEntry.Description = ""
    $metadata.Save("$PSScriptRoot\$dir\metadata.xml")

    # remove more potentially pre-existing artifacts
    # then, move the mod to the root
    $zip_name = "$PSScriptRoot\_builds\$file_name.zip"
    if (Test-Path "$zip_name") {
        Remove-Item -Path "$zip_name"
    }
    $mod_dest = "$PSScriptRoot\$file_name.mgsv"
    if (Test-Path "$mod_dest") {
        Remove-Item -Path "$mod_dest"
    }
    Move-Item -Path "$mod_source" -Destination "$mod_dest"

    # convert to zip
    &"$($config.sevenzip_path)" a "_builds\$file_name.zip" "$mod_dest" | Out-Null
    Remove-Item -Path "$mod_dest"
}