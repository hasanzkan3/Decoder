#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
#YELLOW='\033[1;33m'
BLUE='\033[0;34m'
#CYAN='\033[0;36m'
NC='\033[0m'

log_success() {
  echo -e "${GREEN}[+] $1${NC}"
}

log_error() {
  echo -e "${RED}[-] $1${NC}"
}

log_info() {
  echo -e "${BLUE}[*] $1${NC}"
}

is_base32() {
  local input="$1"
  local len="${#input}"
  # Step 1: Length check
  # Base32 strings, including padding characters, must be a multiple of 8.
  if [ "$len" -eq 0] || [ $((len % 8)) -ne 0 ]; then
    return 1
  fi

  # Step 2: Character Set Validation (Regex)
  # Accepts characters from A to Z and between 2 and 7.
  # In the end, there may be a maximum of 6 ‘=’ characters (RFC 4648 standard).
  if ! [[ "$input" =~ ^[A-Z2-7]+=*$ ]]; then
    return 1
  fi

  # Step 3: Code Decoding and Readability Verification
  # It is fed into the base32 tool, and error messages are hidden.
  local decoded
  decoded=$(printf "%s" "$input" | base32 -d 2>/dev/null)

  # if base32 command give an error ($? != 0), it is invalid
  if [ $? -ne 0 ]; then
    return 1
  fi

  # Check that the output is not empty or completely meaningless binary rubbish:
  # Does is contain printable ASCII Character
  if [[ "$decoded" =~ [[:print:]] ]]; then
    return 0
  else
    return 1
  fi
}

#read -p "Enter an hash or encoded text: " value

#trimmed_string=$(echo "$value" | xargs)
#echo "$trimmed_string"
#length=${#trimmed_string}
#echo "Length of value is: $length"
