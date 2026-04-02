#Requires -Version 5.1
<#
.SYNOPSIS
    Generate preset AGENTS.md files from template + YAML config.
.DESCRIPTION
    Reads preset-config.yaml and preset-template.md, substitutes variables,
    and writes each preset to project/presets/{key}/AGENTS.md.
.PARAMETER DryRun
    If specified, shows what would be generated without writing files.
.EXAMPLE
    .\generate-presets.ps1
    .\generate-presets.ps1 -DryRun
#>

param(
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplateFile = Join-Path $ScriptDir 'preset-template.md'
$ConfigFile = Join-Path $ScriptDir 'preset-config.yaml'
$OutputBase = Join-Path $ScriptDir '..\project\presets'

if ($DryRun) {
    Write-Host '[DRY RUN] No files will be written.' -ForegroundColor Yellow
    Write-Host ''
}

# Validate required files
if (-not (Test-Path $TemplateFile)) {
    Write-Error "Template file not found: $TemplateFile"
    exit 1
}
if (-not (Test-Path $ConfigFile)) {
    Write-Error "Config file not found: $ConfigFile"
    exit 1
}

# Read template
$Template = Get-Content -Path $TemplateFile -Raw

# Parse YAML config (simple parser for our flat structure)
$configLines = Get-Content -Path $ConfigFile -Encoding UTF8

# State machine for parsing
$presets = [ordered]@{}
$presetKeys = [System.Collections.ArrayList]::new()
$currentPreset = $null
$currentField = $null
$currentValue = $null
$inBlock = $false

function Flush-Field {
    if ($null -eq $script:currentPreset -or $null -eq $script:currentField) {
        return
    }

    $val = $script:currentValue
    # Remove single trailing newline
    if ($null -ne $val) {
        $val = $val.TrimEnd("`n")
    }

    if (-not $script:presets.Contains($script:currentPreset)) {
        $script:presets[$script:currentPreset] = @{}
    }
    $script:presets[$script:currentPreset][$script:currentField] = $val

    $script:currentField = $null
    $script:currentValue = $null
}

foreach ($line in $configLines) {
    # Skip comments and top-level keys
    if ($line -match '^\s*#' -or $line -match '^presets:') {
        continue
    }

    # Detect preset key: exactly 2 spaces + word + colon
    if ($line -match '^  ([a-zA-Z_][a-zA-Z0-9_]*):\s*$') {
        Flush-Field
        $inBlock = $false
        $currentPreset = $Matches[1]
        [void]$presetKeys.Add($currentPreset)
        $currentField = $null
        $currentValue = $null
        continue
    }

    # Detect field: 4 spaces + field_name: value
    if ($line -match '^    ([a-zA-Z_][a-zA-Z0-9_]*):\s*(.*)$') {
        Flush-Field
        $inBlock = $false
        $fieldName = $Matches[1]
        $fieldValue = $Matches[2]

        $currentField = $fieldName

        if ($fieldValue -eq '|') {
            $inBlock = $true
            $currentValue = $null
        }
        elseif ($fieldValue -eq '""') {
            $currentValue = ''
            $inBlock = $false
        }
        else {
            # Remove surrounding quotes if present
            $fieldValue = $fieldValue -replace '^"', '' -replace '"$', ''
            $currentValue = $fieldValue
            $inBlock = $false
        }
        continue
    }

    # Accumulate block scalar content
    if ($inBlock -and $null -ne $currentField) {
        # Strip leading 6 spaces
        $content = $line -replace '^ {6}', ''
        if ($null -ne $currentValue -and $currentValue -ne '') {
            $currentValue = $currentValue + "`n" + $content
        }
        else {
            $currentValue = $content
        }
    }
}

# Flush last field
Flush-Field

# Generate presets
Write-Host 'Generating presets from template...'
Write-Host ''

$generateCount = 0

foreach ($key in $presetKeys) {
    $preset = $presets[$key]
    $outputDir = Join-Path $OutputBase $key
    $outputFile = Join-Path $outputDir 'AGENTS.md'

    # Get values with defaults
    $pName = if ($preset.ContainsKey('name')) { $preset['name'] } else { $key }
    $pOverview = if ($preset.ContainsKey('overview')) { $preset['overview'] } else { '' }
    $pCommands = if ($preset.ContainsKey('commands')) { $preset['commands'] } else { '' }
    $pTechStack = if ($preset.ContainsKey('tech_stack')) { $preset['tech_stack'] } else { '' }
    $pCodeStyle = if ($preset.ContainsKey('code_style')) { $preset['code_style'] } else { '' }
    $pSkills = if ($preset.ContainsKey('skills')) { $preset['skills'] } else { '' }
    $pTestCommand = if ($preset.ContainsKey('test_command')) { $preset['test_command'] } else { '' }
    $pTestFramework = if ($preset.ContainsKey('test_framework')) { $preset['test_framework'] } else { '' }
    $pTesting = if ($preset.ContainsKey('testing')) { $preset['testing'] } else { '' }
    $pNeverModify = if ($preset.ContainsKey('never_modify')) { $preset['never_modify'] } else { '' }
    $pExternalServices = if ($preset.ContainsKey('external_services')) { $preset['external_services'] } else { '' }

    # Build output by substituting placeholders
    $output = $Template

    # Simple string replacements for single-line values (use literal Replace to avoid regex escaping issues)
    $output = $output.Replace('{{name}}', $pName)
    $output = $output.Replace('{{overview}}', $pOverview)
    $output = $output.Replace('{{test_command}}', $pTestCommand)
    $output = $output.Replace('{{test_framework}}', $pTestFramework)

    # Multi-line replacements: replace the placeholder line with content
    function Replace-Multiline {
        param(
            [string]$Text,
            [string]$Placeholder,
            [string]$Replacement
        )

        $lines = $Text -split "`n"
        $result = [System.Collections.ArrayList]::new()

        foreach ($l in $lines) {
            if ($l.Trim() -eq $Placeholder) {
                if (-not [string]::IsNullOrEmpty($Replacement)) {
                    $repLines = $Replacement -split "`n"
                    foreach ($rl in $repLines) {
                        [void]$result.Add($rl)
                    }
                }
                # If replacement is empty, skip the line entirely
            }
            else {
                [void]$result.Add($l)
            }
        }

        return ($result -join "`n")
    }

    $output = Replace-Multiline -Text $output -Placeholder '{{commands}}' -Replacement $pCommands
    $output = Replace-Multiline -Text $output -Placeholder '{{tech_stack}}' -Replacement $pTechStack
    $output = Replace-Multiline -Text $output -Placeholder '{{code_style}}' -Replacement $pCodeStyle
    $output = Replace-Multiline -Text $output -Placeholder '{{skills}}' -Replacement $pSkills
    $output = Replace-Multiline -Text $output -Placeholder '{{testing}}' -Replacement $pTesting
    $output = Replace-Multiline -Text $output -Placeholder '{{never_modify}}' -Replacement $pNeverModify
    $output = Replace-Multiline -Text $output -Placeholder '{{external_services}}' -Replacement $pExternalServices

    if ($DryRun) {
        Write-Host "  [DRY RUN] Would generate: $outputFile" -ForegroundColor Cyan
    }
    else {
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
        }
        # Write with UTF-8 no BOM
        [System.IO.File]::WriteAllText($outputFile, $output, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  Generated: $outputFile" -ForegroundColor Green
    }
    $generateCount++
}

Write-Host ''
Write-Host "Done. $generateCount preset(s) processed."
