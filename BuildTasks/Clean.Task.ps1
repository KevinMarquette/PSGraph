task Clean {
    'Cleaning Output files...'
    $null = Get-ChildItem -Path $Output -File -Recurse |
        Remove-Item -Force -ErrorAction 'Ignore'

    'Cleaning Output directories...'
    $null = Get-ChildItem -Path $Output -Directory -Recurse |
        Remove-Item -Recurse -Force -ErrorAction 'Ignore'
}
