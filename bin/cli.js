#!/usr/bin/env node
"use strict";

const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");
const os = require("os");

const PACKAGE_ROOT = path.resolve(__dirname, "..");
const args = process.argv.slice(2);

// Handle --help before spawning any installer
if (args.includes("--help") || args.includes("-h")) {
  printHelp();
  process.exit(0);
}

function isWindows() {
  return os.platform() === "win32";
}

function hasBash() {
  try {
    const { execSync } = require("child_process");
    execSync("bash --version", { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

function runInstaller() {
  if (isWindows() && !hasBash()) {
    // Windows without bash — use PowerShell
    const script = path.join(PACKAGE_ROOT, "install.ps1");
    if (!fs.existsSync(script)) {
      console.error("ERROR: install.ps1 not found at", script);
      process.exit(1);
    }

    // Convert args: --dry-run → -DryRun, --preset x → -Preset x, etc.
    const psArgs = convertToPowerShellArgs(args);

    const child = spawn(
      "powershell",
      ["-ExecutionPolicy", "Bypass", "-File", script, ...psArgs],
      { stdio: "inherit", cwd: process.cwd() }
    );

    child.on("close", (code) => process.exit(code || 0));
    child.on("error", (err) => {
      console.error("Failed to start PowerShell:", err.message);
      process.exit(1);
    });
  } else {
    // Unix, macOS, WSL, or Windows with bash (Git Bash)
    const script = path.join(PACKAGE_ROOT, "install.sh");
    if (!fs.existsSync(script)) {
      console.error("ERROR: install.sh not found at", script);
      process.exit(1);
    }

    const child = spawn("bash", [script, ...args], {
      stdio: "inherit",
      cwd: process.cwd(),
    });

    child.on("close", (code) => process.exit(code || 0));
    child.on("error", (err) => {
      console.error("Failed to start bash:", err.message);
      if (isWindows()) {
        console.error(
          "Tip: Install Git for Windows (https://git-scm.com) to get bash, or run .\\install.ps1 directly."
        );
      }
      process.exit(1);
    });
  }
}

function convertToPowerShellArgs(cliArgs) {
  const result = [];
  let i = 0;
  while (i < cliArgs.length) {
    switch (cliArgs[i]) {
      case "--dry-run":
        result.push("-DryRun");
        i++;
        break;
      case "--all":
        result.push("-All");
        i++;
        break;
      case "--list-presets":
        result.push("-ListPresets");
        i++;
        break;
      case "--preset":
        result.push("-Preset");
        if (i + 1 < cliArgs.length) {
          result.push(cliArgs[i + 1]);
          i += 2;
        } else {
          i++;
        }
        break;
      case "--enable-modules":
        result.push("-EnableModules");
        if (i + 1 < cliArgs.length) {
          result.push(cliArgs[i + 1]);
          i += 2;
        } else {
          i++;
        }
        break;
      case "--disable-modules":
        result.push("-DisableModules");
        if (i + 1 < cliArgs.length) {
          result.push(cliArgs[i + 1]);
          i += 2;
        } else {
          i++;
        }
        break;
      case "--help":
      case "-h":
        printHelp();
        process.exit(0);
        break;
      default:
        result.push(cliArgs[i]);
        i++;
    }
  }
  return result;
}

function printHelp() {
  console.log(`
agentsmd - Universal setup for AI coding agents

Usage:
  npx agentsmd                        Interactive installer
  npx agentsmd --all                   Install everything (global + project + settings)
  npx agentsmd --preset <stack>        Install a specific project preset
  npx agentsmd --list-presets          Show all available presets
  npx agentsmd --dry-run               Preview what would be installed

Options:
  --all                     Install global config, project preset, and settings
  --preset <name>           Use a specific preset (nextjs, python, go, etc.)
  --list-presets            List all 37 available presets
  --dry-run                 Show what would happen without writing files
  --enable-modules <list>   Only keep listed modules (comma-separated)
  --disable-modules <list>  Remove listed modules (comma-separated)
  --help, -h                Show this help

Examples:
  npx agentsmd --all --preset nextjs
  npx agentsmd --preset python --dry-run
  npx agentsmd --all --disable-modules tdd,agent-teams

Learn more: https://github.com/Brain2k-0005/agentsmd
`);
}

runInstaller();
