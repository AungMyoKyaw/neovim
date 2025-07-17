#!/usr/bin/env bash
set -euo pipefail

# Neovim build and install script for macOS
# This script installs dependencies, builds, and installs Neovim from source.

# Colors for output
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

function info() {
  echo -e "${green}==> $1${reset}"
}
function error() {
  echo -e "${red}ERROR: $1${reset}" >&2
}

info "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
else
  info "Xcode Command Line Tools already installed."
fi

info "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  info "Homebrew already installed."
fi

info "Installing build dependencies (cmake, ninja, gettext, curl, luarocks)..."
brew install cmake ninja gettext curl luarocks

info "Building Neovim..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

info "Installing Neovim (may require sudo)..."
sudo make install

info "Checking if Neovim is in PATH..."
if command -v nvim &>/dev/null; then
  info "Neovim installed successfully: $(nvim --version | head -n 1)"
else
  error "Neovim binary not found in PATH. You may need to add it manually."
  echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
  info "Added /usr/local/bin to PATH in ~/.zshrc. Please restart your terminal."
fi

info "Done!"
