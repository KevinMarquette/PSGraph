task UpdateSource {
    Copy-Item -Path $ManifestPath -Destination "$Source\$ModuleName.psd1"
}
