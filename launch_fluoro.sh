#!/usr/bin/env bash
#
# Launch FluoroSim: the on-screen FLUORO simulation window AND the web control
# panel server from one process (fluoro_web.py, default window mode).
#
# The control panel is NOT opened on the Raspberry Pi itself — connect to it
# from a phone/tablet/browser on the same network at:
#
#     https://<this-pi-ip>:5000/
#
# Wired to the desktop shortcut ~/Desktop/FluoroSim.desktop.

set -u
cd "$(dirname "$(readlink -f "$0")")"

# Log every launch (and all of fluoro_web.py's output) so a failed desktop
# double-click can be diagnosed even though no terminal is attached.
LOG="$(pwd)/launch.log"
exec >>"$LOG" 2>&1
echo "===== launch $(date '+%Y-%m-%d %H:%M:%S')  DISPLAY=${DISPLAY:-unset}  WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-unset}  PWD=$(pwd) ====="

# OpenCV's Qt GUI needs the X11/XWayland backend for the fullscreen toggle to
# work (fluoro_web.py also sets this, but be explicit for the desktop launch).
export QT_QPA_PLATFORM=xcb

# A desktop double-click usually has no DISPLAY for X apps under a Wayland
# session; fall back to :0 so the FLUORO window can open.
export DISPLAY="${DISPLAY:-:0}"

# Serves the panel and shows the FLUORO window (no --no-window).
exec python3 fluoro_web.py
