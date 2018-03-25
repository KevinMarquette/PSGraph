
task Copy {
    "Creating Directory [$Destination]..."
    $null = New-Item -ItemType 'Directory' -Path $Destination -ErrorAction 'Ignore'

    $files = Get-ChildItem -Path $Source -File |
        Where-Object 'Name' -notmatch "$ModuleName\.ps[dm]1"

    foreach ($file in $files)
    {
        'Creating [.{0}]...' -f $file.FullName.Replace($buildroot, '')
        Copy-Item -Path $file.FullName -Destination $Destination -Force
    }

    $directories = Get-ChildItem -Path $Source -Directory |
        Where-Object 'Name' -notin $Folders

    foreach ($directory in $directories)
    {
        'Creating [.{0}]...' -f $directory.FullName.Replace($buildroot, '')
        Copy-Item -Path $directory.FullName -Destination $Destination -Recurse -Force
    }
}
