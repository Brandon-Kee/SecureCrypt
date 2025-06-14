#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Security configuration
DEFAULT_CIPHER="aes-256-cbc"
PBKDF2_ITERATIONS=100000
TEMP_DIR="/tmp/crypto_$(date +%s)"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create temporary working directory
mkdir -p "$TEMP_DIR"
trap 'rm -rf "$TEMP_DIR"' EXIT

display_header() {
  clear
  echo -e "${BLUE}"
  echo "┌─────────────────────────────────────────────────┐"
  echo "│          SECURE ENCYPTION & DECRYPTION          │"
  echo "│               AES-256 + PBKDF2                  │"
  echo "└─────────────────────────────────────────────────┘"
  echo -e "${NC}"
}

log_success() {
  echo -e "${GREEN}[✓] $1${NC}"
}

log_error() {
  echo -e "${RED}[✗] $1${NC}" >&2
}

log_warning() {
  echo -e "${YELLOW}[!] $1${NC}"
}