#!/usr/bin/env bash
# ==============================================================================
# sync-skills.sh: Sync central agent skills into a downstream project repository
# ==============================================================================
set -euo pipefail

# Configuration
SOURCE_REPO_DEFAULT="https://github.com/rajakula1/agent-skills.git"
TARGET_DIR="${1:-.skills}"
TEMP_CLONE_DIR=$(mktemp -d /tmp/agent-skills-sync.XXXXXX)

cleanup() {
  rm -rf "${TEMP_CLONE_DIR}"
}
trap cleanup EXIT

echo "=== Syncing Agent Skills ==="
echo "Target directory: ${TARGET_DIR}"

# 1. Clone latest skills repository
REPO_URL="${AGENT_SKILLS_REPO:-${SOURCE_REPO_DEFAULT}}"

if [ -d "../skills" ]; then
  # Local filesystem fallback if run alongside or within mono-environment
  echo "Found local skills source directory. Copying locally..."
  mkdir -p "${TARGET_DIR}"
  cp -R ../skills/* "${TARGET_DIR}/"
else
  echo "Cloning skills from ${REPO_URL}..."
  git clone --depth 1 "${REPO_URL}" "${TEMP_CLONE_DIR}"
  mkdir -p "${TARGET_DIR}"
  cp -R "${TEMP_CLONE_DIR}/skills/"* "${TARGET_DIR}/"
fi

# 2. Setup universal vendor pointers if requested
if [ "${SETUP_AGENTS_MD:-true}" = "true" ] && [ ! -f "AGENTS.md" ]; then
  if [ -f "${TEMP_CLONE_DIR}/templates/AGENTS.md" ]; then
    echo "Initializing AGENTS.md in project root..."
    cp "${TEMP_CLONE_DIR}/templates/AGENTS.md" ./AGENTS.md
  fi
fi

# 3. Setup agent symlinks if directories exist
if [ -d ".claude" ] && [ ! -e ".claude/skills" ]; then
  echo "Linking .claude/skills -> ${TARGET_DIR}..."
  ln -s "../${TARGET_DIR}" ".claude/skills"
fi

if [ -d ".cursor" ] && [ ! -e ".cursor/rules" ]; then
  echo "Linking .cursor/rules -> ${TARGET_DIR}..."
  ln -s "../${TARGET_DIR}" ".cursor/rules"
fi

echo "=== Agent Skills successfully synced to ${TARGET_DIR}! ==="
echo "Skills installed:"
ls -1 "${TARGET_DIR}"
