$config = Get-Content "$PSScriptRoot\..\.config.json" | ConvertFrom-Json
&"$($config.hashwrangler_path)" "$($config.hashwrangler_target_hashes)" "$($config.strings_path)"
# todo: copy from unknown ih files to target_hashes
# todo: copy the strings found into a file somewhere idk just push them around so i don't gotta think about it hombre
# todo: inside InfLookup just make anything we don't know go directly to the hash fondling dungeon i'm tired of pointless blank lookups