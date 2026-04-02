#!/usr/bin/env bash
set -euo pipefail

# Generate preset AGENTS.md files from template + YAML config
# Usage: ./generate-presets.sh [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_FILE="$SCRIPT_DIR/preset-template.md"
CONFIG_FILE="$SCRIPT_DIR/preset-config.yaml"
OUTPUT_BASE="$SCRIPT_DIR/../project/presets"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "[DRY RUN] No files will be written."
    echo ""
fi

# Validate required files exist
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "ERROR: Template file not found: $TEMPLATE_FILE" >&2
    exit 1
fi
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file not found: $CONFIG_FILE" >&2
    exit 1
fi

TMPDIR_WORK="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_WORK"' EXIT

# ── Phase 1: Parse YAML into per-preset field files ──────────────────────
# Each field is written to $TMPDIR_WORK/{preset}/{field}

current_preset=""
current_field=""
in_block=false
preset_keys=()

while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip comments and top-level "presets:" key
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ "$line" =~ ^presets:[[:space:]]*$ ]] && continue
    # Skip blank lines outside of block scalars
    if [[ -z "$line" ]] && ! $in_block; then
        continue
    fi

    # Preset key: 2-space indent, word, colon, nothing else
    if [[ "$line" =~ ^\ \ ([a-zA-Z_][a-zA-Z0-9_]*):[[:space:]]*$ ]]; then
        current_preset="${BASH_REMATCH[1]}"
        preset_keys+=("$current_preset")
        mkdir -p "$TMPDIR_WORK/$current_preset"
        current_field=""
        in_block=false
        continue
    fi

    # Field: 4-space indent, field_name: value
    if [[ "$line" =~ ^\ \ \ \ ([a-zA-Z_][a-zA-Z0-9_]*):[[:space:]]*(.*) ]]; then
        current_field="${BASH_REMATCH[1]}"
        local_value="${BASH_REMATCH[2]}"
        in_block=false

        if [[ "$local_value" == "|" ]]; then
            in_block=true
            # Clear the file
            > "$TMPDIR_WORK/$current_preset/$current_field"
        elif [[ "$local_value" == '""' ]]; then
            printf '' > "$TMPDIR_WORK/$current_preset/$current_field"
        else
            # Strip surrounding quotes
            local_value="${local_value#\"}"
            local_value="${local_value%\"}"
            printf '%s' "$local_value" > "$TMPDIR_WORK/$current_preset/$current_field"
        fi
        continue
    fi

    # Block scalar content: 6+ space indent
    if $in_block && [[ -n "$current_field" && -n "$current_preset" ]]; then
        # Strip exactly 6 leading spaces
        content="${line#      }"
        target="$TMPDIR_WORK/$current_preset/$current_field"
        if [[ -s "$target" ]]; then
            printf '\n%s' "$content" >> "$target"
        else
            printf '%s' "$content" >> "$target"
        fi
    fi

done < "$CONFIG_FILE"

# ── Phase 2: Generate each preset ────────────────────────────────────────

read_field() {
    local preset="$1" field="$2"
    local fpath="$TMPDIR_WORK/$preset/$field"
    if [[ -f "$fpath" ]]; then
        cat "$fpath"
    fi
}

echo "Generating presets from template..."
echo ""

generate_count=0

for key in "${preset_keys[@]}"; do
    output_dir="$OUTPUT_BASE/$key"
    output_file="$output_dir/AGENTS.md"

    # Read all field values
    p_name="$(read_field "$key" name)"
    p_overview="$(read_field "$key" overview)"
    p_commands="$(read_field "$key" commands)"
    p_tech_stack="$(read_field "$key" tech_stack)"
    p_code_style="$(read_field "$key" code_style)"
    p_skills="$(read_field "$key" skills)"
    p_test_command="$(read_field "$key" test_command)"
    p_test_framework="$(read_field "$key" test_framework)"
    p_testing="$(read_field "$key" testing)"
    p_never_modify="$(read_field "$key" never_modify)"
    p_external_services="$(read_field "$key" external_services)"

    # Default name to key if empty
    [[ -z "$p_name" ]] && p_name="$key"

    # Write field values to numbered temp files for awk
    for i in commands tech_stack code_style skills testing never_modify external_services; do
        read_field "$key" "$i" > "$TMPDIR_WORK/_field_$i"
    done

    # Generate using awk: read the template, do single-line replacements inline,
    # and for multi-line placeholders, insert content from the field files
    awk \
        -v p_name="$p_name" \
        -v p_overview="$p_overview" \
        -v p_test_command="$p_test_command" \
        -v p_test_framework="$p_test_framework" \
        -v f_commands="$TMPDIR_WORK/_field_commands" \
        -v f_tech_stack="$TMPDIR_WORK/_field_tech_stack" \
        -v f_code_style="$TMPDIR_WORK/_field_code_style" \
        -v f_skills="$TMPDIR_WORK/_field_skills" \
        -v f_testing="$TMPDIR_WORK/_field_testing" \
        -v f_never_modify="$TMPDIR_WORK/_field_never_modify" \
        -v f_external_services="$TMPDIR_WORK/_field_external_services" \
    '
    function insert_file(fpath,    fline) {
        while ((getline fline < fpath) > 0) {
            print fline
        }
        close(fpath)
    }
    {
        # Single-line replacements
        gsub(/\{\{name\}\}/, p_name)
        gsub(/\{\{overview\}\}/, p_overview)
        gsub(/\{\{test_command\}\}/, p_test_command)
        gsub(/\{\{test_framework\}\}/, p_test_framework)

        # Multi-line placeholder replacements
        if ($0 == "{{commands}}")            { insert_file(f_commands); next }
        if ($0 == "{{tech_stack}}")           { insert_file(f_tech_stack); next }
        if ($0 == "{{code_style}}")           { insert_file(f_code_style); next }
        if ($0 == "{{skills}}")              { insert_file(f_skills); next }
        if ($0 == "{{testing}}")             { insert_file(f_testing); next }
        if ($0 == "{{never_modify}}")        { insert_file(f_never_modify); next }
        if ($0 == "{{external_services}}")   {
            # Only insert if file is non-empty
            if ((getline fline < f_external_services) > 0) {
                print fline
                while ((getline fline < f_external_services) > 0) {
                    print fline
                }
                close(f_external_services)
            }
            next
        }

        print
    }
    ' "$TEMPLATE_FILE" > "$TMPDIR_WORK/_output.md"

    if $DRY_RUN; then
        echo "  [DRY RUN] Would generate: $output_file"
    else
        mkdir -p "$output_dir"
        cp "$TMPDIR_WORK/_output.md" "$output_file"
        echo "  Generated: $output_file"
    fi
    generate_count=$((generate_count + 1))
done

echo ""
echo "Done. $generate_count preset(s) processed."
