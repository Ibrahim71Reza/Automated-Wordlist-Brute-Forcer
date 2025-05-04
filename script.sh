#!/bin/bash

# -----------------------------
# Configuration Section
# -----------------------------

# ONLY CHANGE THIS LINE TO USE A DIFFERENT TOOL. THIS HAS A SAMPLE CODE OF "FLASK-UNSIGN" REPLACE IT WITH YOUR DESIRED COMMAND 
# REMEMBER TO GIVE {WORDLIST} AT THE STRING POSITION OF YOU WILL AUTOMATE THE WORDLIST .
CRACK_COMMAND="flask-unsign --unsign --cookie 'eyJ1c2VyX2lkIjo2NH0.aBXk-w.9IG_iC3knD31G4toXeqFvAcGlrQ' --wordlist {WORDLIST} --no-literal-eval"

# Path to directory containing wordlists
# Plz change it with your desired wordlist bruteforcing directory
WORDLIST_DIR="/opt/SecLists/Passwords/"

# Output log file
LOG_FILE="./crack_log.txt"

# -----------------------------
# Color Constants
# -----------------------------
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
ORANGE='\033[0;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# -----------------------------
# Trap Ctrl+C to handle user interrupts gracefully
# -----------------------------
trap "echo -e '\n${ORANGE}[!] Interrupted by user. Exiting...${NC}'; exit 130" SIGINT

# -----------------------------
# Validate command syntax
# -----------------------------
if ! echo "$CRACK_COMMAND" | grep -q "{WORDLIST}"; then
    echo -e "${RED}[!] Invalid CRACK_COMMAND: Missing {WORDLIST} placeholder${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Starting cracking using command template...${NC}"
echo -e "${BLUE}[+] Tool Command: ${WHITE}${CRACK_COMMAND}${NC}"
echo "[+] Bruteforce started: $(date)" > "$LOG_FILE"

# -----------------------------
# Cracking Function
# -----------------------------
run_crack_command() {
    local wordlist_file="$1"
    [[ ! -f "$wordlist_file" ]] && return

    local run_cmd="${CRACK_COMMAND/\{WORDLIST\}/\"$wordlist_file\"}"
    echo -e "${WHITE}[*] Using wordlist: ${BLUE}${wordlist_file}${NC}"

    output=$(eval "$run_cmd" 2>&1)
    exit_code=$?

    # Check for success based on common tool outputs or clean exit
    if echo "$output" | grep -iqE "found|success|cracked|matched" || [[ $exit_code -eq 0 && -n "$output" ]]; then
        echo -e "${RED}[+] Cracked using: ${wordlist_file}${NC}"
        echo -e "${RED}$output${NC}"
        echo "[CRACKED] $(basename "$wordlist_file") - $(date '+%F %T')" >> "$LOG_FILE"
        exit 0
    fi

    # Detect specific error types
    local error_type="Unknown error"
    if echo "$output" | grep -iq "syntax"; then
        error_type="Syntax Error"
    elif echo "$output" | grep -iq "permission denied"; then
        error_type="Permission Denied"
    elif echo "$output" | grep -iq "not found"; then
        error_type="Command or File Not Found"
    elif echo "$output" | grep -iq "invalid"; then
        error_type="Invalid Argument"
    elif echo "$output" | grep -iq "exception"; then
        error_type="Runtime Exception"
    elif echo "$output" | grep -iq "failed"; then
        error_type="General Failure"
    elif [[ $exit_code -ne 0 && -z "$output" ]]; then
        error_type="Silent Failure (Empty Output)"
    fi

    # Print and log the error with type
    if [[ $exit_code -ne 0 ]]; then
        echo -e "${ORANGE}[!] Error (${error_type}) using ${wordlist_file}:${NC}"
        echo -e "${ORANGE}$output${NC}"
        echo "[ERROR] $(basename "$wordlist_file") - $error_type - $(date '+%F %T')" >> "$LOG_FILE"
    else
        echo -e "${WHITE}[-] Failed with: ${BLUE}$(basename "$wordlist_file")${NC}"
        echo "[FAILED] $(basename "$wordlist_file") - $(date '+%F %T')" >> "$LOG_FILE"
    fi
}

# -----------------------------
# Iterate All Wordlists
# -----------------------------
echo -e "${GREEN}[+] Starting to process wordlists...${NC}"
find "$WORDLIST_DIR" -type f | while read -r wordlist; do
    run_crack_command "$wordlist"
done

# -----------------------------
# Summary Report
# -----------------------------
echo -e "\n${GREEN}[+] All wordlists processed${NC}"
cracked=$(grep -c "^\[CRACKED\]" "$LOG_FILE" || echo 0)
failed=$(grep -c "^\[FAILED\]"  "$LOG_FILE" || echo 0)
errors=$(grep -c "^\[ERROR\]"   "$LOG_FILE" || echo 0)

echo -e "${GREEN}  -> Cracked: ${WHITE}$cracked${NC}"
echo -e "${RED}  -> Failed:  ${WHITE}$failed${NC}"
echo -e "${ORANGE}  -> Errors:  ${WHITE}$errors${NC}"
echo -e "${BLUE}[+] Detailed log in: ${WHITE}$LOG_FILE${NC}"
