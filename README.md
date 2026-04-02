# Autonomous Agent Config

Universal setup for AI coding agents that learn, plan, and ship code autonomously.

---

## Get Started in 60 Seconds

1. Clone this repo
2. Run the installer
3. Open any project -- your AI agent is now autonomous

**macOS / Linux / WSL:**
```bash
git clone https://github.com/Brain2k-0005/autonomous-agents.git
cd autonomous-agents
bash install.sh
```

**Windows PowerShell:**
```powershell
git clone https://github.com/Brain2k-0005/autonomous-agents.git
cd autonomous-agents
.\install.ps1
```

That's it. Your AI coding agent will now self-discover your project, plan before coding, and verify its own work -- no hand-holding required.

---

## What is AGENTS.md?

AGENTS.md is an open standard (backed by the Linux Foundation) that tells AI coding agents how to behave in your project. Think of it like a `.gitignore` for Git or an `.editorconfig` for your editor -- but for AI agents.

When you put an AGENTS.md file in your project, any compatible AI tool (Claude Code, Codex, Gemini, Copilot, Cursor, and more) will read it and follow the rules inside. This means:

- The AI knows your tech stack without asking
- It follows your coding conventions automatically
- It runs the right commands (`npm test`, `cargo build`, `dotnet test`, etc.)
- It respects boundaries (never touch migrations, never commit secrets)

This repo gives you ready-made AGENTS.md files for 37 different tech stacks, plus global rules that make every AI agent smarter out of the box.

---

## How Does the AI Learn By Itself?

When you open a project with this config installed, your AI agent automatically:

```
You open a project
    |
Agent reads package.json, pyproject.toml, go.mod, etc.
    |
Agent detects: "This is a Next.js 15 project with TypeScript and Tailwind"
    |
Agent reads your AGENTS.md for project-specific rules
    |
Agent checks git log for your commit style
    |
Agent starts working -- no questions asked
```

**No setup per project.** The global config teaches the agent HOW to learn. The project AGENTS.md teaches it WHAT to know about your specific repo. If there's no project AGENTS.md, the agent still works -- it just discovers everything from your files.

### Skill Self-Discovery

The agent doesn't just follow rules -- it actively searches for better tools:

1. Before any non-trivial task, it runs `find-skills` to check if a specialized skill exists
2. If a skill exists (debugging, testing, code review, etc.), it uses that instead of improvising
3. Skills it finds useful get remembered for future tasks

This means the agent gets better over time without you doing anything.

---

## What This Is

A modular configuration system for AI CLI coding agents. Instead of hand-holding your agent through every task, this repo teaches it to:

- **Self-discover** project context (stack, conventions, dependencies) before writing code
- **Discover skills first** instead of re-inventing known workflows
- **Plan before coding** for non-trivial work
- **Coordinate multi-agent teams** for parallel execution across large tasks
- **Verify its own work** through quality gates, tests, and automated review

It works across **Claude Code, Codex CLI, Gemini CLI, GitHub Copilot, Cursor, Windsurf, Zed, and Aider** using the [AGENTS.md open standard](https://agentsmd.org) (Linux Foundation).

You install a global config once. Every project you open gets an autonomous agent out of the box. Add a project-level `AGENTS.md` to teach it your stack-specific rules.

---

## Repo Structure

```
autonomous-agents/
├── README.md                      # This file
├── install.sh                     # Bash installer (macOS/Linux/WSL)
├── install.ps1                    # PowerShell installer (Windows)
├── global/
│   ├── AGENTS.md                  # Universal agent rules (all tools)
│   ├── CLAUDE.md                  # Claude Code specific config
│   ├── CODEX.md                   # Codex CLI specific config
│   ├── COPILOT.md                 # GitHub Copilot specific config
│   ├── GEMINI.md                  # Gemini CLI specific config
│   ├── claude-settings.json       # Claude Code settings (conservative)
│   └── claude-settings-power.json # Claude Code settings (unrestricted)
├── project/
│   ├── AGENTS.md                  # Generic project template
│   └── presets/                   # 37 stack-specific templates
│       ├── nextjs/AGENTS.md       # (and 36 more -- run --list-presets to see all)
│       ├── dotnet/AGENTS.md
│       ├── python/AGENTS.md
│       └── ...
├── modules/
│   ├── agent-teams.md             # Multi-agent coordination
│   ├── tdd.md                     # Test-driven development
│   ├── code-review.md             # Automated code review
│   ├── skill-discovery.md         # Skill/plugin discovery
│   ├── quality-gates.md           # Verification checklist
│   ├── token-efficiency.md        # Token optimization + CLI vs MCP
│   └── cross-tool-review.md      # Cross-tool review for dual control
├── templates/
│   ├── preset-template.md         # Template for generating presets
│   ├── preset-config.yaml         # Configuration for all 37 presets
│   ├── generate-presets.sh        # Preset generator (Bash)
│   └── generate-presets.ps1       # Preset generator (PowerShell)
├── tests/
│   ├── install_test.bats          # Installer integration tests
│   └── test_helper.bash           # Test utilities
└── examples/
    ├── nextjs/AGENTS.md           # Example for Next.js projects
    ├── dotnet/AGENTS.md           # Example for .NET projects
    └── python/AGENTS.md           # Example for Python projects
```

To see all 37 available presets:

```bash
./install.sh --list-presets     # macOS / Linux / WSL
./install.ps1 -ListPresets      # Windows PowerShell
```

Available stacks: angular, astro, bun, c, cpp, csharp, deno, django, dotnet, elixir, express, fastapi, flutter, generic, go, java, kotlin, laravel, nestjs, nextjs, nodejs, perl, php, python, react, remix, ruby, rust, scala, solid, solidstart, svelte, swift, tanstack, tauri, vite, vue.

---

## Requirements

### Prerequisites

| Tool | Required? | Install |
|------|-----------|---------|
| Git | Required | [git-scm.com](https://git-scm.com) |
| Node.js 18+ | Recommended | [nodejs.org](https://nodejs.org) |
| Claude Code | Optional | `npm install -g @anthropic-ai/claude-code` |
| Codex CLI | Optional | `npm install -g @openai/codex` |
| Gemini CLI | Optional | `npm install -g @google/gemini-cli` |

You need at least one AI CLI tool installed. The config files are inert without one.

### Recommended Plugin

| Plugin | Purpose |
|--------|---------|
| `superpowers` | Core workflow: planning, parallel agents, code review, debugging, TDD |

Install it inside Claude Code:

```
/install-skill superpowers
```

The agent will use `find-skills` to discover and install any additional skills it needs for your specific project. You don't need to manually install stack-specific plugins.

---

## Installation Details

### Automated Install

```bash
# Clone the repo
git clone https://github.com/Brain2k-0005/autonomous-agents.git
cd autonomous-agents

# Interactive installer -- detects your tools and copies the right files
bash install.sh       # macOS / Linux / WSL
./install.ps1         # Windows PowerShell
```

The installer will:
1. Detect which AI CLI tools you have installed
2. Copy the appropriate global config files to each tool's config directory
3. Detect the project stack and package manager, including Vite-only repos
4. Render the copied project preset so command examples match the detected package manager
5. Install the matching project preset when requested
6. Optionally install recommended plugins or skills
7. Print a summary of what was placed where

Non-interactive examples:

```bash
./install.sh --preset nextjs
./install.sh --all --preset laravel --dry-run
./install.sh --preset bun
./install.sh --list-presets
./install.ps1 -Preset react
./install.ps1 -All -Preset fastapi -DryRun
./install.ps1 -Preset tauri
./install.ps1 -ListPresets
```

### Manual Install

If you prefer to copy files by hand:

```bash
# Global config (pick your tools)
cp global/AGENTS.md   ~/.claude/AGENTS.md   # Claude Code
cp global/CLAUDE.md   ~/.claude/CLAUDE.md   # Claude Code specific
cp global/AGENTS.md   ~/.codex/AGENTS.md    # Codex CLI
cp global/CODEX.md    ~/.codex/CODEX.md     # Codex CLI specific
cp global/AGENTS.md   ~/.gemini/AGENTS.md   # Gemini CLI
cp global/GEMINI.md   ~/.gemini/GEMINI.md   # Gemini CLI specific
cp global/claude-settings.json ~/.claude/settings.json  # Claude Code settings
```

For any project, copy the matching preset into the repo root:

```bash
cp project/presets/<your-stack>/AGENTS.md /path/to/your/project/AGENTS.md
```

---

## How It Works

### Config Hierarchy

Configuration flows from general to specific, with later layers overriding earlier ones:

```
Global AGENTS.md          Base rules for all projects and all tools
  └── Tool-specific       CLAUDE.md / CODEX.md / COPILOT.md / GEMINI.md enhancements
       └── Project AGENTS.md    Project-level overrides and context
            └── Modules         Composable behaviors (add/remove as needed)
```

- **Global AGENTS.md** -- applies to every project you open. Defines planning discipline, skill discovery, review habits, git conventions, and quality gates.
- **CLAUDE.md / CODEX.md / COPILOT.md / GEMINI.md** -- tool-specific extensions that use features unique to that CLI (skills, MCP servers, model routing, presets).
- **Project AGENTS.md** -- lives in each repo root. Describes the stack, folder structure, test commands, project-specific rules, and useful skills.
- **Project presets** -- stack-specific templates you can copy into a new repo before customizing. The current catalog includes 37 stacks covering all major languages and frameworks.
- **Modules** -- composable blocks already embedded in the global config. Enable or disable them by editing the global file.

### The Self-Learning Flow

When an agent starts work on a task, the config instructs it to:

1. **Read manifests** -- `package.json`, `pyproject.toml`, `*.csproj`, `go.mod`, etc.
2. **Detect the stack** -- framework, language version, key dependencies
3. **Pick the matching preset** -- `generic`, `nextjs`, `dotnet`, `python`, or a repo-specific variant
4. **Read existing docs** -- `README.md`, `CONTRIBUTING.md`, `docs/` directory
5. **Check git conventions** -- recent commit messages, branch naming, PR templates
6. **Start work** -- with full context, no questions needed

This eliminates the "what framework are you using?" back-and-forth that wastes tokens and time.

---

## Modules

Each module is a composable block inside `global/AGENTS.md`, wrapped in HTML comments for easy identification. Source files in `modules/` serve as reference and documentation.

| Module | Description |
|--------|-------------|
| `agent-teams` | Multi-agent coordination with Lead (Opus) / Worker (Sonnet) / Reviewer roles |
| `tdd` | Test-driven development: red-green-refactor cycle enforced before implementation |
| `code-review` | Automated review checklist covering security, performance, correctness, and style |
| `skill-discovery` | Find and install skills/plugins across platforms dynamically |
| `quality-gates` | Verification checklist the agent must pass before claiming a task is done |
| `token-efficiency` | Minimize token usage: CLI vs MCP decisions, targeted reads, batch operations |
| `cross-tool-review` | Use multiple AI tools to review each other's work for higher quality |

### Adding or Removing Modules

Open `global/AGENTS.md` and find the module blocks marked with comments:

```markdown
<!-- MODULE: tdd -->
## Test-Driven Development
...
<!-- /MODULE: tdd -->
```

Delete or comment out any block you do not need. The remaining modules continue to work independently.

---

## Token Efficiency

Large context windows are powerful but expensive. The `token-efficiency` module teaches agents to minimize waste:

### When to Use CLI vs MCP

**CLI tools** are cheap, fast, and local. **MCP tools** give structured access to external services.

| Task | Use CLI | Use MCP |
|------|---------|---------|
| **File operations** | Read, Grep, Glob, Bash(`ls`, `cp`) | -- |
| **Git** | `git log`, `git diff`, `gh pr create` | -- |
| **Build/test/lint** | `npm test`, `cargo build`, `dotnet test` | -- |
| **Stripe payments** | `stripe listen` (webhooks) | Check subscriptions, list charges, create customers |
| **Database** | Run migrations, seed data | Query records, explore schemas, debug data |
| **GitHub** | Simple PR/issue ops via `gh` | Search across repos, read threaded comments |
| **Browser** | `curl` for downloads/health checks | Multi-step forms, screenshots, DOM interaction |

**Rule of thumb:** If it's local and one-shot, use CLI. If it needs auth, pagination, or structured data from an external service, use MCP.

### Key Practices

- **Targeted reads** -- read specific line ranges, not entire files, when you know what you need
- **Batch parallel calls** -- group independent tool calls in a single message
- **Right-size your model** -- use Sonnet-class models for implementation tasks, Opus-class for planning and review
- **Avoid redundant exploration** -- read manifests once, cache the mental model, do not re-read

---

## Customization

### Tailoring the Global Config

1. Open `global/AGENTS.md`
2. Remove module sections you do not use (e.g., delete the TDD block if your team does not practice TDD)
3. Edit the planning thresholds (file count triggers for formal plans)
4. Adjust git commit conventions to match your team's style

### Setting Up a New Project

1. Copy `project/AGENTS.md` into your project root
2. Fill in the template: stack, folder structure, build/test commands, deployment targets
3. Add any project-specific rules (naming conventions, forbidden patterns, required imports)

### Claude Code Settings

Two settings files are provided:

- `claude-settings.json` -- conservative defaults (safe shell command patterns)
- `claude-settings-power.json` -- unrestricted shell access for power users

Edit the appropriate file to control permissions:

- Which tools the agent can use without asking
- Which directories it can read/write
- Whether it can execute shell commands autonomously

Copy it to `~/.claude/settings.json` (global) or `.claude/settings.json` (per-project) with stricter overrides.

### Adding Skills

```
/install-skill superpowers      # Core workflow skills
```

The agent uses `find-skills` to discover additional skills as needed. You rarely need to install skills manually.

---

## Tool Compatibility

The AGENTS.md standard is read by multiple tools. Here is where each tool looks for config:

| Tool | Global Config Location | Project Config Location |
|------|----------------------|------------------------|
| Claude Code | `~/.claude/AGENTS.md` + `CLAUDE.md` | `./AGENTS.md` + `.claude/settings.json` |
| Codex CLI | `~/.codex/AGENTS.md` + `CODEX.md` | `./AGENTS.md` |
| Gemini CLI | `~/.gemini/AGENTS.md` + `GEMINI.md` | `./AGENTS.md` |
| GitHub Copilot | (via repository) | `./AGENTS.md` + `COPILOT.md` |
| Cursor | (via repository) | `./AGENTS.md` + `.cursorrules` |
| Windsurf | (via repository) | `./AGENTS.md` + `.windsurfrules` |
| Zed | (via repository) | `./AGENTS.md` |
| Aider | (via repository) | `./AGENTS.md` + `.aider.conf.yml` |

Tools that only read from the repository (marked "via repository") pick up your project-level `AGENTS.md` automatically when you open a repo. For those tools, global rules must be embedded in each project or referenced via your dotfiles.

---

## Examples

The `examples/` directory contains production-ready `AGENTS.md` templates for common stacks:

| Example | Stack | Key Features |
|---------|-------|--------------|
| `examples/nextjs/AGENTS.md` | Next.js + TypeScript + Tailwind | App Router conventions, server components, Supabase |
| `examples/dotnet/AGENTS.md` | .NET 9 + C# + Entity Framework Core | Clean Architecture, Minimal API, xUnit testing |
| `examples/python/AGENTS.md` | Python + FastAPI + SQLAlchemy | uv package manager, pytest, Alembic migrations |

Copy the relevant example into your project root and edit it to match your specific setup.

---

## Contributing

Contributions are welcome. To keep the config universal and maintainable:

1. **Fork and branch** -- work on a feature branch, not main
2. **One module per PR** -- keep changes focused and reviewable
3. **Test across tools** -- verify your change works with at least two different AI CLI tools
4. **No tool-specific assumptions** -- modules in `global/AGENTS.md` must work for all tools. Put tool-specific logic in the dedicated files (`CLAUDE.md`, `GEMINI.md`, etc.)
5. **Keep it concise** -- every line in the config costs tokens. Do not add prose that does not change agent behavior

Open an issue first for large changes or new modules.

---

## License

MIT
