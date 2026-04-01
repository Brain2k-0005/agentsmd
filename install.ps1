#Requires -Version 5.1
<#
.SYNOPSIS
    Autonomous Agent Setup — Configure AI CLI tools for autonomous coding.

.DESCRIPTION
    Interactive installer for global AI CLI configs and project templates.
    Supports Claude Code, Codex, and Gemini CLI.

.PARAMETER DryRun
    Show what would happen without writing any files.

.EXAMPLE
    .\install.ps1
    .\install.ps1 -DryRun
#>
[CmdletBinding()]
param(
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Color helpers
# ---------------------------------------------------------------------------
function Write-Info    { param([string]$Msg) Write-Host $Msg -ForegroundColor Cyan }
function Write-Success { param([string]$Msg) Write-Host $Msg -ForegroundColor Green }
function Write-Warn    { param([string]$Msg) Write-Host "WARNING: $Msg" -ForegroundColor Yellow }
function Write-Err     { param([string]$Msg) Write-Host "ERROR: $Msg" -ForegroundColor Red }
function Write-Bold    { param([string]$Msg) Write-Host $Msg -ForegroundColor White }

function Write-DryRun  { param([string]$Msg) Write-Host "[DRY RUN] $Msg" -ForegroundColor Yellow }

# ---------------------------------------------------------------------------
# Resolve repo root (directory where this script lives)
# ---------------------------------------------------------------------------
$ScriptDir  = $PSScriptRoot
$GlobalDir  = Join-Path $ScriptDir 'global'
$ProjectDir = Join-Path $ScriptDir 'project'

# ---------------------------------------------------------------------------
# Backup helper
# ---------------------------------------------------------------------------
function Backup-File {
    param([string]$Target)

    if (Test-Path $Target -PathType Leaf) {
        $Stamp  = (Get-Date -Format 'yyyyMMdd_HHmmss')
        $Backup = "${Target}.backup.${Stamp}"
        if ($DryRun) {
            Write-DryRun "Would backup: $Target -> $Backup"
        } else {
            Copy-Item -Path $Target -Destination $Backup -Force
            Write-Warn "  Backed up: $Target -> $Backup"
        }
    }
}

# ---------------------------------------------------------------------------
# Copy-File wrapper with dry-run support
# ---------------------------------------------------------------------------
function Copy-FileInstall {
    param(
        [string]$Source,
        [string]$Destination
    )

    if ($DryRun) {
        Write-DryRun "Would copy: $Source -> $Destination"
    } else {
        Copy-Item -Path $Source -Destination $Destination -Force
        Write-Success "  Copied: $Source -> $Destination"
    }
}

# ---------------------------------------------------------------------------
# Ensure-Dir wrapper with dry-run support
# ---------------------------------------------------------------------------
function Ensure-Dir {
    param([string]$Path)

    if ($DryRun) {
        Write-DryRun "Would ensure directory exists: $Path"
    } else {
        if (-not (Test-Path $Path -PathType Container)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }
    }
}

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
function Print-Banner {
    Write-Host ""
    Write-Bold "============================================================"
    Write-Bold " Autonomous Agent Setup"
    Write-Bold " Configure AI CLI tools for autonomous coding"
    Write-Bold "============================================================"
    if ($DryRun) {
        Write-Warn "Dry-run mode enabled — no files will be written."
    }
    Write-Host ""
}

# ---------------------------------------------------------------------------
# Option 1: Install global configs
# ---------------------------------------------------------------------------
function Install-Global {
    Write-Info "--- Installing global config ---"

    $HomeDir   = $env:USERPROFILE
    if (-not $HomeDir) { $HomeDir = $env:HOME }  # fallback for pwsh on Linux/macOS

    $ClaudeDir = Join-Path $HomeDir '.claude'
    $CodexDir  = Join-Path $HomeDir '.codex'
    $GeminiDir = Join-Path $HomeDir '.gemini'

    $ClaudeDetected = Test-Path $ClaudeDir -PathType Container
    $CodexDetected  = Test-Path $CodexDir  -PathType Container
    $GeminiDetected = Test-Path $GeminiDir -PathType Container

    if (-not $ClaudeDetected -and -not $CodexDetected -and -not $GeminiDetected) {
        Write-Warn "No AI tool config directories detected (~/.claude, ~/.codex, ~/.gemini)."
        Write-Warn "Creating ~/.claude as a fallback."
        Ensure-Dir $ClaudeDir
        $ClaudeDetected = $true
    }

    # ---- AGENTS.md ----
    $AgentsSrc = Join-Path $GlobalDir 'AGENTS.md'
    if (-not (Test-Path $AgentsSrc -PathType Leaf)) {
        Write-Err "Source file not found: $AgentsSrc"
        return
    }

    if ($ClaudeDetected) {
        Ensure-Dir $ClaudeDir
        Backup-File (Join-Path $ClaudeDir 'AGENTS.md')
        Copy-FileInstall $AgentsSrc (Join-Path $ClaudeDir 'AGENTS.md')
    }

    if ($CodexDetected) {
        Ensure-Dir $CodexDir
        Backup-File (Join-Path $CodexDir 'AGENTS.md')
        Copy-FileInstall $AgentsSrc (Join-Path $CodexDir 'AGENTS.md')
    }

    if ($GeminiDetected) {
        Ensure-Dir $GeminiDir
        Backup-File (Join-Path $GeminiDir 'AGENTS.md')
        Copy-FileInstall $AgentsSrc (Join-Path $GeminiDir 'AGENTS.md')
    }

    # ---- CLAUDE.md ----
    if ($ClaudeDetected) {
        $ClaudeMdSrc = Join-Path $GlobalDir 'CLAUDE.md'
        if (Test-Path $ClaudeMdSrc -PathType Leaf) {
            Backup-File (Join-Path $ClaudeDir 'CLAUDE.md')
            Copy-FileInstall $ClaudeMdSrc (Join-Path $ClaudeDir 'CLAUDE.md')
        } else {
            Write-Warn "global/CLAUDE.md not found — skipping."
        }
    }

    # ---- GEMINI.md ----
    if ($GeminiDetected) {
        $GeminiMdSrc = Join-Path $GlobalDir 'GEMINI.md'
        if (Test-Path $GeminiMdSrc -PathType Leaf) {
            Backup-File (Join-Path $GeminiDir 'GEMINI.md')
            Copy-FileInstall $GeminiMdSrc (Join-Path $GeminiDir 'GEMINI.md')
        } else {
            Write-Warn "global/GEMINI.md not found — skipping."
        }
    }

    Write-Success "Global config install complete."
    Write-Host ""
}

# ---------------------------------------------------------------------------
# Option 2: Install project template
# ---------------------------------------------------------------------------
function Install-Project {
    Write-Info "--- Installing project template ---"

    $Cwd = (Get-Location).Path

    # Normalize paths for comparison (resolve trailing slashes, casing on Windows)
    $NormalizedCwd    = $Cwd.TrimEnd('\', '/').ToLower()
    $NormalizedScript = $ScriptDir.TrimEnd('\', '/').ToLower()

    if ($NormalizedCwd -eq $NormalizedScript) {
        Write-Err "You are running from inside the setup repo itself."
        Write-Err "Change to your project directory first, then re-run this script."
        return
    }

    $Src = Join-Path $ProjectDir 'AGENTS.md'
    if (-not (Test-Path $Src -PathType Leaf)) {
        Write-Err "Source file not found: $Src"
        return
    }

    $Dst = Join-Path $Cwd 'AGENTS.md'
    Backup-File $Dst
    Copy-FileInstall $Src $Dst

    Write-Success "Project template install complete."
    Write-Host ""
}

# ---------------------------------------------------------------------------
# Option 3: Install Claude Code settings
# ---------------------------------------------------------------------------
function Install-Settings {
    Write-Info "--- Installing Claude Code settings ---"

    $HomeDir   = $env:USERPROFILE
    if (-not $HomeDir) { $HomeDir = $env:HOME }

    $ClaudeDir = Join-Path $HomeDir '.claude'
    $Src       = Join-Path $GlobalDir 'claude-settings.json'

    if (-not (Test-Path $Src -PathType Leaf)) {
        Write-Err "Source file not found: $Src"
        return
    }

    Ensure-Dir $ClaudeDir
    Backup-File (Join-Path $ClaudeDir 'settings.json')
    Copy-FileInstall $Src (Join-Path $ClaudeDir 'settings.json')

    Write-Warn "This REPLACES your existing settings.json (backup was created)."
    Write-Warn "If you have custom permissions, consider manually merging instead."
    Write-Warn "Review permissions before using. See README for details."

    Write-Success "Claude Code settings install complete."
    Write-Host ""
}

# ---------------------------------------------------------------------------
# Menu
# ---------------------------------------------------------------------------
function Print-Menu {
    Write-Host ""
    Write-Bold "What would you like to install?"
    Write-Host "  [1] Global config (AGENTS.md + tool-specific configs)"
    Write-Host "  [2] Project template (copy AGENTS.md to current project)"
    Write-Host "  [3] Claude Code settings (auto mode, permissions, plugins)"
    Write-Host "  [4] All of the above"
    Write-Host ""
    Write-Host -NoNewline "Enter choice [1-4]: "
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
function Main {
    Print-Banner
    Print-Menu

    $Choice = Read-Host

    Write-Host ""

    $InstalledItems = [System.Collections.Generic.List[string]]::new()

    switch ($Choice.Trim()) {
        '1' {
            Install-Global
            $InstalledItems.Add('Global config (AGENTS.md + tool-specific configs)')
        }
        '2' {
            Install-Project
            $InstalledItems.Add("Project template (AGENTS.md -> $((Get-Location).Path)\AGENTS.md)")
        }
        '3' {
            Install-Settings
            $InstalledItems.Add('Claude Code settings (~/.claude/settings.json)')
        }
        '4' {
            Install-Global
            $InstalledItems.Add('Global config (AGENTS.md + tool-specific configs)')
            Install-Project
            $InstalledItems.Add("Project template (AGENTS.md -> $((Get-Location).Path)\AGENTS.md)")
            Install-Settings
            $InstalledItems.Add('Claude Code settings (~/.claude/settings.json)')
        }
        default {
            Write-Err "Invalid choice: '$Choice'. Please enter 1, 2, 3, or 4."
            exit 1
        }
    }

    # Summary
    Write-Bold "============================================================"
    Write-Bold " Installation Summary"
    Write-Bold "============================================================"

    if ($InstalledItems.Count -eq 0) {
        Write-Warn "Nothing was installed."
    } else {
        foreach ($Item in $InstalledItems) {
            Write-Success "  + $Item"
        }
    }

    if ($DryRun) {
        Write-Warn "Dry-run mode was active — no files were written."
    }

    Write-Host ""
}

Main
