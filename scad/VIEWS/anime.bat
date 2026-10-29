@echo off
setlocal enabledelayedexpansion

:: --- 設定項目 ---
set OPENSCAD_PATH="C:\Program Files (x86)\OpenSCAD\openscad"
set SCAD_FILE=SKELETON.scad
set OUTPUT_DIR=frames
set TOTAL_STEPS=150
set CAMERA=30,-10,0,45,0,160,500
:: ----------------

if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%

echo --- 連番画像のレンダリングを開始します ---

for /L %%i in (0, 1, %TOTAL_STEPS%) do (
    set /a "idx=%%i+1"
    
    :: 【1】バッチ側で先に計算を行う（例: 0*10, 1*10, 2*10 ...）
    set /a "calc_val=%%i * 1"
    
    :: 4桁のゼロ埋めファイル名を作成
    if %%i LSS 10 (
        set "filename=%OUTPUT_DIR%\frame_000%%i.png"
    ) else if %%i LSS 100 (
        set "filename=%OUTPUT_DIR%\frame_00%%i.png"
    ) else if %%i LSS 1000 (
        set "filename=%OUTPUT_DIR%\frame_0%%i.png"
    ) else (
        set "filename=%OUTPUT_DIR%\frame_%%i.png"
    )
    
    :: 【2】計算済みの値（!calc_val!）を文字列に埋め込んでOpenSCADに渡す
   %OPENSCAD_PATH% -o !filename! --camera=%CAMERA% -D "$time=!calc_val!" %SCAD_FILE%
)

echo --- 完了しました ---
pause
