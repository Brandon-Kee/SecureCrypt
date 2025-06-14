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