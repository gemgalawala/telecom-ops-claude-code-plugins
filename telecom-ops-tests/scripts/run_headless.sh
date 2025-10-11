#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
PROMPTS_DIR="$ROOT_DIR/prompts"
RUNS_DIR="$ROOT_DIR/runs"

mkdir -p "$RUNS_DIR"

echo "[headless] Scenario 1: Intent -> KRM"
claude -p "$(cat "$PROMPTS_DIR/S1_intent_to_krm.md")" | tee "$RUNS_DIR/S1.txt"

echo "[headless] Scenario 2: O2 status (stub)"
claude -p "$(cat "$PROMPTS_DIR/S2_o2_status.md")" | tee "$RUNS_DIR/S2.txt"

echo "[headless] Scenario 3: Hook verification"
claude -p "$(cat "$PROMPTS_DIR/S3_hook_check.md")" | tee "$RUNS_DIR/S3.txt"

echo "[headless] Done. See runs/ for outputs."
