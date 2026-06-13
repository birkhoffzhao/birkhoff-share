# File Organizer Script (PowerShell Version)
# Author: Zhao Hui
# Date: 2026-06-13

# ==================== Configuration ====================

# Source folder path
$SOURCE_FOLDER = "C:\Users\birkhoffzhao\Desktop\处置\处置\附件材料"

# Target folder path (null means create categories inside source folder)
$TARGET_FOLDER = $null

# Category rules: extension -> folder name
$CATEGORY_RULES = @{
    # Images
    ".jpg"  = "Images"
    ".jpeg" = "Images"
    ".png"  = "Images"
    ".gif"  = "Images"
    ".bmp"  = "Images"
    ".webp" = "Images"
    ".svg"  = "Images"
    ".ico"  = "Images"

    # Documents
    ".pdf"  = "Documents"
    ".doc"  = "Documents"
    ".docx" = "Documents"
    ".txt"  = "Documents"
    ".xls"  = "Documents"
    ".xlsx" = "Documents"
    ".ppt"  = "Documents"
    ".pptx" = "Documents"
    ".md"   = "Documents"

    # Archives
    ".zip" = "Archives"
    ".rar" = "Archives"
    ".7z"  = "Archives"
    ".tar" = "Archives"
    ".gz"  = "Archives"

    # Code
    ".py"   = "Code"
    ".js"   = "Code"
    ".ts"   = "Code"
    ".html" = "Code"
    ".css"  = "Code"
    ".json" = "Code"
    ".xml"  = "Code"
    ".java" = "Code"
    ".c"    = "Code"
    ".cpp"  = "Code"
    ".h"    = "Code"

    # Audio
    ".mp3"  = "Audio"
    ".wav"  = "Audio"
    ".flac" = "Audio"
    ".aac"  = "Audio"
    ".m4a"  = "Audio"

    # Video
    ".mp4"  = "Video"
    ".avi"  = "Video"
    ".mkv"  = "Video"
    ".mov"  = "Video"
    ".wmv"  = "Video"

    # Executables
    ".exe" = "Programs"
    ".msi" = "Programs"
    ".bat" = "Programs"
    ".cmd" = "Programs"
    ".sh"  = "Programs"
}

# Default category for unmatched extensions
$DEFAULT_CATEGORY = "Others"

# ==================== Main Script ====================

function Get-Category {
    param ([string]$Extension)

    $ext = $Extension.ToLower()
    if ($CATEGORY_RULES.ContainsKey($ext)) {
        return $CATEGORY_RULES[$ext]
    }
    return $DEFAULT_CATEGORY
}

function Get-UniqueDestination {
    param (
        [string]$SourceFile,
        [string]$TargetDir
    )

    $fileName = [System.IO.Path]::GetFileName($SourceFile)
    $targetPath = Join-Path $TargetDir $fileName

    if (-not (Test-Path $targetPath)) {
        return $targetPath
    }

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
    $extension = [System.IO.Path]::GetExtension($SourceFile)
    $counter = 1

    while (Test-Path $targetPath) {
        $newName = "${baseName}_${counter}${extension}"
        $targetPath = Join-Path $TargetDir $newName
        $counter++
    }

    Write-Host "  -> Renamed duplicate: $newName" -ForegroundColor Yellow
    return $targetPath
}

function Move-FileSafe {
    param (
        [string]$SourcePath,
        [string]$TargetDir
    )

    try {
        if (-not (Test-Path $TargetDir)) {
            New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        }

        $targetPath = Get-UniqueDestination -SourceFile $SourcePath -TargetDir $TargetDir
        Move-Item -Path $SourcePath -Destination $targetPath -Force

        $folderName = [System.IO.Path]::GetFileName($TargetDir)
        $fileName = [System.IO.Path]::GetFileName($SourcePath)
        Write-Host "[OK] Moved: $fileName -> $folderName/" -ForegroundColor Green
        return $true
    }
    catch {
        $fileName = [System.IO.Path]::GetFileName($SourcePath)
        Write-Host "[FAIL] $fileName - $_" -ForegroundColor Red
        return $false
    }
}

function Invoke-FileOrganizer {
    param (
        [string]$SourceFolder,
        [string]$TargetFolder
    )

    if (-not (Test-Path $SourceFolder)) {
        Write-Host "ERROR: Source folder not found: $SourceFolder" -ForegroundColor Red
        return
    }

    if ($TargetFolder) {
        $targetPath = $TargetFolder
    } else {
        $targetPath = $SourceFolder
    }

    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "Source: $SourceFolder"
    Write-Host "Target: $targetPath"
    Write-Host "============================================================" -ForegroundColor Cyan

    $stats = @{ Total = 0; Success = 0; Failed = 0 }
    $categoryStats = @{}

    $files = Get-ChildItem -Path $SourceFolder -File -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        try {
            $stats.Total++

            $category = Get-Category -Extension $file.Extension
            $targetDir = Join-Path $targetPath $category

            if (Move-FileSafe -SourcePath $file.FullName -TargetDir $targetDir) {
                $stats.Success++
                if ($categoryStats.ContainsKey($category)) {
                    $categoryStats[$category]++
                } else {
                    $categoryStats[$category] = 1
                }
            } else {
                $stats.Failed++
            }
        }
        catch {
            Write-Host "Error processing: $($file.Name) - $_" -ForegroundColor Red
            $stats.Failed++
        }
    }

    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "Done! Statistics:"
    Write-Host "  Total files: $($stats.Total)"
    Write-Host "  Successfully moved: $($stats.Success)" -ForegroundColor Green
    Write-Host "  Failed: $($stats.Failed)" -ForegroundColor $(if ($stats.Failed -gt 0) { "Red" } else { "Green" })

    if ($categoryStats.Count -gt 0) {
        Write-Host ""
        Write-Host "By category:"
        foreach ($cat in $categoryStats.Keys | Sort-Object) {
            Write-Host "  $cat`: $($categoryStats[$cat]) files"
        }
    }

    Write-Host "============================================================" -ForegroundColor Cyan
}

# Main
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "File Organizer (PowerShell Version)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

try {
    Invoke-FileOrganizer -SourceFolder $SOURCE_FOLDER -TargetFolder $TARGET_FOLDER
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace
}

Write-Host ""
