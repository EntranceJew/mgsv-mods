$7zip = 'C:\ProgramData\chocolatey\bin\7z.exe'
$fpk = 'C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\utils\mgsv_tool\MGSV_FPK_Tool.exe'
$lng = 'C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\utils\translationtool\LangTool.exe'
$qh = 'C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\utils\quickhash\QuickHash.exe'
$mb = 'C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\utils\snakebite\makebite.exe'
$cmd = 'C:\Windows\System32\cmd.exe'
[Reflection.Assembly]::LoadFile("C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\utils\quickhash\CityHash.dll")

function Hash-Quickly {
    [OutputType([string])]
    param (
        [string]$text
    )
    $qh_dir = Split-Path -Path "$qh"
    Set-Location "$qh_dir"
    &$cmd /c "cd /D `"$qh_dir`" && `"$qh`" `"$text`" -s32 -d > output.txt"
    $read = Get-Content "output.txt"; Remove-Item "output.txt"
    return $read;
}
function Extract-MGSV {
    # [CmdletBinding()]
    param (
        [string]$input_mgsv,
        [string]$needle_sideop_id,
        [string]$replacement_sideop_id
    )

    Remove-Item "$parent_dir\dir_$file_name" -Recurse

    $parent_dir = Split-Path -Path "$input_mgsv"
    $file_name = Split-Path -Path "$input_mgsv" -Leaf
    Set-Location "$parent_dir"
    &$7zip x "$input_mgsv" -aoa -o"dir_$file_name" -r

    # step 2: extract fpks
    $all_fpks = Get-ChildItem -Path "dir_$file_name" -Recurse -Filter *.fpk  | %{$_.FullName}
    # this will capture .fpk and .fpkd, this is a feature that can quickly become a bug; that's when you use: | Where-Object { $_.Extension -eq '.fpk' }
    $fpk_dir = Split-Path -Path "$fpk"
    Set-Location "$fpk_dir"
    foreach($fpk_path in $all_fpks){
        $fpk_file_path = Split-Path -Path "$fpk_path"
        Set-Location "$fpk_file_path"
        $debug_output = "$fpk `"$fpk_path`""
        #Write-Host $debug_output
        &$fpk "$fpk_path"
        Remove-Item "$fpk_path"
    }

    Write-Host "manwhich"

    # step 3: extract language files
    # $all_lngs = Get-ChildItem -Path "dir_$file_name" -Recurse -Filter *.lng2  | %{$_.FullName}
    Set-Location "$parent_dir\dir_$file_name"
    # this will capture .lng and .lng2, this is a feature that can quickly become a bug; that's when you use: | Where-Object { $_.Extension -eq '.lng' }
    $all_lngs = Get-ChildItem -Path "." -Recurse -ErrorAction SilentlyContinue -Filter *.lng | %{$_.FullName}
    $lng_dir = Split-Path -Path "$lng"
    Set-Location "$lng_dir"
    foreach($lng_path in $all_lngs){
        $lng_file_path = Split-Path -Path "$lng_path"
        # Set-Location "$lng_file_path"
        Set-Location "$lng_dir"
        $debug_output2 = "$lng `"$lng_path`""
        #Write-Host $debug_output2
        &$lng "$lng_path"
        Remove-Item "$lng_path"
    }

    # step 4: replace all quest ids in file names
    Write-Host "slamjam"
    Set-Location "$parent_dir\dir_$file_name"
    $all_found_files = Get-ChildItem "$parent_dir\dir_$file_name" -recurse -filter *$needle_sideop_id* | %{$_.FullName}
    $all_found_files | Format-Table
    foreach($found_item in $all_found_files){
        $new_name = "$($found_item.Replace(`"q$needle_sideop_id`",`"q$replacement_sideop_id`"))"
        Write-Host "$new_name"
        Rename-Item "$found_item" -NewName "$new_name"
        # Remove-Item "$found_item"
    }

    # step 5: fix references in files
    Write-Host "ramjammers"
    Set-Location "$parent_dir\dir_$file_name"

    $pre_name = Hash-Quickly -text "name_q$needle_sideop_id"
    $post_name = Hash-Quickly -text "name_q$replacement_sideop_id"
    $pre_info = Hash-Quickly -text "info_q$needle_sideop_id"
    $post_info = Hash-Quickly -text "info_q$replacement_sideop_id"

    $search_files = Get-ChildItem "$parent_dir\dir_$file_name" -File -Recurse | %{$_.FullName}
    $search_files | Format-Table
    foreach ($search_file in $search_files) {
        $content = (Get-Content -Path "$search_file" -Raw)
        # replace sideop references
        $content = $content -replace "q$needle_sideop_id", "q$replacement_sideop_id"
        # replace hashed key ids
        $content = $content -replace "Key=`"$pre_name`"", "Key=`"$post_name`""
        $content = $content -replace "Key=`"$pre_info`"", "Key=`"$post_info`""
        Set-Content -Path "$search_file" -Value "$content" -NoNewline
    }

    # step 6: @TODO: probably correct other hashes
    # _____                 _                _   _  __                      _____               _     _               __  __          _____         ___  ____  
    #|_   _|               | |              (_) | |/ /                     / ____|             | |   (_)             |  \/  |        / ____|  /\   |__ \|  _ \ 
    #  | |  _ __ ___   __ _| | ___   _ _ __  _  | ' / ___  ___ _ __  ___  | |     _ __ __ _ ___| |__  _ _ __   __ _  | \  / |_   _  | (___   /  \     ) | |_) |
    #  | | | '_ ` _ \ / _` | |/ / | | | '_ \| | |  < / _ \/ _ \ '_ \/ __| | |    | '__/ _` / __| '_ \| | '_ \ / _` | | |\/| | | | |  \___ \ / /\ \   / /|  _ < 
    # _| |_| | | | | | (_| |   <| |_| | | | | | | . \  __/  __/ |_) \__ \ | |____| | | (_| \__ \ | | | | | | | (_| | | |  | | |_| |  ____) / ____ \ / /_| |_) |
    #|_____|_| |_| |_|\__,_|_|\_\\__,_|_| |_|_| |_|\_\___|\___| .__/|___/  \_____|_|  \__,_|___/_| |_|_|_| |_|\__, | |_|  |_|\__, | |_____/_/    \_\____|____/ 
    #                                                         | |                                              __/ |          __/ |                            
    #                                                         |_|                                             |___/          |___/                             

    return;

    # step 7: shut the language files again
    Write-Host "bling stingle"
    foreach($lng_path in $all_lngs){
        $zugga = "$lng_path.xml" -replace "q$needle_sideop_id", "q$replacement_sideop_id"
        Set-Location "$lng_dir"
        # Write-Host "$lng `"$zugga`""
        &$lng "$zugga"
        Remove-Item "$zugga"
    }

    # step 8: makebite
    Write-Host "bite my whole dick"
    $mb_dir = Split-Path -Path "$mb"
    Set-Location "$mb_dir"
    $zirc = "{0}\dir_{1}" -f $parent_dir, $file_name
    &$mb "$zirc" | Write-Output "Waiting."
    # [Diagnostics.Process]::Start("`"$mb`" ").WaitForExit()
    Move-Item -Path "$parent_dir\dir_$file_name\mod.mgsv" -Destination "$parent_dir\file_$file_name"
}

$parent_dir = "C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\mod_files\busted\sideop\"
$file_name = "cameraman1.mgsv"

# step 3: extract language files
# $all_lngs = Get-ChildItem -Path "dir_$file_name" -Recurse -Filter *.lng2  | %{$_.FullName}
Set-Location "$parent_dir\dir_$file_name"
# this will capture .lng and .lng2, this is a feature that can quickly become a bug; that's when you use: | Where-Object { $_.Extension -eq '.lng' }
$all_lngs = Get-ChildItem -Path "." -Recurse -ErrorAction SilentlyContinue -Filter *.lng2.xml | %{$_.FullName}
$lng_dir = Split-Path -Path "$lng"
Set-Location "$lng_dir"
Write-Host "bling stingle"
foreach($lng_path in $all_lngs){
    Set-Location "$lng_dir"
    # Write-Host "$lng `"$zugga`""
    &$lng "$lng_path"
    Remove-Item "$lng_path"
}

#Extract-MGSV -input_mgsv "C:\Program Files (x86)\Steam\steamapps\common\mgs_bullshit\mod_files\busted\sideop\cameraman4.mgsv" -needle_sideop_id "30297" -replacement_sideop_id "30723"