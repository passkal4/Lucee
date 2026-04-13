#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <input-jar|war|class|dir> <output-dir> [cfr-jar-path]"
  exit 1
fi

INPUT_PATH="$1"
OUTPUT_DIR="$2"
CFR_JAR="${3:-./tools/cfr.jar}"

if [[ ! -e "$INPUT_PATH" ]]; then
  echo "[ERR] Input not found: $INPUT_PATH"
  exit 1
fi

if [[ ! -f "$CFR_JAR" ]]; then
  echo "[ERR] CFR jar not found: $CFR_JAR"
  echo "Download from: https://www.benf.org/other/cfr/"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "[INFO] Decompiling $INPUT_PATH -> $OUTPUT_DIR"
java -jar "$CFR_JAR" "$INPUT_PATH" \
  --outputdir "$OUTPUT_DIR" \
  --silent true \
  --comments false \
  --caseinsensitivefs true

echo "[OK] Decompiled output: $OUTPUT_DIR"
