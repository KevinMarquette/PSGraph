task UpdateSource {
    Copy-Item -Path $ManifestPath -Destination "$Source\$ModuleName.psd1"

    $content = Get-Content -Path "$Source\$ModuleName.psd1" -Raw -Encoding UTF8
    $content.Trim() | Set-Content -Path "$Source\$ModuleName.psd1" -Encoding UTF8
}
