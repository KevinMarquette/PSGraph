task Clean {
    if (Test-Path $Output)
    {
        "Cleaning Output files in [$Output]..."
        $null = Get-ChildItem -Path $Output -File -Recurse |
            Remove-Item -Force -ErrorAction 'Ignore'

        "Cleaning Output directories in [$Output]..."
        $null = Get-ChildItem -Path $Output -Directory -Recurse |
            Remove-Item -Recurse -Force -ErrorAction 'Ignore'
    }
}
