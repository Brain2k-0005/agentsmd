# Autonomous Agent Config

Universal setup for AI coding agents that learn, plan, and ship code autonomously.

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
│   ├── GEMINI.md                  # Gemini CLI specific config
│   └── claude-settings.json       # Claude Code settings template
├── project/
│   ├── AGENTS.md                  # Generic project template
│   └── presets/
│       ├── generic/AGENTS.md      # Fallback template
│       ├── nextjs/AGENTS.md       # Next.js preset
│       ├── dotnet/AGENTS.md       # .NET preset
│       ├── python/AGENTS.md       # Python preset
│       ├── nodejs/AGENTS.md       # Node.js preset
│       ├── go/AGENTS.md           # Go preset
│       ├── rust/AGENTS.md         # Rust preset
│       ├── java/AGENTS.md         # Java preset
│       ├── ruby/AGENTS.md         # Ruby preset
│       ├── php/AGENTS.md          # PHP preset
│       ├── c/AGENTS.md            # C preset
│       ├── cpp/AGENTS.md          # C++ preset
│       ├── csharp/AGENTS.md       # C# preset
│       ├── kotlin/AGENTS.md       # Kotlin preset
│       ├── swift/AGENTS.md        # Swift preset
│       ├── react/AGENTS.md        # React preset
│       ├── vue/AGENTS.md          # Vue preset
│       ├── angular/AGENTS.md      # Angular preset
│       ├── flutter/AGENTS.md      # Flutter preset
│       ├── svelte/AGENTS.md       # Svelte preset
│       ├── remix/AGENTS.md        # Remix preset
│       ├── astro/AGENTS.md        # Astro preset
│       ├── solid/AGENTS.md        # Solid preset
│       ├── solidstart/AGENTS.md   # SolidStart preset
│       ├── nestjs/AGENTS.md       # NestJS preset
│       ├── express/AGENTS.md      # Express preset
│       ├── laravel/AGENTS.md      # Laravel preset
│       ├── fastapi/AGENTS.md      # FastAPI preset
│       ├── django/AGENTS.md       # Django preset
│       ├── bun/AGENTS.md          # Bun preset
│       ├── deno/AGENTS.md         # Deno preset
│       ├── vite/AGENTS.md         # Vite preset
│       ├── tanstack/AGENTS.md     # TanStack preset
│       ├── tauri/AGENTS.md        # Tauri preset
│       ├── elixir/AGENTS.md       # Elixir preset
│       ├── perl/AGENTS.md         # Perl preset
│       └── scala/AGENTS.md        # Scala preset
├── modules/
│   ├── agent-teams.md             # Multi-agent coordination
│   ├── tdd.md                     # Test-driven development
│   ├── code-review.md             # Automated code review
│   ├── skill-discovery.md         # Skill/plugin discovery
│   ├── quality-gates.md           # Verification checklist
│   └── token-efficiency.md        # Token optimization + CLI vs MCP
└── examples/
    ├── nextjs/AGENTS.md           # Example for Next.js projects
    ├── dotnet/AGENTS.md           # Example for .NET projects
    └── python/AGENTS.md           # Example for Python projects
```

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

### Recommended Claude Code Plugins / Skills

If using Claude Code, these plugins and skills extend the autonomous workflow:

| Plugin | Purpose |
|--------|---------|
| `superpowers` | Workflow skills: planning, parallel agents, writing |
| `code-review` | Automated review against checklists |
| `frontend-design` | UI component generation (optional) |
| `stripe` | Stripe API integration (if applicable) |
| `supabase` | Supabase integration (if applicable) |

Install plugins via `/install-skill <name>` inside Claude Code.

Useful globally installed skills:

- `find-skills` for skill discovery and installation
- planning and implementation skills for non-trivial work
- debugging, testing, review, and quality-gate skills
- git workflow skills for commit and PR hygiene

---

## Quick Start

### Automated Install

```bash
# Clone the repo
git clone <repo-url>
cd autonomous-agents

# Interactive installer — detects your tools and copies the right files
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

Copy only what you need:

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

Available stacks: angular, astro, bun, c, cpp, csharp, deno, django, dotnet, elixir, express, fastapi, flutter, generic, go, java, kotlin, laravel, nestjs, nextjs, nodejs, perl, php, python, react, remix, ruby, rust, scala, solid, solidstart, svelte, swift, tanstack, tauri, vite, vue.

---

## How It Works

### Config Hierarchy

Configuration flows from general to specific, with later layers overriding earlier ones:

```
Global AGENTS.md          Base rules for all projects and all tools
  └── Tool-specific       CLAUDE.md / GEMINI.md enhancements
       └── Project AGENTS.md    Project-level overrides and context
            └── Modules         Composable behaviors (add/remove as needed)
```

- **Global AGENTS.md** -- applies to every project you open. Defines planning discipline, skill discovery, review habits, git conventions, and quality gates.
- **CLAUDE.md / GEMINI.md** -- tool-specific extensions that use features unique to that CLI (skills, MCP servers, model routing, presets).
- **Project AGENTS.md** -- lives in each repo root. Describes the stack, folder structure, test commands, project-specific rules, and useful skills.
- **Project presets** -- stack-specific templates you can copy into a new repo before customizing. The current catalog includes generic, Next.js, .NET, Python, Node.js, Go, Rust, Java, Ruby, PHP, C, C++, C#, Kotlin, Swift, React, Vue, Angular, Flutter, Svelte, Remix, Astro, Solid, SolidStart, NestJS, Express, Laravel, FastAPI, Django, Bun, Deno, Vite, TanStack, Tauri, Elixir, Perl, and Scala.
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

### CLI vs MCP Decision Matrix

| Operation | Prefer | Why |
|-----------|--------|-----|
| Read a known file | Dedicated `Read` tool | Direct, line numbers, no overhead |
| Search for patterns | `Grep` / `Glob` tool | Faster than MCP, cheaper than Bash |
| Simple file ops | CLI (Bash) | One-shot, low token cost |
| Database queries | MCP server | Structured access, connection pooling |
| External API calls | MCP server | Auth handling, rate limiting |
| Browser automation | MCP server | Stateful multi-step workflows |

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

- `claude-settings.json` — conservative defaults (safe shell command patterns)
- `claude-settings-power.json` — unrestricted shell access for power users

Edit the appropriate file to control permissions:

- Which tools the agent can use without asking
- Which directories it can read/write
- Whether it can execute shell commands autonomously

Copy it to `~/.claude/settings.json` (global) or `.claude/settings.json` (per-project) with stricter overrides.

### Adding Skills

Use the `skill-discovery` module to find and install platform-specific plugins:

```
/install-skill superpowers      # Claude Code
/install-skill code-review      # Claude Code
```

---

## Tool Compatibility

The AGENTS.md standard is read by multiple tools. Here is where each tool looks for config:

| Tool | Global Config Location | Project Config Location |
|------|----------------------|------------------------|
| Claude Code | `~/.claude/AGENTS.md` + `CLAUDE.md` | `./AGENTS.md` + `.claude/settings.json` |
| Codex CLI | `~/.codex/AGENTS.md` | `./AGENTS.md` |
| Gemini CLI | `~/.gemini/AGENTS.md` + `GEMINI.md` | `./AGENTS.md` |
| GitHub Copilot | (via repository) | `./AGENTS.md` |
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
