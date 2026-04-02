#Requires -Version 5.1
<#
.SYNOPSIS
    agentsmd Setup - Configure AI CLI tools for autonomous coding.

.DESCRIPTION
    Interactive installer for global AI CLI configs and project templates.
    Supports Claude Code, Codex, Gemini CLI, and stack presets for project AGENTS.md.

.PARAMETER DryRun
    Show what would happen without writing any files.

.PARAMETER Preset
    Force a specific project preset instead of auto-detecting.

.PARAMETER All
    Install global config, project template, and Claude settings in one run.

.PARAMETER ListPresets
    Print the available project presets and exit.

.PARAMETER EnableModules
    Comma-separated list of module names to keep. All other modules are removed.
    Mutually exclusive with DisableModules.

.PARAMETER DisableModules
    Comma-separated list of module names to remove. All other modules are kept.
    Mutually exclusive with EnableModules.

.EXAMPLE
    .\install.ps1
    .\install.ps1 -DryRun
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [string]$Preset,
    [switch]$All,
    [switch]$ListPresets,
    [string]$EnableModules,
    [string]$DisableModules
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info    { param([string]$Msg) Write-Host $Msg -ForegroundColor Cyan }
function Write-Success { param([string]$Msg) Write-Host $Msg -ForegroundColor Green }
function Write-Warn    { param([string]$Msg) Write-Host "WARNING: $Msg" -ForegroundColor Yellow }
function Write-Err     { param([string]$Msg) Write-Host "ERROR: $Msg" -ForegroundColor Red }
function Write-Bold    { param([string]$Msg) Write-Host $Msg -ForegroundColor White }
function Write-DryRun  { param([string]$Msg) Write-Host "[DRY RUN] $Msg" -ForegroundColor Yellow }

$ScriptDir   = $PSScriptRoot
$GlobalDir   = Join-Path $ScriptDir 'global'
$ProjectDir  = Join-Path $ScriptDir 'project'
$PresetDir   = Join-Path $ProjectDir 'presets'

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

function Write-RenderedFile {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$PackageManager
    )

    if ($DryRun) {
        if ([string]::IsNullOrWhiteSpace($PackageManager)) {
            Write-DryRun "Would copy: $Source -> $Destination"
        } else {
            Write-DryRun "Would render $PackageManager commands: $Source -> $Destination"
        }
        return
    }

    $Content = Get-Content -Path $Source -Raw
    $Rendered = Get-RenderedPresetContent -Content $Content -PackageManager $PackageManager
    $Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Destination, $Rendered, $Utf8NoBom)

    if ([string]::IsNullOrWhiteSpace($PackageManager)) {
        Write-Success "  Copied: $Source -> $Destination"
    } else {
        Write-Success "  Rendered $PackageManager commands: $Source -> $Destination"
    }
}

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

$script:ValidModules = @('agent-teams', 'quality-gates', 'code-review', 'tdd', 'skill-discovery', 'token-efficiency')

if ($EnableModules -and $DisableModules) {
    Write-Err "-EnableModules and -DisableModules are mutually exclusive."
    exit 1
}

function Test-ModuleNames {
    param([string]$ModulesCsv)

    $Names = $ModulesCsv -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
    foreach ($Name in $Names) {
        if ($script:ValidModules -notcontains $Name) {
            Write-Err "Unknown module name: '$Name'"
            Write-Err "Valid modules: $($script:ValidModules -join ', ')"
            exit 1
        }
    }
}

function Filter-Modules {
    param(
        [string]$FilePath,
        [string]$Mode,
        [string]$ModulesCsv
    )

    if ($DryRun) {
        Write-DryRun "Would filter modules ($Mode`: $ModulesCsv) in $FilePath"
        return
    }

    if (-not (Test-Path $FilePath -PathType Leaf)) {
        Write-Warn "Cannot filter modules: file not found: $FilePath"
        return
    }

    Test-ModuleNames $ModulesCsv

    $Content = Get-Content -Path $FilePath -Raw

    $ModuleList = $ModulesCsv -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }

    if ($Mode -eq 'disable') {
        # Remove blocks for each listed module
        foreach ($Mod in $ModuleList) {
            $Pattern = "(?s)\r?\n?<!-- MODULE: $([regex]::Escape($Mod)) -->.*?<!-- /MODULE: $([regex]::Escape($Mod)) -->"
            $Content = [regex]::Replace($Content, $Pattern, '')
        }
    }
    elseif ($Mode -eq 'enable') {
        # Remove all module blocks EXCEPT those in the list
        foreach ($Valid in $script:ValidModules) {
            if ($ModuleList -notcontains $Valid) {
                $Pattern = "(?s)\r?\n?<!-- MODULE: $([regex]::Escape($Valid)) -->.*?<!-- /MODULE: $([regex]::Escape($Valid)) -->"
                $Content = [regex]::Replace($Content, $Pattern, '')
            }
        }
    }

    $Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($FilePath, $Content, $Utf8NoBom)
    Write-Info "  Filtered modules ($Mode`: $ModulesCsv) in $FilePath"
}

function Print-Banner {
    Write-Host ""
    Write-Bold "============================================================"
    Write-Bold " agentsmd Setup"
    Write-Bold " Configure AI CLI tools for autonomous coding"
    Write-Bold "============================================================"
    if ($DryRun) {
        Write-Warn "Dry-run mode enabled - no files will be written."
    }
    Write-Host ""
}

function Get-AvailablePresets {
    $names = @()
    if (Test-Path $PresetDir -PathType Container) {
        $names = Get-ChildItem -Path $PresetDir -Directory | ForEach-Object { $_.Name }
    }
    return @($names)
}

function Print-PresetCatalog {
    $Available = Get-AvailablePresets | Sort-Object
    Write-Bold "Available presets"
    foreach ($PresetName in $Available) {
        Write-Host "  $PresetName"
    }
    Write-Host ""
}

function Get-PresetPath {
    param([string]$PresetName)

    return Join-Path (Join-Path $PresetDir $PresetName) 'AGENTS.md'
}

function Get-DetectedPackageManager {
    param([string]$RootPath)

    $PackageJson = Join-Path $RootPath 'package.json'

    if (
        (Test-Path (Join-Path $RootPath 'bun.lockb') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'bunfig.toml') -PathType Leaf)
    ) {
        return 'bun'
    }

    if (Test-Path (Join-Path $RootPath 'pnpm-lock.yaml') -PathType Leaf) {
        return 'pnpm'
    }

    if (Test-Path (Join-Path $RootPath 'yarn.lock') -PathType Leaf) {
        return 'yarn'
    }

    if (Test-Path (Join-Path $RootPath 'package-lock.json') -PathType Leaf) {
        return 'npm'
    }

    if (Test-Path $PackageJson -PathType Leaf) {
        $JsonText = Get-Content -Path $PackageJson -Raw
        if ($JsonText -match '"packageManager"\s*:\s*"bun@') { return 'bun' }
        if ($JsonText -match '"packageManager"\s*:\s*"pnpm@') { return 'pnpm' }
        if ($JsonText -match '"packageManager"\s*:\s*"yarn@') { return 'yarn' }
        if ($JsonText -match '"packageManager"\s*:\s*"npm@') { return 'npm' }
    }

    return $null
}

function Get-RenderedPresetContent {
    param(
        [string]$Content,
        [string]$PackageManager
    )

    switch ($PackageManager) {
        'pnpm' {
            $Content = $Content.Replace('npm install', 'pnpm install')
            $Content = $Content.Replace('npm run ', 'pnpm ')
            $Content = $Content.Replace('npm test', 'pnpm test')
            $Content = $Content.Replace('npx ', 'pnpm exec ')
        }
        'yarn' {
            $Content = $Content.Replace('npm install', 'yarn install')
            $Content = $Content.Replace('npm run ', 'yarn ')
            $Content = $Content.Replace('npm test', 'yarn test')
            $Content = $Content.Replace('npx ', 'yarn exec ')
        }
        'bun' {
            $Content = $Content.Replace('npm install', 'bun install')
            $Content = $Content.Replace('npm run ', 'bun run ')
            $Content = $Content.Replace('npm test', 'bun test')
            $Content = $Content.Replace('npx ', 'bunx ')
        }
    }

    return $Content
}

function Get-DetectedPreset {
    param([string]$RootPath)

    if (
        (Test-Path (Join-Path $RootPath 'bun.lockb') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'bunfig.toml') -PathType Leaf) -or
        (
            (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"packageManager"\s*:\s*"bun@', '"bunx"', '"bun run"' -Quiet -ErrorAction SilentlyContinue)
        )
    ) {
        return 'bun'
    }

    if (
        (Test-Path (Join-Path $RootPath 'deno.json') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'deno.jsonc') -PathType Leaf) -or
        (
            (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"deno task"', '"deno run"', '"deno test"' -Quiet -ErrorAction SilentlyContinue)
        )
    ) {
        return 'deno'
    }

    if (
        (Test-Path (Join-Path $RootPath 'astro.config.mjs') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'astro.config.ts') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'astro.config.js') -PathType Leaf)
    ) {
        return 'astro'
    }

    if (
        (Test-Path (Join-Path $RootPath 'remix.config.js') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'remix.config.ts') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'app\root.tsx') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'app\root.jsx') -PathType Leaf)
    ) {
        return 'remix'
    }

    if (
        (Test-Path (Join-Path $RootPath 'svelte.config.js') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'svelte.config.ts') -PathType Leaf)
    ) {
        return 'svelte'
    }

    if (
        (Test-Path (Join-Path $RootPath 'solid.config.js') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'solid.config.ts') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'src\root.tsx') -PathType Leaf)
    ) {
        return 'solid'
    }

    if (
        (Test-Path (Join-Path $RootPath 'next.config.js') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'next.config.mjs') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'next.config.ts') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'app') -PathType Container) -or
        (Test-Path (Join-Path $RootPath 'src\app') -PathType Container)
    ) {
        return 'nextjs'
    }

    if (Test-Path (Join-Path $RootPath 'angular.json') -PathType Leaf) {
        return 'angular'
    }

    if (
        (Test-Path (Join-Path $RootPath 'pubspec.yaml') -PathType Leaf) -and
        (Test-Path (Join-Path $RootPath 'lib\main.dart') -PathType Leaf)
    ) {
        return 'flutter'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"vue"', '"vue-router"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'src\App.vue') -PathType Leaf)
        )
    ) {
        return 'vue'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"react"', '"react-dom"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'src\App.tsx') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'src\App.jsx') -PathType Leaf)
        )
    ) {
        return 'react'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"solid-start"', '"@solidjs/start"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'src\root.tsx') -PathType Leaf)
        )
    ) {
        return 'solidstart'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"@tanstack/start"', '"@tanstack/react-router"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'tanstack.config.ts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'tanstack.config.js') -PathType Leaf)
        )
    ) {
        return 'tanstack'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"vite"', '"vite dev"', '"vite build"', '"@vitejs/plugin-react"', '"@vitejs/plugin-vue"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'vite.config.ts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'vite.config.js') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'vite.config.mts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'vite.config.mjs') -PathType Leaf)
        )
    ) {
        return 'vite'
    }

    if (
        (Test-Path (Join-Path $RootPath 'src-tauri') -PathType Container) -or
        (Test-Path (Join-Path $RootPath 'tauri.conf.json') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'tauri.conf.json5') -PathType Leaf)
    ) {
        return 'tauri'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"@nestjs/core"', '"nestjs"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'nest-cli.json') -PathType Leaf)
        )
    ) {
        return 'nestjs'
    }

    if (Get-ChildItem -Path $RootPath -Recurse -Filter *.csproj -File -ErrorAction SilentlyContinue | Select-Object -First 1) {
        return 'dotnet'
    }

    if (Get-ChildItem -Path $RootPath -Recurse -Filter *.cs -File -ErrorAction SilentlyContinue | Select-Object -First 1) {
        return 'csharp'
    }

    if (
        (Test-Path (Join-Path $RootPath 'CMakeLists.txt') -PathType Leaf) -or
        (Get-ChildItem -Path $RootPath -Recurse -Include *.cpp,*.cc,*.cxx -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    ) {
        return 'cpp'
    }

    if (Get-ChildItem -Path $RootPath -Recurse -Include *.c -File -ErrorAction SilentlyContinue | Select-Object -First 1) {
        return 'c'
    }

    if (
        (Test-Path (Join-Path $RootPath 'package.json') -PathType Leaf) -and
        -not (
            (Test-Path (Join-Path $RootPath 'next.config.js') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'next.config.mjs') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'next.config.ts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'app') -PathType Container) -or
            (Test-Path (Join-Path $RootPath 'src\app') -PathType Container)
        )
    ) {
        if (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"solid-start"', '"@solidjs/start"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'src\root.tsx') -PathType Leaf)
        ) {
            return 'solidstart'
        }

        if (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"@tanstack/start"', '"@tanstack/react-router"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'tanstack.config.ts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'tanstack.config.js') -PathType Leaf)
        ) {
            return 'tanstack'
        }

        if (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"vite"', '"vite dev"', '"vite build"', '"@vitejs/plugin-react"', '"@vitejs/plugin-vue"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'vite.config.ts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'vite.config.js') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'vite.config.mts') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'vite.config.mjs') -PathType Leaf)
        ) {
            return 'vite'
        }

        if (
            (Select-String -Path (Join-Path $RootPath 'package.json') -Pattern '"express"' -Quiet -ErrorAction SilentlyContinue) -or
            (Test-Path (Join-Path $RootPath 'src\index.js') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'src\index.ts') -PathType Leaf)
        ) {
            return 'express'
        }

        return 'nodejs'
    }

    if (Test-Path (Join-Path $RootPath 'go.mod') -PathType Leaf) {
        return 'go'
    }

    if (Test-Path (Join-Path $RootPath 'Cargo.toml') -PathType Leaf) {
        return 'rust'
    }

    if (
        (Test-Path (Join-Path $RootPath 'build.gradle.kts') -PathType Leaf) -or
        (Get-ChildItem -Path $RootPath -Recurse -Include *.kt -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    ) {
        return 'kotlin'
    }

    if (
        (Test-Path (Join-Path $RootPath 'Package.swift') -PathType Leaf) -or
        (Get-ChildItem -Path $RootPath -Recurse -Include *.swift -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    ) {
        return 'swift'
    }

    if (
        (Test-Path (Join-Path $RootPath 'pom.xml') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'build.gradle') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'build.gradle.kts') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'settings.gradle') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'settings.gradle.kts') -PathType Leaf)
    ) {
        return 'java'
    }

    if (
        (Test-Path (Join-Path $RootPath 'Gemfile') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath '.ruby-version') -PathType Leaf)
    ) {
        return 'ruby'
    }

    if (
        (Test-Path (Join-Path $RootPath 'composer.json') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'artisan') -PathType Leaf)
    ) {
        if (Select-String -Path (Join-Path $RootPath 'composer.json') -Pattern '"laravel/framework"' -Quiet -ErrorAction SilentlyContinue) {
            return 'laravel'
        }

        return 'php'
    }

    if (
        (Test-Path (Join-Path $RootPath 'pyproject.toml') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'uv.lock') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'requirements.txt') -PathType Leaf)
    ) {
        if (
            (Test-Path (Join-Path $RootPath 'manage.py') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'settings.py') -PathType Leaf)
        ) {
            return 'django'
        }

        if (
            (Test-Path (Join-Path $RootPath 'main.py') -PathType Leaf) -or
            (Test-Path (Join-Path $RootPath 'src\main.py') -PathType Leaf)
        ) {
            return 'fastapi'
        }

        return 'python'
    }

    if (Test-Path (Join-Path $RootPath 'mix.exs') -PathType Leaf) {
        return 'elixir'
    }

    if (
        (Test-Path (Join-Path $RootPath 'cpanfile') -PathType Leaf) -or
        (Test-Path (Join-Path $RootPath 'Makefile.PL') -PathType Leaf) -or
        (Get-ChildItem -Path $RootPath -Recurse -Include *.pl,*.pm -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    ) {
        return 'perl'
    }

    if (
        (Test-Path (Join-Path $RootPath 'build.sbt') -PathType Leaf) -or
        (Get-ChildItem -Path $RootPath -Recurse -Include *.scala -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    ) {
        return 'scala'
    }

    return 'generic'
}

function Select-PresetName {
    $Available = Get-AvailablePresets
    if ($Available.Count -eq 0) {
        Write-Warn "No presets found under project/presets. Falling back to generic."
        return 'generic'
    }

    Write-Bold "Choose a project preset:"
    Write-Host "  [1] Auto-detect"
    for ($i = 0; $i -lt $Available.Count; $i++) {
        $DisplayIndex = $i + 2
        Write-Host "  [$DisplayIndex] $($Available[$i])"
    }
    Write-Host ""
    Write-Host -NoNewline "Enter choice [1-$($Available.Count + 1)]: "

    $Choice = (Read-Host).Trim()
    if ($Choice -eq '1' -or [string]::IsNullOrWhiteSpace($Choice)) {
        return 'auto'
    }

    if ($Choice -match '^\d+$') {
        $NumericChoice = [int]$Choice
        $PresetIndex = $NumericChoice - 2
        if ($PresetIndex -ge 0 -and $PresetIndex -lt $Available.Count) {
            return $Available[$PresetIndex]
        }
    }

    if ($Available -contains $Choice) {
        return $Choice
    }

    Write-Warn "Invalid preset choice. Falling back to auto-detect."
    return 'auto'
}

function Install-Global {
    Write-Info "--- Installing global config ---"

    $HomeDir   = $env:USERPROFILE
    if (-not $HomeDir) { $HomeDir = $env:HOME }

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

    $AgentsSrc = Join-Path $GlobalDir 'AGENTS.md'
    if (-not (Test-Path $AgentsSrc -PathType Leaf)) {
        Write-Err "Source file not found: $AgentsSrc"
        return
    }

    $ModuleMode = $null
    $ModuleList = $null
    if ($EnableModules) {
        $ModuleMode = 'enable'
        $ModuleList = $EnableModules
    } elseif ($DisableModules) {
        $ModuleMode = 'disable'
        $ModuleList = $DisableModules
    }

    if ($ClaudeDetected) {
        Ensure-Dir $ClaudeDir
        Backup-File (Join-Path $ClaudeDir 'AGENTS.md')
        Copy-FileInstall $AgentsSrc (Join-Path $ClaudeDir 'AGENTS.md')
        if ($ModuleMode) {
            Filter-Modules -FilePath (Join-Path $ClaudeDir 'AGENTS.md') -Mode $ModuleMode -ModulesCsv $ModuleList
        }
    }

    if ($CodexDetected) {
        Ensure-Dir $CodexDir
        Backup-File (Join-Path $CodexDir 'AGENTS.md')
        Copy-FileInstall $AgentsSrc (Join-Path $CodexDir 'AGENTS.md')
        if ($ModuleMode) {
            Filter-Modules -FilePath (Join-Path $CodexDir 'AGENTS.md') -Mode $ModuleMode -ModulesCsv $ModuleList
        }
    }

    if ($GeminiDetected) {
        Ensure-Dir $GeminiDir
        Backup-File (Join-Path $GeminiDir 'AGENTS.md')
        Copy-FileInstall $AgentsSrc (Join-Path $GeminiDir 'AGENTS.md')
        if ($ModuleMode) {
            Filter-Modules -FilePath (Join-Path $GeminiDir 'AGENTS.md') -Mode $ModuleMode -ModulesCsv $ModuleList
        }
    }

    if ($ClaudeDetected) {
        $ClaudeMdSrc = Join-Path $GlobalDir 'CLAUDE.md'
        if (Test-Path $ClaudeMdSrc -PathType Leaf) {
            Backup-File (Join-Path $ClaudeDir 'CLAUDE.md')
            Copy-FileInstall $ClaudeMdSrc (Join-Path $ClaudeDir 'CLAUDE.md')
        } else {
            Write-Warn "global/CLAUDE.md not found - skipping."
        }
    }

    if ($GeminiDetected) {
        $GeminiMdSrc = Join-Path $GlobalDir 'GEMINI.md'
        if (Test-Path $GeminiMdSrc -PathType Leaf) {
            Backup-File (Join-Path $GeminiDir 'GEMINI.md')
            Copy-FileInstall $GeminiMdSrc (Join-Path $GeminiDir 'GEMINI.md')
        } else {
            Write-Warn "global/GEMINI.md not found - skipping."
        }
    }

    if ($CodexDetected) {
        $CodexMdSrc = Join-Path $GlobalDir 'CODEX.md'
        if (Test-Path $CodexMdSrc -PathType Leaf) {
            Backup-File (Join-Path $CodexDir 'CODEX.md')
            Copy-FileInstall $CodexMdSrc (Join-Path $CodexDir 'CODEX.md')
        } else {
            Write-Warn "global/CODEX.md not found - skipping."
        }
    }

    Write-Success "Global config install complete."
    Write-Host ""
}

function Install-Project {
    param([string]$PresetName = 'auto')

    Write-Info "--- Installing project template ---"

    $Cwd = (Get-Location).Path
    $NormalizedCwd    = $Cwd.TrimEnd('\', '/').ToLower()
    $NormalizedScript = $ScriptDir.TrimEnd('\', '/').ToLower()

    if ($NormalizedCwd -eq $NormalizedScript) {
        Write-Err "You are running from inside the setup repo itself."
        Write-Err "Change to your project directory first, then re-run this script."
        return
    }

    if ($PresetName -eq 'auto') {
        $PresetName = Get-DetectedPreset -RootPath $Cwd
    }

    $Src = Get-PresetPath -PresetName $PresetName
    if (-not (Test-Path $Src -PathType Leaf)) {
        Write-Warn "Preset '$PresetName' not found. Falling back to generic."
        $PresetName = 'generic'
        $Src = Get-PresetPath -PresetName $PresetName
    }

    if (-not (Test-Path $Src -PathType Leaf)) {
        Write-Err "Source file not found: $Src"
        return
    }

    $PackageManager = Get-DetectedPackageManager -RootPath $Cwd
    $Dst = Join-Path $Cwd 'AGENTS.md'
    Backup-File $Dst
    Write-RenderedFile -Source $Src -Destination $Dst -PackageManager $PackageManager

    Write-Success "Installed project preset: $PresetName"
    if ($PackageManager) {
        Write-Info "Adjusted command examples for package manager: $PackageManager"
    }
    Write-Host ""
}

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

function Print-Menu {
    Write-Host ""
    Write-Bold "What would you like to install?"
    Write-Host "  [1] Global config (AGENTS.md + tool-specific configs)"
    Write-Host "  [2] Project template (auto-detect preset)"
    Write-Host "  [3] Project template (choose preset manually)"
    Write-Host "  [4] Claude Code settings (auto mode, permissions, plugins)"
    Write-Host "  [5] All of the above"
    Write-Host ""
    Write-Host -NoNewline "Enter choice [1-5]: "
}

function Main {
    if ($ListPresets) {
        Print-PresetCatalog
        return
    }

    if ($All -or $Preset) {
        $InstalledItems = [System.Collections.Generic.List[string]]::new()
        $DetectedPackageManager = $null
        if ($Preset -eq 'auto' -or [string]::IsNullOrWhiteSpace($Preset)) {
            $DetectedPackageManager = Get-DetectedPackageManager -RootPath (Get-Location).Path
            if ($DetectedPackageManager) {
                Write-Info "Detected package manager: $DetectedPackageManager"
            }
        }

        if ($All) {
            Install-Global
            $InstalledItems.Add('Global config (AGENTS.md + tool-specific configs)')
            if ([string]::IsNullOrWhiteSpace($Preset)) {
                $Preset = 'auto'
            }
            Install-Project $Preset
            $InstalledItems.Add("Project template (preset: $Preset -> $((Get-Location).Path)\AGENTS.md)")
            Install-Settings
            $InstalledItems.Add('Claude Code settings (~/.claude/settings.json)')
        } else {
            Install-Project $Preset
            $InstalledItems.Add("Project template (preset: $Preset -> $((Get-Location).Path)\AGENTS.md)")
        }

        Write-Bold "============================================================"
        Write-Bold " Installation Summary"
        Write-Bold "============================================================"
        foreach ($Item in $InstalledItems) {
            Write-Success "  + $Item"
        }
        if ($DetectedPackageManager) {
            Write-Host "  Package manager: $DetectedPackageManager"
        }
        if ($DryRun) {
            Write-Warn "Dry-run mode was active - no files were written."
        }
        Write-Host ""
        return
    }

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
            Install-Project 'auto'
            $InstalledItems.Add("Project template (auto-detected preset -> $((Get-Location).Path)\AGENTS.md)")
        }
        '3' {
            $Preset = Select-PresetName
            Install-Project $Preset
            $InstalledItems.Add("Project template (preset: $Preset -> $((Get-Location).Path)\AGENTS.md)")
        }
        '4' {
            Install-Settings
            $InstalledItems.Add('Claude Code settings (~/.claude/settings.json)')
        }
        '5' {
            Install-Global
            $InstalledItems.Add('Global config (AGENTS.md + tool-specific configs)')
            Install-Project 'auto'
            $InstalledItems.Add("Project template (auto-detected preset -> $((Get-Location).Path)\AGENTS.md)")
            Install-Settings
            $InstalledItems.Add('Claude Code settings (~/.claude/settings.json)')
        }
        default {
            Write-Err "Invalid choice: '$Choice'. Please enter 1, 2, 3, 4, or 5."
            exit 1
        }
    }

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
        Write-Warn "Dry-run mode was active - no files were written."
    }

    Write-Host ""
}

Main
