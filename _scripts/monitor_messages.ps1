$config = Get-Content "$PSScriptRoot\..\.config.json" | ConvertFrom-Json
Get-Content "$($config.mgsvtpp_path)mod\ih_log.txt" -Tail 5 -Wait | Where-Object {
        ($_ -match "info: ALERT:") `
    -or ($_ -match "error: ") `
    -or ($_ -match "/!\\") `
    -or ($_ -match "<o>") `
}