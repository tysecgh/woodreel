#
# powershell  -ExecutionPolicy Bypass ./getecho.ps1 hoge.scad
#
[Console]::OutputEncoding = [Text.Encoding]::UTF8   # “ú–{Œê‚Ì•¶Žš‰»‚¯‘Îô
$exe = 'C:\Program Files (x86)\OpenSCAD\openscad'

& $exe -o - --export-format echo $args 2>&1 |
        ForEach-Object { "$_" } |
        Where-Object   { $_ -match '^ECHO: ' } |
        ForEach-Object { $_ -replace '^ECHO: "?', '' -replace '"$', '' }
