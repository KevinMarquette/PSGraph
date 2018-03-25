
function Import-ClassOrder
{
    [cmdletbinding()]
    param($cName,$Map)
    Write-Verbose "Checking on [$cName]"
    if($Map.ContainsKey($cName) -and $Map[$cName].Imported -ne $true)
    {
        if($Map[$cName].Base)
        {
            Write-Verbose " Base class [$($Map[$cName].Base)]"
            Import-ClassOrder $Map[$cName].Base $Map
        }
        $cPath = $Map[$cName].Path
        Write-Verbose "Dot Sourcing [$cPath]"
        $cPath
        $Map[$cName].Imported = $true
    }
}

taskx BuildModule @{
    Inputs  = (Get-ChildItem -Path $Source -Recurse -Filter *.ps1)
    Outputs = $ModulePath
    Jobs    = {
        $sb = [Text.StringBuilder]::new()
        $null = $sb.AppendLine('$Script:PSModuleRoot = $PSScriptRoot')

        # Class importer
        $root = Join-Path -Path $source -ChildPath 'Classes'
        "Load classes from [$root]"
        $classFiles = Get-ChildItem -Path $root -Filter '*.ps1' -Recurse |
                    Where-Object Name -notlike '*.Tests.ps1'

        $classes = @{}

        foreach($file in $classFiles)
        {
            $name = $file.BaseName
            $classes[$name] = @{
                Name = $name
                Path = $file.FullName
            }
            $data = Get-Content $file.fullname
            foreach($line in $data)
            {
                if($line -match "class\s+($Name)\s*:\s*(?<baseclass>\w*)")
                {
                    $classes[$name].Base = $Matches.baseclass
                }
            }
        }

        $importOrder = foreach($className in $classes.Keys)
        {
            Import-ClassOrder $className $classes
        }

        foreach($class in $importOrder)
        {
            "Importing [$class]..."
            $null = $sb.AppendLine("# .$class")
            $null = $sb.AppendLine([IO.File]::ReadAllText($class))
        }

        foreach ($folder in ($Folders -ne 'Classes'))
        {
            if (Test-Path -Path "$Source\$folder")
            {
                $null = $sb.AppendLine("# Importing from [$Source\$folder]")
                $files = Get-ChildItem -Path "$Source\$folder\*.ps1" |
                    Where-Object 'Name' -notlike '*.Tests.ps1'

                foreach ($file in $files)
                {
                    $name = $file.Fullname.Replace($buildroot, '')

                    "Importing [$($file.FullName)]..."
                    $null = $sb.AppendLine("# .$name")
                    $null = $sb.AppendLine([IO.File]::ReadAllText($file.FullName))
                }
            }
        }

        "Creating Module [$ModulePath]..."
        $null = New-Item -Path (Split-path $ModulePath) -ItemType Directory -ErrorAction SilentlyContinue -Force
        Set-Content -Path  $ModulePath -Value $sb.ToString() -Encoding 'UTF8'

        'Moving "#Requires" statements and "using" directives...'
        Move-Statement -Path $ModulePath -Type 'Comment', 'Keyword' -Token '#Requires', 'using' -Index 0
    }
}
