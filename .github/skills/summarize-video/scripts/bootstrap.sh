#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: bootstrap.sh [options]

Diagnose, install, and configure summarize.sh.

Options:
  --verify                  Show summarize/tooling status.
  --install                 Install summarize if it is missing.
  --config                  Create ~/.summarize/config.json if missing.
  --cli-provider PROVIDER   Prefer one CLI provider in new config.
                            Allowed: claude, codex, gemini, agent, openclaw, opencode, copilot
  --install-media           Install optional media tools when supported.
  --help                    Show this help.

Default behavior is the same as --verify.
USAGE
}

VERIFY=false
INSTALL=false
CONFIG=false
INSTALL_MEDIA=false
CLI_PROVIDER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --verify)
      VERIFY=true
      shift
      ;;
    --install)
      INSTALL=true
      shift
      ;;
    --config)
      CONFIG=true
      shift
      ;;
    --cli-provider)
      CLI_PROVIDER="${2:-}"
      if [[ -z "$CLI_PROVIDER" ]]; then
        echo "--cli-provider requires a value" >&2
        exit 2
      fi
      shift 2
      ;;
    --install-media)
      INSTALL_MEDIA=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if ! $VERIFY && ! $INSTALL && ! $CONFIG && ! $INSTALL_MEDIA; then
  VERIFY=true
fi

require_provider_name() {
  case "$1" in
    ""|claude|codex|gemini|agent|openclaw|opencode|copilot)
      ;;
    *)
      echo "Unsupported CLI provider: $1" >&2
      exit 2
      ;;
  esac
}

node_major() {
  if ! command -v node >/dev/null 2>&1; then
    return 1
  fi
  node -p 'Number(process.versions.node.split(".")[0])'
}

node_is_24_or_newer() {
  local major
  major="$(node_major 2>/dev/null || true)"
  [[ -n "$major" && "$major" -ge 24 ]]
}

load_nvm() {
  if command -v nvm >/dev/null 2>&1; then
    return 0
  fi

  local nvm_dir="${NVM_DIR:-$HOME/.nvm}"
  if [[ -s "$nvm_dir/nvm.sh" ]]; then
    # shellcheck disable=SC1090
    . "$nvm_dir/nvm.sh"
  fi

  command -v nvm >/dev/null 2>&1
}

ensure_node_24_with_nvm() {
  if node_is_24_or_newer; then
    return 0
  fi

  if ! load_nvm; then
    return 1
  fi

  nvm install 24
  nvm use 24
  hash -r
  node_is_24_or_newer
}

show_status() {
  if command -v summarize >/dev/null 2>&1; then
    echo "summarize: $(command -v summarize)"
    summarize --version || true
  else
    echo "summarize: missing"
  fi

  if [[ -x "$HOME/.local/bin/summarize" ]]; then
    echo "launcher: $HOME/.local/bin/summarize"
  else
    echo "launcher: missing"
  fi

  if command -v node >/dev/null 2>&1; then
    echo "node: $(node --version)"
  else
    echo "node: missing"
  fi

  if command -v npm >/dev/null 2>&1; then
    echo "npm: $(npm --version)"
  else
    echo "npm: missing"
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "brew: $(brew --version | head -n 1)"
  else
    echo "brew: missing"
  fi

  if load_nvm; then
    echo "nvm: available"
  else
    echo "nvm: missing"
  fi

  for provider in claude codex gemini agent openclaw opencode copilot; do
    if command -v "$provider" >/dev/null 2>&1; then
      echo "$provider: $(command -v "$provider")"
    else
      echo "$provider: missing"
    fi
  done

  for tool in ffmpeg yt-dlp tesseract whisper-cli; do
    if command -v "$tool" >/dev/null 2>&1; then
      echo "$tool: $(command -v "$tool")"
    else
      echo "$tool: missing"
    fi
  done
}

install_launcher() {
  local launcher_dir="$HOME/.local/bin"
  local launcher_file="$launcher_dir/summarize"

  mkdir -p "$launcher_dir"

  cat >"$launcher_file" <<'SH'
#!/usr/bin/env bash
set -euo pipefail

nvm_dir="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$nvm_dir/nvm.sh" ]]; then
  # shellcheck disable=SC1090
  . "$nvm_dir/nvm.sh"
fi

if command -v nvm >/dev/null 2>&1; then
  nvm exec 24 summarize "$@"
  exit $?
fi

if [[ -x "$nvm_dir/versions/node/v24.15.0/bin/node" && -x "$nvm_dir/versions/node/v24.15.0/bin/summarize" ]]; then
  exec "$nvm_dir/versions/node/v24.15.0/bin/node" "$nvm_dir/versions/node/v24.15.0/bin/summarize" "$@"
fi

echo "summarize launcher could not find Node 24 via nvm" >&2
exit 127
SH

  chmod +x "$launcher_file"
  echo "Created launcher: $launcher_file"
}

install_summarize() {
  if command -v summarize >/dev/null 2>&1; then
    echo "summarize already installed: $(command -v summarize)"
    install_launcher
    return 0
  fi

  if command -v npm >/dev/null 2>&1 && node_is_24_or_newer; then
    npm i -g @steipete/summarize
    install_launcher
    return 0
  fi

  if ensure_node_24_with_nvm && command -v npm >/dev/null 2>&1; then
    npm i -g @steipete/summarize
    install_launcher
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    brew install summarize
    install_launcher
    return 0
  fi

  if command -v npm >/dev/null 2>&1; then
    echo "npm is available, but summarize requires Node 24 or newer." >&2
    echo "Install Node 24+, then rerun this script with --install." >&2
    exit 1
  fi

  echo "Could not install summarize automatically. Install Node 24+ and npm, or install Homebrew." >&2
  exit 1
}

write_config() {
  require_provider_name "$CLI_PROVIDER"

  local config_dir="$HOME/.summarize"
  local config_file="$config_dir/config.json"

  mkdir -p "$config_dir"

  if [[ -e "$config_file" ]]; then
    echo "Config already exists: $config_file"
    echo "Leaving it unchanged."
    return 0
  fi

  if [[ -n "$CLI_PROVIDER" ]]; then
    cat >"$config_file" <<JSON
{
  "model": "auto",
  "output": {
    "length": "long",
    "language": "auto"
  },
  "youtube": "auto",
  "firecrawl": "auto",
  "cli": {
    "enabled": ["$CLI_PROVIDER"],
    "autoFallback": {
      "enabled": true,
      "onlyWhenNoApiKeys": true,
      "order": ["$CLI_PROVIDER"]
    }
  }
}
JSON
  else
    cat >"$config_file" <<'JSON'
{
  "model": "auto",
  "output": {
    "length": "long",
    "language": "auto"
  },
  "youtube": "auto",
  "firecrawl": "auto",
  "cli": {
    "enabled": ["claude", "gemini", "codex", "agent", "openclaw", "opencode", "copilot"],
    "autoFallback": {
      "enabled": true,
      "onlyWhenNoApiKeys": true,
      "order": ["claude", "gemini", "codex", "agent", "openclaw", "opencode", "copilot"]
    }
  }
}
JSON
  fi

  echo "Created config: $config_file"
}

install_media_deps() {
  if command -v brew >/dev/null 2>&1; then
    brew install ffmpeg yt-dlp tesseract
    if brew info whisper-cpp >/dev/null 2>&1; then
      brew install whisper-cpp
    fi
    return 0
  fi

  if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y ffmpeg yt-dlp tesseract-ocr
    echo "whisper.cpp is optional; install it from a binary release or build from source if needed."
    return 0
  fi

  echo "No supported package manager found for optional media dependencies." >&2
  echo "Install ffmpeg, yt-dlp, tesseract, and optionally whisper.cpp manually." >&2
  exit 1
}

if $INSTALL; then
  install_summarize
fi

if $CONFIG; then
  write_config
fi

if $INSTALL_MEDIA; then
  install_media_deps
fi

if $VERIFY; then
  show_status
fi
