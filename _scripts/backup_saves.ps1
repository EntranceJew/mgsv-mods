$config = Get-Content "$PSScriptRoot\..\.config.json" | ConvertFrom-Json
$time = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$backup_location = "$($config.save_backup_path)$time"
New-Item -ItemType "directory" -Path "$backup_location"
Copy-Item -Path "$($config.steam_userdata_path)311340" -Destination "$backup_location" -Recurse
Copy-Item -Path "$($config.steam_userdata_path)287700" -Destination "$backup_location" -Recurse
Copy-Item -Path "$($config.steam_userdata_path)543900" -Destination "$backup_location" -Recurse