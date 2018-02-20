# Export-PSGraph
This is the command that executes the GraphViz engine to generate the DOT formated syntax into an image.

# Common usage
Here are the common ways to use this command.

## Process a .dot or .gv file
If you have an existing text file in the DOT format, you can pass it to `Export-PSGraph` to generate the resulting image.

    $files | Export-PSGraph
    Export-PSGraph -Source $files

This will create a new png file next to the existing file by default. 

## Processing a text stream
Instead of saving your graphs to files first, you can pipe them directly to the `Export-Graph` command.

    graph g {
        edge a,b,c,d,a
    } | Export-PSGraph -DestinationPath $path

Because there is no source file, you need to provide a destination path. If none is provided, it will save it ot the `$env:temp` folder under a random name.

# Arguments
## -ShowGraph
Specifying this will auto open the resulting file in the default viewer for that file type. I use this a lot when designing a graph to quickly see the result.

## -Source [string]
This is the input source to be exported. It can either be a list of file paths to process or text representation of a graph to be processes by the GraphViz engine.

## -DestinationPath [string]
The location to save the file. If not specified, it will either save next to the original file or to the `$env:temp` folder. 

## OutputFormat
This is the output filetype that is generated. The default value is `*.png`. If the `-DestinationPath` specifies a format in the name then that will be used instead.

These are the valid options for output formats:

* png (default)
* jpg
* gif
* imap
* cmapx
* jp2
* json
* pdf
* plain
* dot

## -LayoutEngine [enum]
GraphViz supports multiple layout engines. Each work better on different types of datasets.

These are the available engines:

* Hierarchical (Default)
* Radial
* Circular
* SpringModelSmall
* SpringModelMedium
* SpringModelLarge
