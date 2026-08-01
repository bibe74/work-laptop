<#
.SYNOPSIS
    Exports a markdown file to OneNote as a new page.

.DESCRIPTION
    This script reads a markdown file and creates a new page in OneNote with the content.
    Uses OneNote COM automation to create the page.

.PARAMETER MarkdownFile
    Path to the markdown file to export.

.PARAMETER NotebookName
    Name of the OneNote notebook to create the page in.

.PARAMETER SectionName
    Name of the section within the notebook. Default is "Installation Checklists".

.PARAMETER PageTitle
    Title for the OneNote page. If not specified, uses the filename.

.EXAMPLE
    .\Export-ToOneNote.ps1 -MarkdownFile "INSTALL-20260525.md" -NotebookName "Work Laptop Setup"

.NOTES
    Requires OneNote to be installed on the system.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$MarkdownFile,
    
    [Parameter(Mandatory = $true)]
    [string]$NotebookName,
    
    [Parameter(Mandatory = $false)]
    [string]$SectionName = "Installation Checklists",
    
    [Parameter(Mandatory = $false)]
    [string]$PageTitle
)

# Check if markdown file exists
if (-not (Test-Path $MarkdownFile)) {
    Write-Error "Markdown file not found: $MarkdownFile"
    exit 1
}

# Read markdown content
$markdownContent = Get-Content -Path $MarkdownFile -Raw

# Set page title if not provided
if (-not $PageTitle) {
    $PageTitle = [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile)
}

try {
    Write-Host "Connecting to OneNote..." -ForegroundColor Cyan
    
    # Create OneNote COM object
    $oneNote = New-Object -ComObject OneNote.Application
    
    # Get notebooks hierarchy
    [xml]$hierarchy = ""
    $oneNote.GetHierarchy("", [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsNotebooks, [ref]$hierarchy)
    
    # Find or create notebook
    $notebook = $hierarchy.Notebooks.Notebook | Where-Object { $_.name -eq $NotebookName }
    
    if (-not $notebook) {
        Write-Host "Notebook '$NotebookName' not found. Please create it in OneNote first." -ForegroundColor Yellow
        Write-Host "Available notebooks:" -ForegroundColor Yellow
        $hierarchy.Notebooks.Notebook | ForEach-Object { Write-Host "  - $($_.name)" -ForegroundColor Gray }
        exit 1
    }
    
    Write-Host "Found notebook: $NotebookName" -ForegroundColor Green
    
    # Get sections in notebook
    [xml]$sectionsHierarchy = ""
    $oneNote.GetHierarchy($notebook.ID, [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsSections, [ref]$sectionsHierarchy)
    
    # Find or create section
    $section = $sectionsHierarchy.Notebook.Section | Where-Object { $_.name -eq $SectionName }
    
    if (-not $section) {
        Write-Host "Creating section: $SectionName" -ForegroundColor Cyan
        # Create new section
        $sectionID = ""
        $oneNote.OpenHierarchy($notebook.path + "\$SectionName.one", "", [ref]$sectionID, [Microsoft.Office.InterOp.OneNote.CreateFileType]::cftSection)
        Start-Sleep -Seconds 1
        
        # Refresh hierarchy
        $oneNote.GetHierarchy($notebook.ID, [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsSections, [ref]$sectionsHierarchy)
        $section = $sectionsHierarchy.Notebook.Section | Where-Object { $_.name -eq $SectionName }
    }
    
    Write-Host "Using section: $SectionName" -ForegroundColor Green
    
    # Create new page
    Write-Host "Creating page: $PageTitle" -ForegroundColor Cyan
    $pageID = ""
    $oneNote.CreateNewPage($section.ID, [ref]$pageID)
    
    # Get page XML
    [xml]$pageXml = ""
    $oneNote.GetPageContent($pageID, [ref]$pageXml)
    
    # Convert markdown to HTML (basic conversion)
    $htmlContent = $markdownContent `
        -replace '(?m)^### (.+)$', '<h3>$1</h3>' `
        -replace '(?m)^## (.+)$', '<h2>$1</h2>' `
        -replace '(?m)^# (.+)$', '<h1>$1</h1>' `
        -replace '(?m)^\*\*(.+?)\*\*', '<strong>$1</strong>' `
        -replace '(?m)^- \[ \] (.+)$', '<input type="checkbox"/> $1' `
        -replace '(?m)^- \[x\] (.+)$', '<input type="checkbox" checked/> $1' `
        -replace '(?m)^  - \[ \] (.+)$', '&nbsp;&nbsp;<input type="checkbox"/> $1' `
        -replace '(?m)^  - \[x\] (.+)$', '&nbsp;&nbsp;<input type="checkbox" checked/> $1' `
        -replace '`([^`]+)`', '<code>$1</code>' `
        -replace '\n', '<br/>'
    
    # Update page title and content
    $pageXml.Page.Title.OE.T.InnerText = $PageTitle
    
    # Create content outline element
    $ns = $pageXml.DocumentElement.NamespaceURI
    $outline = $pageXml.CreateElement("Outline", $ns)
    $oeContainer = $pageXml.CreateElement("OEChildren", $ns)
    $oe = $pageXml.CreateElement("OE", $ns)
    $htmlData = $pageXml.CreateElement("T", $ns)
    $htmlData.InnerXml = "<![CDATA[$htmlContent]]>"
    
    $oe.AppendChild($htmlData)
    $oeContainer.AppendChild($oe)
    $outline.AppendChild($oeContainer)
    $pageXml.Page.AppendChild($outline)
    
    # Update page in OneNote
    $oneNote.UpdatePageContent($pageXml.OuterXml)
    
    # Navigate to the page
    $oneNote.NavigateTo($pageID)
    
    Write-Host "✅ Successfully created OneNote page!" -ForegroundColor Green
    Write-Host "  Notebook: $NotebookName" -ForegroundColor Cyan
    Write-Host "  Section: $SectionName" -ForegroundColor Cyan
    Write-Host "  Page: $PageTitle" -ForegroundColor Cyan
    
} catch {
    Write-Error "Failed to create OneNote page: $_"
    Write-Host "Make sure OneNote is installed and you have the specified notebook created." -ForegroundColor Yellow
    exit 1
} finally {
    # Release COM object
    if ($oneNote) {
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($oneNote) | Out-Null
    }
}
