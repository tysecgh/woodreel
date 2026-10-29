// 
// SVGでテキスト表示したときのおおよその大きさのBOXを描画
// 同時にその場所にテキストを表示するSVGコードをechoする
//
// 別途生成したSVGファイルにecho出力をマージすることでテキストデータをSVGに引き継げる
//
// 独自でSVG座標に変換（y値負にするだけだが）してるので生の座標で呼ばなければうまく機能しない
// 
module svgtxt( txts, p ){
    fsize = 4;
    xr = 1;
    yr = 1.2;
    
    w = max([
            len(str(txts[0]))*(fsize+1),
            max([for (t = txts) len(str(t))])*fsize,
    ])*xr+2;
    h = len(txts)*fsize*yr+2;
    lw = 0.1;
    translate([p[0],p[1]-h,0])
        difference(){
        translate([-lw,-lw]) square([w+lw*2,h+lw*2]);
        square([w,h]);
    }
    
    echo( str(
        "<text x='",p[0]+1,"' y='",fsize-p[1]+1,"' font-size='",fsize,"' >" 
    ));
    echo( str(
        "<tspan x='",p[0]+1,"' dy='0' font-size='",fsize+1,"' >",
        txts[0],
        "</tspan>"
    ) );
    for( i=[1:1:len(txts)-1] ){
        echo( str(
            "<tspan x='",p[0]+1,"' dy='",fsize*yr,"' >",
            txts[i],
            "</tspan>"
        ) );
    }
    echo( "</text>" );
}


/***
===== 以下 powershell コード =====

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
$processInfo.Arguments = "-o - --export-format svg `"$scadFile`""
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

***/
