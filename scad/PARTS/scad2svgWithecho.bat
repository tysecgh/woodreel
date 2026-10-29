@echo off
chcp 65001 >nul

REM --- 1. 何もD&Dされなかった場合のエラー処理 ---
if "%~1"=="" (
    echo 【エラー】ファイルがドラッグ＆ドロップされていません。
    echo 処理したいファイルをこのバッチファイルにドロップしてください。
    goto END
)

REM --- 2. D&Dされたファイルを1つずつ順番に取り出してPowerShellに渡す ---
:LOOP
if "%~1"=="" goto END

echo ----------------------------------------
echo 処理中: %~1
powershell -ExecutionPolicy Bypass -File "../tool/scad2svgWithecho.ps1" "%~1"


REM --- 生成されたSVGを入力ファイルと同じ場所のSVGサブフォルダへ移動 ---
if exist "%~dpn1.svg" (
    if not exist "%~dp1SVG" mkdir "%~dp1SVG"
    move /Y "%~dpn1.svg" "%~dp1SVG\\"
)


REM 次の引数（ファイル）へシフトする
shift
goto LOOP

:END
echo ----------------------------------------
echo すべてのファイルの処理が完了しました。
echo.
pause
