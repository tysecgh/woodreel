# ==========================================
# 設定
# ==========================================
# 対象とするファイルの拡張子（例: ".txt", "*.log" など）
$targetExtension = "*.svg"

# 実行中のフォルダ（カレントディレクトリ）を取得
$currentDir = Get-Location
Write-Host "作業ディレクトリ: $currentDir" -ForegroundColor Cyan

# 該当するファイルをすべて取得（サブフォルダも含める場合は -Recurse を追加してください）
$files = Get-ChildItem -Path $currentDir -Filter $targetExtension -File

if ($files.Count -eq 0) {
    Write-Host "条件に一致するファイルが見つかりませんでした。" -ForegroundColor Yellow
    return
}

# 各ファイルを処理
foreach ($file in $files) {
    try {
        # ファイルの内容を文字列として一括読み込み（文字コードは必要に応じて変更してください）
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # "HOGE" を "hoge" に置換（大文字小文字を厳密に区別する場合は -cne / -creplace を使用）
        # 通常の -replace は大文字小文字を区別しませんが、完全に "HOGE" のみを対象にします
        if ($content -match 'stroke-width="0.5"') {
            $newContent = $content -replace 'stroke-width="0.5"', 'stroke-width="0.2"'
            
            # 置換した内容をファイルに書き戻す
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
            Write-Host "[成功] 置換しました: $($file.Name)" -ForegroundColor Green
        } else {
            Write-Host "[スキップ] 'HOGE' が見つかりませんでした: $($file.Name)" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[エラー] $($file.Name) の処理中にエラーが発生しました: $_" -ForegroundColor Red
    }
}

Write-Host "すべての処理が完了しました。" -ForegroundColor Cyan