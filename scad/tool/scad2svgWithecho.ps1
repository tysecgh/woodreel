#
# powershell  -ExecutionPolicy Bypass ./scad2svgWithecho.ps1 hoge.scad
#


[Console]::OutputEncoding = [Text.Encoding]::UTF8   # 日本語の文字化け対策
$exe = 'C:\Program Files (x86)\OpenSCAD\openscad'

# 引数のチェック（SCADファイルのみ受け取る）
if ($args.Count -lt 1) {
    Write-Host "使い方: .\build_svg.ps1 <input.scad>"
    Write-Host "例:     .\build_svg.ps1 hoge.scad"
    exit
}

$scadFile  = $args[0]
# 入力ファイルの拡張子を .svg に置き換えて出力ファイル名にする（hoge.scad -> hoge.svg）
$outputSvg = [System.IO.Path]::ChangeExtension($scadFile, ".svg")

Write-Host "対象ファイル: $scadFile -> 出力: $outputSvg"

# 1. .NET Processクラスで標準出力(SVG)と標準エラー出力(ECHO)を同時に取得
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $exe
$processInfo.Arguments = "-o - --export-format svg -D `"`$prjflg=true`" `"$scadFile`""
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true
$processInfo.UseShellExecute = $false
$processInfo.StandardOutputEncoding = [Text.Encoding]::UTF8
$processInfo.StandardErrorEncoding = [Text.Encoding]::UTF8

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
[void]$process.Start()

# 標準出力からSVGデータを取得
$svgStdout = $process.StandardOutput.ReadToEnd()

# 標準エラー出力からECHO行を抽出
$echoLines = @()
while (-not $process.StandardError.EndOfStream) {
    $line = $process.StandardError.ReadLine()
    if ($line -match '^ECHO: ') {
        $cleaned = $line -replace '^ECHO: "?', '' -replace '"$', ''
        $echoLines += $cleaned
    }
}
$process.WaitForExit()

if ([string]::IsNullOrWhiteSpace($svgStdout)) {
    Write-Error "エラー: OpenSCADからSVGデータが取得できませんでした。"
    exit
}

# ==========================================
# 2. 【マージ前】のSVGに対して stroke-width を置換
# ==========================================
 Write-Host "マージ前のSVGを処理中 (stroke-width: 0.5 -> 0.2)..."
$matchCount = 0
    
# 正規表現で置換しつつ、何箇所書き換えたかをカウント
$processedSvg = [System.Text.RegularExpressions.Regex]::Replace(
	$svgStdout,
	'stroke-width="0.5"',
	{
		param($match)
		$script:matchCount++
		return 'stroke-width="0.2"'
	}
)
Write-Host " -> 置換: $matchCount 箇所 (想定では1つ)"

# ==========================================
# 3. マージ処理（echoテキストの挿入）
# ==========================================
Write-Host "SVGの末尾にecho出力をマージ中..."
$textToAdd = $echoLines -join "`n"

# SVGの閉じタグ (</svg>) の直前にテキスト要素を挿入
if ($svgStdout -match '</svg>') {
    $finalSvg = $svgStdout -replace '</svg>', "`n  <!-- OpenSCADから自動マージされたテキスト -->`n$textToAdd`n</svg>"
} else {
    $finalSvg = $svgStdout + "`n" + $textToAdd
}

# 決まったファイル名で保存
$finalSvg | Out-File -FilePath $outputSvg -Encoding utf8
Write-Host "完了！ 出力ファイル: $outputSvg" -ForegroundColor Green
