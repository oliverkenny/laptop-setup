# PowerShell Profile v2.3.1 #
#---------------------------#
### SETUP GUIDE ###

# 1. Check if you have a PowerShell profile:
#    Open PowerShell and run: Test-Path $PROFILE
#    If it returns False, continue to step 2. If True, skip to step 3.

# 2. Create a new PowerShell profile:
#    Run the following commands in PowerShell:
#    if (!(Test-Path -Path $PROFILE)) {
#        New-Item -Type File -Path $PROFILE -Force
#    }
#    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Open your PowerShell profile in a text editor:
#    Run: notepad $PROFILE

# 4. Replace the contents of the profile with this entire script.

# 5. Configure global variables:
#    Scroll down to the "GLOBAL VARIABLES" section and fill in the values.

# 6. Save the file and close the text editor.

# 7. Reload your PowerShell profile:
#    Run: . $PROFILE

# Your new PowerShell profile is now active with all the custom functions and aliases!

#--------------------------#
#--- PowerShell Profile ---#
#--------------------------#

### GLOBAL VARIABLES ###
# Modify these variables to match your system setup
$RootRepo = "" # The directory that PowerShell navigates to on startup
$ReposPath = "" # The directory where your repositories are cloned
$ScriptPath = "" # The directory that holds your external PowerShell scripts

### ALIASES ###
# These aliases provide shorthand for commonly used functions
Set-Alias repos goToRepositoryFolder
Set-Alias npp openNotepadPlusPlus
Set-Alias sln openSolution
Set-Alias open openCurrentDirectoryInFileExplorer
Set-Alias extract extractIntoSameFolder
Set-Alias find findFilesByExtension
Set-Alias tree Show-Tree
Set-Alias md2pdf Convert-MarkdownToPDF
Set-Alias allmd2pdf Convert-AllMarkdownToPDF
Set-Alias copyflatfolder Copy-FlatFolder
Set-Alias obs Open-Obsidian

#--------------------------------------------------------------------#

### SETUP ###
# This function initializes PowerShell with custom settings
function initPowershell {
	oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/peru.omp.json' | Invoke-Expression
	Set-Location $RootRepo
	Clear-Host
}
# Run the initialization function
initPowershell

#--------------------------------------------------------------------#

### UTILITY FUNCTIONS ###

# Navigate to the repository folder
function goToRepositoryFolder {
	Set-Location $ReposPath	
}

# Open the solution file in the current directory
function openSolution {
    $solutionFiles = Get-ChildItem -Filter *.sln

    if ($solutionFiles.Count -eq 0) {
        Write-Host "No solution files found in the current directory."
        return
    }

    if ($solutionFiles.Count -eq 1) {
        $solutionToOpen = $solutionFiles[0]
    } else {
        Write-Host "Multiple solution files found. Please choose one:"
        for ($i = 0; $i -lt $solutionFiles.Count; $i++) {
            Write-Host "$($i + 1): $($solutionFiles[$i].Name)"
        }
        
        $choice = Read-Host "Enter the number of the solution to open"
        $index = [int]$choice - 1
        
        if ($index -ge 0 -and $index -lt $solutionFiles.Count) {
            $solutionToOpen = $solutionFiles[$index]
        } else {
            Write-Host "Invalid choice. No solution opened."
            return
        }
    }

    try {
        Write-Host "Opening solution file: $($solutionToOpen.Name)"
        Invoke-Item -Path $solutionToOpen.FullName
    } catch {
        Write-Host "Error opening solution: $_"
    }
}

# Open the current directory in File Explorer
function openCurrentDirectoryInFileExplorer {
	Invoke-Item .
}

# Open a file in Notepad++
function openNotepadPlusPlus($path) {
	start notepad++ $path
}

function Open-Obsidian {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$false)]
        [string]$Path
    )

    # Define the base URI for Obsidian
    $baseUri = "obsidian://open"

    try {
        if (-not $Path) {
            # Case 1: No path provided
            Start-Process $baseUri
            Write-Verbose "Opened Obsidian without a specific path."
        }
        elseif ($Path -eq '.') {
            # Case 2: Path is '.'
            $currentPath = (Get-Location).Path
            $encodedPath = [uri]::EscapeDataString($currentPath)
            $fullUri = "$baseUri?path=$encodedPath"
            Start-Process $fullUri
            Write-Verbose "Opened Obsidian with the current directory path: $currentPath"
        }
        else {
            # Case 3: Specific path provided
            if (Test-Path -Path $Path) {
                $resolvedPath = (Resolve-Path -Path $Path).Path
                $encodedPath = [uri]::EscapeDataString($resolvedPath)
                $fullUri = "$baseUri?path=$encodedPath"
                Start-Process $fullUri
                Write-Verbose "Opened Obsidian with the specified path: $resolvedPath"
            }
            else {
                # Case 4: Invalid path provided
                Throw "The path '$Path' is not valid or does not exist."
            }
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}


# Extract files from an archive in the same folder
function extractIntoSameFolder($path) {
	tar -xf $path
}

# Find files by extension recursively
function findFilesByExtension($extension) {
	Get-ChildItem -Path . -Filter *.$extension -Recurse | Select-Object FullName | Format-Table -AutoSize
}

# Open a URL in the default browser
function Open-UrlInBrowser {
    param (
        [string]$url
    )
    
    if ($url) {
        Start-Process $url
    } else {
        Write-Error "URL is not valid."
    }
}

# Display a directory tree with color-coding
function Show-Tree {
    param(
        [string]$Path = ".",
        [string]$Indent = "",
        [int]$Level = 0,
        [string]$OutputFile = $null
    )
    $Colors = @("DarkCyan", "DarkGreen", "DarkYellow", "DarkRed", "DarkMagenta", "DarkBlue", "Gray")

    $AllFiles = Get-ChildItem -Path $Path -Recurse -File
    if ($AllFiles.Count -gt 10000 -and $OutputFile -eq $null) {
        Write-Host "The total number of files exceeds 10,000. Please specify an output file using the -OutputFile parameter."
        return
    }

    $FolderItems = Get-ChildItem -Path $Path -Directory

    $OutputMode = $null
    if ($OutputFile) {
        $OutputMode = { param($text) Out-File -Append -FilePath $OutputFile -Encoding UTF8 -InputObject $text }
    } else {
        $OutputMode = { param($text) Write-Host $text }
    }

    foreach ($Folder in $FolderItems) {
        $FileCount = ($AllFiles | Where-Object { $_.FullName.StartsWith($Folder.FullName) }).Count
        $Color = $Colors[$Level % $Colors.Length]
        &$OutputMode "$Indent|- [F] $Folder ($FileCount)" -ForegroundColor $Color
        Show-Tree -Path $Folder.FullName -Indent "$Indent   " -Level ($Level + 1) -OutputFile $OutputFile
    }

    if ($Level -eq 0 -or $FolderItems.Count -gt 0) {
        &$OutputMode ""
    }

    $DirectFiles = Get-ChildItem -Path $Path -File
    foreach ($File in $DirectFiles) {
        &$OutputMode "$Indent|- [>] $File" -ForegroundColor $Colors[($Level + 1) % $Colors.Length]
    }
}

# Convert Markdown files to PDF
function Convert-MarkdownToPDF {
    <#
    .SYNOPSIS
    Converts Markdown files to PDF format using Pandoc and wkhtmltopdf.

    .DESCRIPTION
    This function takes one or more Markdown files and converts them to PDF format. It leverages Pandoc for converting Markdown to HTML and wkhtmltopdf for converting HTML to PDF.

    .PARAMETER InputFile
    Specifies the input Markdown file(s). Required.

    .PARAMETER OutputDirectory
    Specifies the output directory for PDF files. Optional.

    .PARAMETER MaxThreads
    Specifies the maximum number of concurrent threads. Default is 5.

    .PARAMETER DisplayHelp
    Displays this help message. Aliases: -h, -help

    .EXAMPLE
    Convert-MarkdownToPDF -InputFile 'document.md' -OutputDirectory 'C:\PDFs' -MaxThreads 3
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [Alias("h", "help")]
        [switch]$DisplayHelp,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]]$InputFile,
        
        [Parameter(Mandatory=$false)]
        [string]$OutputDirectory,

        [Parameter(Mandatory=$false)]
        [int]$MaxThreads = 5
    )

    begin {
        if ($DisplayHelp) {
            Write-Host "Convert-MarkdownToPDF"
            Write-Host "Converts Markdown files to PDF format using Pandoc and wkhtmltopdf."
            Write-Host ""
            Write-Host "Parameters:"
            Write-Host "  -InputFile <string[]>    : Specifies the input Markdown file(s). Required."
            Write-Host "  -OutputDirectory <string>: Specifies the output directory for PDF files. Optional."
            Write-Host "  -MaxThreads <int>        : Specifies the maximum number of concurrent threads. Default is 5."
            Write-Host "  -DisplayHelp             : Displays this help message. Aliases: -h, -help"
            Write-Host ""
            Write-Host "Example:"
            Write-Host "  Convert-MarkdownToPDF -InputFile 'document.md' -OutputDirectory 'C:\PDFs' -MaxThreads 3"
            return
        }

        # Check if Pandoc and wkhtmltopdf are installed
        $requiredCommands = @("pandoc", "wkhtmltopdf")
        foreach ($cmd in $requiredCommands) {
            if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
                throw "$cmd is not installed or not in PATH. Please install $cmd and try again."
            }
        }

        # CSS content
        $cssContent = @"
@import url('https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;700&display=swap');
body { font-family: 'Open Sans', sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px; }
h1, h2, h3 { color: #2c3e50; }
h1 { border-bottom: 2px solid #3498db; padding-bottom: 10px; }
ul, ol { padding-left: 25px; }
code { background-color: #f8f8f8; border: 1px solid #ddd; border-radius: 3px; padding: 2px 5px; font-family: 'Courier New', Courier, monospace; }
"@

        # Create a temporary CSS file
        $tempCssFile = [System.IO.Path]::GetTempFileName() + ".css"
        [System.IO.File]::WriteAllText($tempCssFile, $cssContent)

        # Create a thread-safe queue for input files
        $inputQueue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()

        # Create a runspace pool
        $runspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
        $runspacePool.Open()

        $runspaces = New-Object System.Collections.ArrayList
    }

    process {
        foreach ($file in $InputFile) {
            $inputQueue.Enqueue($file)
        }
    }

    end {
        while ($inputQueue.Count -gt 0) {
            if ($runspaces.Count -lt $MaxThreads) {
                $inputFile = ""
                if ($inputQueue.TryDequeue([ref]$inputFile)) {
                    $outputFile = if ($OutputDirectory) {
                        Join-Path $OutputDirectory ([System.IO.Path]::GetFileNameWithoutExtension($inputFile) + ".pdf")
                    } else {
                        [System.IO.Path]::ChangeExtension($inputFile, "pdf")
                    }

                    $powershell = [powershell]::Create().AddScript({
                        param($inputFile, $outputFile, $tempCssFile)

                        try {
                            $tempHtmlFile = [System.IO.Path]::GetTempFileName() + ".html"

                            # Convert Markdown to HTML
                            pandoc -f markdown -t html5 --standalone --embed-resources --css=$tempCssFile -o $tempHtmlFile $inputFile

                            # Convert HTML to PDF
                            wkhtmltopdf --encoding utf-8 --javascript-delay 1000 $tempHtmlFile $outputFile

                            Write-Output "Conversion complete. PDF saved as $outputFile"
                        }
                        catch {
                            Write-Error "An error occurred during conversion of $inputFile - $_"
                        }
                        finally {
                            #Remove-Item -Path $tempHtmlFile -ErrorAction SilentlyContinue
							
                        }
                    }).AddArgument($inputFile).AddArgument($outputFile).AddArgument($tempCssFile)

                    $powershell.RunspacePool = $runspacePool

                    $runspaces.Add([PSCustomObject]@{
                        Runspace = $powershell.BeginInvoke()
                        PowerShell = $powershell
                    }) | Out-Null
                }
            }

            $completedRunspaces = $runspaces | Where-Object { $_.Runspace.IsCompleted }
            foreach ($runspace in $completedRunspaces) {
                $runspace.PowerShell.EndInvoke($runspace.Runspace)
                $runspace.PowerShell.Dispose()
                $runspaces.Remove($runspace)
            }

            Start-Sleep -Milliseconds 100
        }

        # Wait for all runspaces to complete
        while ($runspaces.Count -gt 0) {
            $completedRunspaces = $runspaces | Where-Object { $_.Runspace.IsCompleted }
            foreach ($runspace in $completedRunspaces) {
                $runspace.PowerShell.EndInvoke($runspace.Runspace)
                $runspace.PowerShell.Dispose()
                $runspaces.Remove($runspace)
            }
            Start-Sleep -Milliseconds 100
        }

        # Clean up
        $runspacePool.Close()
        $runspacePool.Dispose()
        Remove-Item -Path $tempCssFile -ErrorAction SilentlyContinue
    }
}


# Convert all Markdown files in a folder to PDF
function Convert-AllMarkdownToPDF {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Folder
    )

    # Use the current directory if no folder is specified
    if (-not $Folder) {
        $Folder = Get-Location
    }

    # Get all markdown files in the folder recursively
    $allMarkdownFiles = Get-ChildItem -Path $Folder -Recurse -Include *.md -ErrorAction SilentlyContinue

    # Count the files
    $totalFileCount = $allMarkdownFiles.Count
    if ($totalFileCount -eq 0) {
        Write-Output "No markdown files found in the specified folder."
        return
    }

    Write-Output "Found $totalFileCount markdown files in total."

    # Determine available threads
    $availableThreads = [int]$env:NUMBER_OF_PROCESSORS
    $recommendedThreads = [Math]::Min($availableThreads, 8)  # Cap at 8 as a reasonable maximum

    Write-Output "Your system has $availableThreads threads available."
    Write-Output "Recommended number of threads to use: $recommendedThreads"

    # Ask user for thread count
    do {
        $userThreads = Read-Host "Enter the number of threads to use (1-$availableThreads, default: $recommendedThreads)"
        if ($userThreads -eq "") { $userThreads = $recommendedThreads }
    } while ($userThreads -notmatch '^\d+$' -or [int]$userThreads -lt 1 -or [int]$userThreads -gt $availableThreads)

    $MaxThreads = [int]$userThreads

    # Ask user for max number of files to convert
    do {
        $userMaxFiles = Read-Host "Enter the maximum number of files to convert (1-$totalFileCount, default: $totalFileCount)"
        if ($userMaxFiles -eq "") { $userMaxFiles = $totalFileCount }
    } while ($userMaxFiles -notmatch '^\d+$' -or [int]$userMaxFiles -lt 1 -or [int]$userMaxFiles -gt $totalFileCount)

    $MaxFiles = [int]$userMaxFiles

    # Select the files to convert
    $markdownFiles = $allMarkdownFiles | Select-Object -First $MaxFiles

    Write-Output "Starting conversion process for $MaxFiles files using $MaxThreads threads..."

    # Create a script block for progress reporting
    $progressScript = {
        param($sourceId, $eventArgs)
        $completedFiles = $eventArgs.SourceArgs[0]
        $totalFiles = $eventArgs.SourceArgs[1]
        $percentComplete = [math]::Min(($completedFiles / $totalFiles) * 100, 100)
        Write-Progress -Activity "Converting markdown files to PDF" -Status "$percentComplete% Complete" -PercentComplete $percentComplete
    }

    # Create an event job for progress reporting
    $job = Register-ObjectEvent -InputObject ([System.Management.Automation.PSEngineEvent]::new()) -EventName "ProgressReport" -Action $progressScript

    # Initialize progress counters
    $completedFiles = 0
    $event = $job.EventObject

    try {
        # Use Convert-MarkdownToPDF with pipeline input for multithreading
        $markdownFiles | ForEach-Object {
            $outputFile = [System.IO.Path]::ChangeExtension($_.FullName, "pdf")
            $_
        } | Convert-MarkdownToPDF -MaxThreads $MaxThreads -ErrorAction Continue

        # Update progress after each file is processed
        $completedFiles++
        $event.Trigger($completedFiles, $MaxFiles)
    }
    finally {
        # Clean up the event job
        Unregister-Event -SourceIdentifier $job.Name
        Remove-Job -Job $job -Force
    }

    Write-Output "Conversion process completed. $MaxFiles files have been converted to PDF."
}

# Copy files to a flat folder structure
function Copy-FlatFolder {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DestinationFolder
    )

    # Create the destination folder if it doesn't exist
    if (-not (Test-Path $DestinationFolder)) {
        New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
    }

    # Get all .cs and .cshtml files in the current directory and subdirectories, including hidden items
    $files = Get-ChildItem -Path . -Recurse -File -Include *.cs, *.cshtml -Force

    # Create a hashtable to track copied files
    $copiedFiles = @{}

    foreach ($file in $files) {
        # Check if we've already copied a file with this name
        if ($copiedFiles.ContainsKey($file.Name)) {
            Write-Host "Skipping duplicate file: $($file.FullName)"
            continue
        }

        # Generate a unique name if a file with the same name already exists in the destination
        $destPath = Join-Path $DestinationFolder $file.Name
        $counter = 1
        while (Test-Path $destPath) {
            $newName = "{0}_{1}{2}" -f $file.BaseName, $counter, $file.Extension
            $destPath = Join-Path $DestinationFolder $newName
            $counter++
        }

        # Copy the file to the destination folder
        Copy-Item -Path $file.FullName -Destination $destPath -Force

        # Add the file to our tracking hashtable
        $copiedFiles[$file.Name] = $true

        Write-Host "Copied: $($file.FullName) to $destPath"
    }

    Write-Host "Copied all unique C# and Razor files to $DestinationFolder with a flat structure"
}

#--------------------------------------------------------------------#

### GIT FUNCTIONS ###

# Aliases for Git operations
set-alias acap addCommitAndPush
set-alias acom addCommit
set-alias devops Open-GitOriginUrl
set-alias gitlog Log-GitCommits
set-alias setremote Update-GitRemote

# Add, commit, and push changes
function addCommitAndPush ($m) {
	git add .
	git commit -m $m
	git push
}

# Add and commit changes
function addCommit ($m) {
	git add .
	git commit -m $m
}

# Get the Git origin URL
function Get-GitOriginUrl {
    if (-not (Test-IsGitRepository)) {
        Write-Error "This is not a git repository."
        return $null
    }
    
    $remoteUrl = git config --get remote.origin.url
    
    if (-not $remoteUrl) {
        Write-Error "No remote origin URL found."
        return $null
    }
    
    return $remoteUrl
}

# Check if the current directory is a Git repository
function Test-IsGitRepository {
    return (Test-Path -Path ".git")
}

# Open the Git origin URL in a browse
function Open-GitOriginUrl {
	if (Test-IsGitRepository) {
		$gitOriginUrl = Get-GitOriginUrl
		
		if ($gitOriginUrl) {
			Open-UrlInBrowser -url $gitOriginUrl
		}
	} else {
		Write-Error "You are not in a git repository."
	}
}

function Log-GitCommits() {
	git log --pretty=format:%h,%an,%aD,%s > ./GitLog.csv
}

function Update-GitRemote {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$remoteUrl
    )

    # Check if inside a git repository
    if (-not (Test-Path ".git")) {
        Write-Error "This directory is not a Git repository."
        return
    }

    Write-Host "Removing existing origin (if any)..." -ForegroundColor Yellow
    git remote remove origin 2>$null

    Write-Host "Adding new origin: $remoteUrl" -ForegroundColor Yellow
    git remote add origin $remoteUrl

    Write-Host "Pushing all branches to new origin..." -ForegroundColor Green
    git push -u origin --all

    Write-Host "Pushing all tags..." -ForegroundColor Green
    git push origin --tags

    Write-Host "Remote updated and code pushed to Azure DevOps." -ForegroundColor Cyan
}

#--------------------------------------------------------------------#

### PYTHON FUNCTIONS ###

# Alias for opening Jupyter Notebook
set-alias jpt openJupyter

# Open Jupyter Notebook
function openJupyter() {
	jupyter notebook
}

#--------------------------------------------------------------------#

### .NET FUNCTIONS ###

# Alias for copying .NET solution
set-alias dotnetcopy Copy-DotNetSolution

# Copy .NET solution to a new location
function Copy-DotNetSolution {
    param (
        [Parameter(Mandatory = $false)]
        [Alias("h", "help")]
        [switch]$DisplayHelp,

        [Parameter(Mandatory = $false)]
        [string]$sourceDirectory,

        [Parameter(Mandatory = $false)]
        [string]$targetDirectory,

        [Parameter(Mandatory = $false)]
        [string]$solutionName,

        [Parameter(Mandatory = $false)]
        [Alias("log")]
        [switch]$Logging
    )

    if ($DisplayHelp) {
        Write-Output "Usage: Copy-DotNetSolution [-sourceDirectory] <String> [-targetDirectory] <String> [-solutionName] <String> [-log]"
        Write-Output "Copy .NET solution and project directories based on the specified solution file."
        Write-Output "Parameters:"
        Write-Output "  -sourceDirectory  Specifies the source directory where the solution file is located."
        Write-Output "  -targetDirectory  Specifies the target directory where the files will be copied."
        Write-Output "  -solutionName     Specifies the name of the solution file to use as the basis for copying."
        Write-Output "  -log              Enables verbose output."
        Write-Output "  -help             Shows this help message."
        return
    }

    if ($Logging) {
        $VerbosePreference = 'Continue'
    } else {
        $VerbosePreference = 'SilentlyContinue'
    }

    Write-Verbose "Logging..."

    if ([string]::IsNullOrWhiteSpace($sourceDirectory) -or [string]::IsNullOrWhiteSpace($targetDirectory) -or [string]::IsNullOrWhiteSpace($solutionName)) {
        Write-Error "All parameters (sourceDirectory, targetDirectory, and solutionName) are required. Use -help for more information."
        return
    }

    $solutionPath = Join-Path -Path $sourceDirectory -ChildPath $solutionName
    if (-Not (Test-Path -Path $solutionPath)) {
        throw "Solution file '$solutionName' not found in the source directory '$sourceDirectory'."
    }

    Remove-Item -Path $targetDirectory -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
    Robocopy "$sourceDirectory" "$targetDirectory" "$solutionName" /COPYALL /R:0 /W:0 /NJH /NJS /NDL > $null

    $solutionContent = Get-Content -Path $solutionPath
    $projRegex = 'Project\("\{[A-F0-9-]+\}"\) = "[^"]*", "([^"]*\.(cs|vb|fs)proj)", "\{[A-F0-9-]+\}"'
    $projectPaths = [regex]::Matches($solutionContent, $projRegex) | ForEach-Object {
        Join-Path -Path $sourceDirectory -ChildPath $_.Groups[1].Value.Replace("\\", "\")
    }

    $totalProjects = $projectPaths.Count
    $currentProject = 0
    $projectDirectoriesCopied = @{}

    foreach ($projPath in $projectPaths) {
        $currentProject++
        $projectDir = Split-Path -Path $projPath -Parent
        $parentDir = Split-Path -Path $projectDir -Parent

        while ($parentDir -and $parentDir.Trim('\\') -ne $sourceDirectory.Trim('\\')) {
            $projectDir = $parentDir
            $parentDir = Split-Path -Path $projectDir -Parent
        }

        $relativeProjectPath = $projectDir.Substring($sourceDirectory.Length).TrimStart('\')
        $destProjectDir = Join-Path -Path $targetDirectory -ChildPath $relativeProjectPath

        if (-not $projectDirectoriesCopied.ContainsKey($projectDir)) {
            Write-Progress -Activity "Copying .NET Projects" -Status "Copying $(Split-Path -Path $projPath -Leaf)" -PercentComplete ($currentProject / $totalProjects * 100)
            Write-Verbose "Copying $(Split-Path -Path $projPath -Leaf) to $targetDirectory..."

            New-Item -ItemType Directory -Force -Path $destProjectDir | Out-Null
            Robocopy $projectDir $destProjectDir /E /COPYALL /R:0 /W:0 /NJH /NJS /NDL > $null
            $projectDirectoriesCopied.Add($projectDir, $true)
        }
    }
	
    Write-Progress -Id 1 -Activity "Copy Complete" -Status "Operation Completed" -Completed
    Write-Verbose "All projects have been successfully copied to $targetDirectory."
}

#--------------------------------------------------------------------#

### CHOCOLATEY PROFILE ###
# This loads Chocolatey's tab completion for PowerShell
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
