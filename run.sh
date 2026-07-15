#!/usr/bin/env bash
# PianoBooster dev launcher: incremental rebuild, then run.
#   ./run.sh                 build (if needed) and launch
#   ./run.sh path/to/song.mid   ...and open a MIDI file
#   ./run.sh --no-build      skip the build step, just launch
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$ROOT/build"
BIN="$BUILD/build/pianobooster"

build=1
if [[ "${1:-}" == "--no-build" ]]; then build=0; shift; fi

# First-time setup: configure the build dir if it isn't there yet.
if [[ ! -f "$BUILD/Makefile" ]]; then
    echo ">> Configuring build (first run)..."
    cmake -S "$ROOT" -B "$BUILD" -DQT_PACKAGE_NAME=Qt6
fi

if [[ "$build" == 1 ]]; then
    echo ">> Building (incremental)..."
    make -C "$BUILD" -j"$(nproc)"
fi

echo ">> Launching PianoBooster..."
exec "$BIN" "$@"
