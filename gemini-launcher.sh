#!/bin/bash

# --- Color Codes ---
MP_DARK_BLUE='\033[0;34m'
MP_BLUE='\033[0;36m'
MP_GREEN='\033[0;32m'
MP_GOLD='\033[0;33m'
MP_FUCHSIA='\033[0;35m'
MP_RED='\033[0;31m'
NC='\033[0m'

# --- Configuration ---
BASE_PATH='/Users/macw/Library/CloudStorage/Dropbox/Mac (2)/Documents/GitHub/acst'

# --- Functions ---
check_dependencies() {
  if ! command -v gemini &> /dev/null; then
    echo -e "${MP_RED}Error: 'gemini' command not found. Please ensure it's in your PATH.${NC}"
    exit 1
  fi
}

git_spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  local i=0
  
  while kill -0 "$pid" 2>/dev/null; do
    local i=$(( (i+1) %4 ))
    printf "\r[%c]" "${spinstr:$i:1}"
    sleep "$delay"
  done
  printf "\r   \r"
}

launch_gemini() {
  local repo_path="$1"
  
  if ! cd "$repo_path"; then
    echo -e "\n${MP_RED}Error: Failed to change directory to ${repo_path}.${NC}"
    exit 1
  fi

  echo -e "\n${MP_BLUE}Updating repository: ${MP_GREEN}$(basename "$repo_path")${NC}"
  
  git pull --quiet &
  local pid=$!
  
  git_spinner "$pid"
  
  wait "$pid"
  local exit_code=$?
  
  if [ $exit_code -eq 0 ]; then
    echo -e "\n${MP_GREEN}Update successful.${NC}"
    echo -e "${MP_BLUE}Launching Gemini...${NC}"
    
    gemini
    
  else
    echo -e "\n${MP_RED}Error: Failed to update the repository. Exiting.${NC}"
    exit 1
  fi
}

# --- Main Script ---
check_dependencies

USER_NAME=$(whoami)

echo -e "${MP_BLUE}--- MP Gemini Launcher ---${NC}\n"
echo -e "${MP_FUCHSIA}Hello, ${USER_NAME}! Select a project to begin chatting with Gemini.${NC}\n"

if [ ! -d "$BASE_PATH" ]; then
  echo -e "${MP_RED}Error: The specified base path does not exist: $BASE_PATH${NC}"
  exit 1
fi

repos=()
while IFS= read -r dir; do
    dir_name="${dir#$BASE_PATH/}"
    repos+=("$dir_name")
done < <(find "$BASE_PATH" -mindepth 1 -maxdepth 1 -type d)

if [ ${#repos[@]} -eq 0 ]; then
    echo "No repositories found in the specified path."
    exit 0
fi

for i in "${!repos[@]}"; do
  echo -e "$((i+1))) ${repos[i]}"
done
echo -e "$(( ${#repos[@]} + 1 ))) ${MP_BLUE}Quit${NC}\n"

while true; do
  read -p "Select a project (enter number or 'quit' to exit): " choice
  
  if [[ "$choice" =~ ^[0-9]+$ ]]; then
    quit_number=$(( ${#repos[@]} + 1 ))
    if [[ "$choice" -ge 1 && "$choice" -le "$quit_number" ]]; then
      if [[ "$choice" -eq "$quit_number" ]]; then
        echo -e "${MP_BLUE}See you later!${NC}"
        break
      else
        selected_repo="${repos[choice-1]}"
        full_path="$BASE_PATH/$selected_repo"
        launch_gemini "$full_path"
        break
      fi
    else
      echo -e "${MP_RED}Invalid number. Please enter a number between 1 and ${quit_number} inclusive.${NC}"
    fi
  elif [[ "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" == "quit" ]]; then
    echo -e "${MP_BLUE}See you later!${NC}"
    break
  else
    echo -e "${MP_RED}Invalid selection. Please enter a number or type 'quit' to exit.${NC}"
  fi
done