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

# Check if file is valid
validate_file() {
  if [[ ! -f "$1" ]]; then
    log_error "File not found: $1"
    return 1
  fi
  
  if [[ ! -r "$1" ]]; then
    log_error "Cannot read file: $1"
    return 1
  fi
  return 0
}

# Ensure passkey meets all requirements
validate_passkey() {
  local passkey="$1"
  local error_msg=""
  
  # Check length
  if [[ ${#passkey} -lt 12 ]]; then
    error_msg+="Passkey must be at least 12 characters long.\n"
  fi
  
  # Check for uppercase
  if [[ ! "$passkey" =~ [A-Z] ]]; then
    error_msg+="Passkey must contain at least one uppercase letter.\n"
  fi
  
  # Check for lowercase
  if [[ ! "$passkey" =~ [a-z] ]]; then
    error_msg+="Passkey must contain at least one lowercase letter.\n"
  fi
  
  # Check for numbers
  if [[ ! "$passkey" =~ [0-9] ]]; then
    error_msg+="Passkey must contain at least one number.\n"
  fi
  
  # Check for special characters
  if [[ ! "$passkey" =~ [[:punct:]] ]]; then
    error_msg+="Passkey must contain at least one special character.\n"
  fi
  
  if [[ -n "$error_msg" ]]; then
    log_error "Passkey does not meet requirements:"
    echo -e "$error_msg"
    return 1
  fi
  
  return 0
}

# Create the passkey
fetch_passkey() {
  local passkey1 passkey2

  prompt_hidden_input() {
    local label="$1"
    local input=""
    local char

    echo -e "${YELLOW}${label}${NC}"
    echo -n "> "

    while IFS= read -r -s -n1 char; do
      
      [[ $char == "" ]] && break
      
      if [[ $char == $'\x7f' ]]; then
        if [[ -n "$input" ]]; then
          input="${input%?}"
          echo -ne "\b \b"
        fi
      else
        input+="$char"
        echo -n '*'
      fi
    done
    echo
    REPLY="$input"
  }

    # Display passkey criteria
  while true; do
    echo
    echo -e "${BLUE}Passkey requirements:${NC}"
    echo -e "  - At least 12 characters"
    echo -e "  - Contains uppercase, lowercase, number, special character\n"

    prompt_hidden_input "Enter your passkey:"
    passkey1="$REPLY"

    if [[ -z "$passkey1" ]]; then
      log_warning "Passkey cannot be empty"
      continue
    fi

    if ! validate_passkey "$passkey1"; then
      continue
    fi

    prompt_hidden_input "Confirm your passkey:"
    passkey2="$REPLY"

    if [[ "$passkey1" != "$passkey2" ]]; then
      log_error "Passkeys do not match. Please try again."
    else
      PASSKEY="$passkey1"
      return 0
    fi
  done
}

# Encrypt the data
encrypt_data() {
  local input_file="$1"
  local output_file="$2"
  
  validate_file "$input_file" || return 1
  
  if [[ -f "$output_file" ]]; then
    log_warning "Output file already exists: $output_file"
    read -p "Overwrite? (y/N): " overwrite
    if [[ "$(echo "$overwrite" | tr '[:upper:]' '[:lower:]')" != "y" ]]; then
      log_error "Operation cancelled by user"
      return 1
    fi
  fi

  echo -e "\n${BLUE}Initializing encryption...${NC}"
  openssl enc -in "$input_file" -out "$output_file" \
    -e -$DEFAULT_CIPHER -pass "pass:${PASSKEY}" \
    -pbkdf2 -iter $PBKDF2_ITERATIONS
  
    if [[ $? -ne 0 ]]; then
    log_error "Encryption failed"
    return 1
  fi

  local hmac_file="${output_file}.hmac"
  generate_hmac "$output_file" "$hmac_file"

  log_success "File successfully encrypted"
  echo -e "Encrypted file saved to: ${GREEN}$output_file${NC}"

}

# Decrypt the data
decrypt_data() {
  local input_file="$1"
  local output_file="$2"
  
  validate_file "$input_file" || return 1

  # Check HMAC
  verify_hmac "$input_file" "$input_file.hmac" || {
    log_error "Aborting decryption due to HMAC failure."
    return 1
  }

  if [[ -f "$output_file" ]]; then
    log_warning "Output file already exists: $output_file"
    read -p "Overwrite? (y/N): " overwrite
    if [[ "$(echo "$overwrite" | tr '[:upper:]' '[:lower:]')" != "y" ]]; then
      log_error "Operation cancelled by user"
      return 1
    fi
  fi

  echo -e "\n${BLUE}Initializing decryption...${NC}"
  openssl enc -in "$input_file" -out "$output_file" \
    -d -$DEFAULT_CIPHER -pass "pass:${PASSKEY}" \
    -pbkdf2 -iter $PBKDF2_ITERATIONS 2>/dev/null
  
  if [[ $? -eq 0 ]]; then
    log_success "File successfully decrypted"
    echo -e "Decrypted file saved to: ${GREEN}$output_file${NC}"
  else
    log_error "Decryption failed. Invalid passkey or corrupted file."
    [[ -f "$output_file" ]] && rm "$output_file"
    return 1
  fi
}

# Creates HMAC
generate_hmac() {
  local file="$1"
  local hmac_file="$2"
  echo -n "$PASSKEY" | openssl dgst -sha256 -hmac "$(cat -)" "$file" | awk '{print $2}' > "$hmac_file"
  log_success "HMAC generated and saved to: $hmac_file" 
}

# Verifies HMAC is correct
verify_hmac() {
  local file="$1"
  local hmac_file="$2"

  if [[ ! -f "$hmac_file" ]]; then
    log_error "Missing HMAC file: $hmac_file"
    return 1
  fi

  local expected
  expected=$(cat "$hmac_file")
  local actual
  actual=$(echo -n "$PASSKEY" | openssl dgst -sha256 -hmac "$(cat -)" "$file" | awk '{print $2}')

  if [[ "$expected" != "$actual" ]]; then
    log_error "HMAC verification failed! File may be corrupted or tampered with."
    return 1
  fi

  log_success "HMAC verification passed."
  return 0
}

# Display menu options
show_menu() {
  while true; do
    display_header
    echo -e "${YELLOW}Select an operation:${NC}"
    echo -e "1) Encrypt file"
    echo -e "2) Decrypt file"
    echo -e "3) Exit"
    echo -n -e "\n${BLUE}Enter your choice [1-3]: ${NC}"
    
    read -r choice
    case $choice in
      1)
        read -p "Enter path of file to encrypt: " input_file
        read -p "Enter output filename for encrypted file: " output_file
        fetch_passkey
        encrypt_data "$input_file" "$output_file"
        ;;
      2)
        read -p "Enter path of file to decrypt: " input_file
        read -p "Enter output filename for decrypted file: " output_file
        fetch_passkey
        decrypt_data "$input_file" "$output_file"
        ;;
      3)
        echo -e "\n${BLUE}Terminating session...${NC}"
        exit 0
        ;;
      *)
        log_error "Invalid selection. Please choose 1, 2, or 3."
        ;;
    esac
    
    read -n 1 -s -r -p $'\nPress any key to continue...'
  done
}

# Main execution
trap 'log_error "Script interrupted by user"; exit 1' INT
show_menu 