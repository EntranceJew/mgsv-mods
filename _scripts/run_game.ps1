$config = Get-Content "$PSScriptRoot\..\.config.json" | ConvertFrom-Json

# game hasn't run yet, backup saves
&"$PSScriptRoot\backup_saves.ps1" | Out-Null

# begin running the game, while monitoring output
$monitor_messages = "$PSScriptRoot\monitor_messages.ps1"

$pjob = Start-Job -ScriptBlock {
    Start-Process -FilePath "$($using:config.mgsvtpp_path)mgsvtpp.exe" -Wait -Verb RunAs
    # in case of problem:
    #Start-Process "steam://run/287700/"
    #Start-Sleep -Milliseconds 20000
    #$proc = Get-Process mgsvtpp
    #Wait-Process -Id $proc
}
$ljob = Start-Job -ScriptBlock { 
    Set-Location "$using:PWD\..";
    Start-Sleep -Seconds 30
    &"$using:monitor_messages"
}

while ($pjob.State -eq 'Running' -and $ljob.HasMoreData) {
  Receive-Job $ljob
  Start-Sleep -Milliseconds 200
}
Receive-Job $ljob

Stop-Job $ljob
Remove-Job $ljob
Remove-Job $pjob


# game running over, move hashes & attempt to make sense of the new ones
$old_hashes = Get-Content -Path "$($config.hashwrangler_target_hashes)"
$new_hashes = Get-Content -Path "$($config.mgsvtpp_path)mod\ih_unknownStr32.txt"
($old_hashes + $new_hashes) | Sort-Object -Unique | Out-File -FilePath "$($config.hashwrangler_target_hashes)"

&"$PSScriptRoot\wrangle_hashes.ps1"