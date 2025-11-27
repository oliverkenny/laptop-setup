# PowerShell Profile v2.3.1 #
#---------------------------#
# Auto-generated profile with custom configuration

### GLOBAL VARIABLES ###
# Configured during setup
$RootRepo = "{{ROOTREPO}}"      # The directory that PowerShell navigates to on startup
$ReposPath = "{{REPOSPATH}}"    # The directory where your repositories are cloned
$ScriptPath = "{{SCRIPTPATH}}"  # The directory that holds your external PowerShell scripts

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
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/peru.omp.json' | Invoke-Expression
    }
    if ($RootRepo -and (Test-Path $RootRepo)) {
        Set-Location $RootRepo
    }
    Clear-Host
}
# Run the initialization function
initPowershell

#--------------------------------------------------------------------#

### UTILITY FUNCTIONS ###

# Navigate to the repository folder
function goToRepositoryFolder {
    if ($ReposPath -and (Test-Path $ReposPath)) {
        Set-Location $ReposPath
    } else {
        Write-Host "Repository path not configured or doesn't exist: $ReposPath" -ForegroundColor Yellow
    }
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
    if (Get-Command notepad++ -ErrorAction SilentlyContinue) {
        start notepad++ $path
    } else {
        Write-Host "Notepad++ not found. Opening in notepad..." -ForegroundColor Yellow
        notepad $path
    }
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
            Write-Verbose "Opened Obsidian with current directory path: $currentPath"
        }
        elseif (Test-Path $Path) {
            # Case 3: Valid file or directory path
            $resolvedPath = (Resolve-Path $Path).Path
            $encodedPath = [uri]::EscapeDataString($resolvedPath)
            $fullUri = "$baseUri?path=$encodedPath"
            Start-Process $fullUri
            Write-Verbose "Opened Obsidian with resolved path: $resolvedPath"
        }
        else {
            # Case 4: Invalid path
            Write-Warning "The specified path does not exist: $Path"
        }
    }
    catch {
        Write-Error "Failed to open Obsidian: $($_.Exception.Message)"
    }
}

# Extract files to same folder functionality
function extractIntoSameFolder {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        $destination = Split-Path $FilePath -Parent
        Expand-Archive -Path $FilePath -DestinationPath $destination -Force
        Write-Host "Extracted to: $destination"
    } else {
        Write-Host "File not found: $FilePath" -ForegroundColor Red
    }
}

# Find files by extension
function findFilesByExtension {
    param([string]$Extension)
    Get-ChildItem -Recurse -Filter "*$Extension"
}

# Enhanced tree view
function Show-Tree {
    param([string]$Path = ".", [int]$Depth = 3)
    Get-ChildItem $Path -Recurse -Depth $Depth | ForEach-Object {
        $indent = "  " * ($_.FullName.Split([IO.Path]::DirectorySeparatorChar).Length - (Resolve-Path $Path).Path.Split([IO.Path]::DirectorySeparatorChar).Length)
        "$indent$($_.Name)"
    }
}

# Copy flat folder structure
function Copy-FlatFolder {
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force
    }
    Get-ChildItem $Source -Recurse -File | ForEach-Object {
        Copy-Item $_.FullName -Destination $Destination
    }
}

# Markdown to PDF conversion (requires pandoc)
function Convert-MarkdownToPDF {
    param([string]$InputFile)
    if (Get-Command pandoc -ErrorAction SilentlyContinue) {
        $outputFile = $InputFile.Replace('.md', '.pdf')
        pandoc $InputFile -o $outputFile
        Write-Host "Converted: $outputFile"
    } else {
        Write-Host "Pandoc not installed. Please install pandoc to use this function." -ForegroundColor Red
    }
}

# Convert all markdown files to PDF
function Convert-AllMarkdownToPDF {
    Get-ChildItem -Filter "*.md" | ForEach-Object {
        Convert-MarkdownToPDF $_.Name
    }
}

#--------------------------------------------------------------------#

### CHOCOLATEY PROFILE ###
# This loads Chocolatey's tab completion for PowerShell
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}