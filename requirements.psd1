@{
    CreateFolder = @{
        DependencyType = 'Command'
        Source = 'MKDIR C:\ProgramData\PSGraphViz -Force -ea 0'
    }
    
    DownloadFile = @{
        DependencyType = 'FileDownload'
        Source = 'http://graphviz.org/pub/graphviz/stable/windows/graphviz-2.38.zip'
        Target = 'C:\ProgramData\PSGraphViz\psgraphviz.zip'
        DependsOn = 'CreateFolder'
    }

    Unzip = @{
        DependencyType = 'Command'
        Source = 'Unblock-File -Path "C:\ProgramData\PSGraphViz\psgraphviz.zip"',
        'Expand-Archive -Path "C:\ProgramData\PSGraphViz\psgraphviz.zip" -DestinationPath "C:\ProgramData\PSGraphViz"'
        DependsOn = 'DownloadFile'
    }
}
