#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$(cd "$SOURCE_DIR/.." && pwd)"
LIB_DIR="$SKILLS_DIR/high_assurance_agent_library"
DEST_DIR="$LIB_DIR/skills-core/visual-systems-architect-simulation-ops"
DEST_PARENT="$(dirname "$DEST_DIR")"

echo "Installing skill from '$SOURCE_DIR' to '$DEST_DIR'..."

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' not found."
    exit 1
fi

if [ ! -d "$LIB_DIR" ]; then
    echo "Error: Library directory '$LIB_DIR' not found."
    exit 1
fi

mkdir -p "$DEST_PARENT"
rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"

rsync -a --exclude '.DS_Store' "$SOURCE_DIR/" "$DEST_DIR/"

cd "$LIB_DIR" || {
    echo "Error: Could not change directory to '$LIB_DIR'"
    exit 1
}

echo "Validating skill..."
python3 halib.py validate "skills-core/visual-systems-architect-simulation-ops"

echo "Updating index..."
python3 halib.py index "skills-core"

echo "Skill installed successfully!"
