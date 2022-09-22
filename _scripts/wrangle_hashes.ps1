$config = Get-Content "$PSScriptRoot\..\.config.json" | ConvertFrom-Json
$target_hash = (Get-FileHash -Path "$($config.hashwrangler_target_hashes)").Hash
$compare_hash = ""
if (Test-Path -Path "$($config.hashwrangler_target_hashes).sha256" -PathType Leaf) {
    $compare_hash = Get-Content -Path "$($config.hashwrangler_target_hashes).sha256"
}
if ($target_hash -eq $compare_hash) {
    "No new hashes."
} else {
    &"$($config.hashwrangler_path)" "$($config.hashwrangler_target_hashes)" "$($config.strings_path)"
    Set-Content -Path "$($config.hashwrangler_target_hashes).sha256" -Value $target_hash
}

# todo: copy from unknown ih files to target_hashes
# todo: copy the strings found into a file somewhere idk just push them around so i don't gotta think about it hombre
# todo: inside InfLookup just make anything we don't know go directly to the hash fondling dungeon i'm tired of pointless blank lookups