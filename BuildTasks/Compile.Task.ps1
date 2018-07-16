taskx Compile @{
    If = (Get-ChildItem -Path $BuildRoot -Include *.csproj -Recurse)
    Inputs = {
        Get-ChildItem $BuildRoot -Recurse -File -Include *.cs
    }
    Outputs = "$Destination\bin\$ModuleName.dll"
    Jobs = {
        # This build command requires .Net Core
        "Building Module"
        $csproj = Get-ChildItem -Path $BuildRoot -Include *.csproj -Recurse
        $folder = Split-Path $csproj
        dotnet build $folder -c Release -o $Destination\bin
    }
}
