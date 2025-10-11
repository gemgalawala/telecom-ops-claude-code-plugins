#!/bin/bash
# PostToolUse hook script for the telecom-ops plugin.
# When Claude finishes running a tool, this script is triggered to perform additional processing.

set -euo pipefail

echo "[telecom-ops] PostToolUse hook triggered. This is where you could run kpt rendering or validation."

exit 0