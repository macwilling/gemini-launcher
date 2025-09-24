#!/bin/bash

# --- Color Codes ---
DARK_BLUE='\033[0;34m'
FUCHSIA='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# --- Configuration ---
INSTALL_PATH="$HOME/.gemini-launcher"
SCRIPT_URL="https://raw.githubusercontent.com/macwilling/gemini-launcher/main/gemini-launcher.sh"
CONFIG_URL="https://raw.githubusercontent.com/macwilling/gemini-launcher/main/config.example"

# --- Installation Steps ---
echo
echo -e "${DARK_BLUE}╔════════════════════════════╗${NC}"
echo -e "${DARK_BLUE}║${NC} ${GREEN}  Install Gemini Launcher ${NC} ${DARK_BLUE}║${NC}"
echo -e "${DARK_BLUE}╚════════════════════════════╝${NC}"

# Step 1: Get the base path from the user
echo
echo -e "${FUCHSIA}Let's get started!${NC}"
sleep 1
echo -e "We need to know where your repositories are located."
echo -e "Step 1. Open Finder"
echo -e "Step 2. Find the folder that contains all your repositories."
echo -e "Step 3. ${FUCHSIA}Drag${NC} that folder directly into this terminal window."
echo -e "Step 4. Press ${FUCHSIA}Enter${NC} to confirm."
echo
echo -e "It will look something like: ${GREEN}Users/macw/documents/GitHub${NC}"
echo
echo -e "Enter path to repositories below: "
echo -e "---------------------------------${GREEN}"
read -r BASE_PATH_INPUT
echo -e "${NC}---------------------------------"

if [[ -z "$BASE_PATH_INPUT" ]]; then
  echo -e "${RED}Error: A base path is required. Exiting.${NC}"
  exit 1
fi

# Step 2: Create the necessary folders
echo
echo -e "${FUCHSIA}Creating project directory...${NC}"
if ! mkdir -p "$INSTALL_PATH"; then
  echo -e "${RED}Error: Failed to create directory. Exiting.${NC}"
  exit 1
fi

# Step 3: Download the script files
echo
echo -e "${FUCHSIA}Downloading scripts from GitHub...${NC}"
if ! curl -sL "$SCRIPT_URL" -o "$INSTALL_PATH/gemini-launcher.sh"; then
  echo -e "${RED}Error: Failed to download the main script. Exiting.${NC}"
  exit 1
fi
if ! curl -sL "$CONFIG_URL" -o "$INSTALL_PATH/config"; then
  echo -e "${RED}Error: Failed to download the config file. Exiting.${NC}"
  exit 1
fi

# Step 4: Make the script executable
echo
echo -e "${FUCHSIA}Setting file permissions...${NC}"
if ! chmod +x "$INSTALL_PATH/gemini-launcher.sh"; then
    echo -e "${RED}Error: Failed to set executable permission. Exiting.${NC}"
    exit 1
fi

# Step 5: Configure the base path
echo
echo -e "${FUCHSIA}Configuring the base path...${NC}"
if ! sed -i '' "s|/your/path/to/repositories|${BASE_PATH_INPUT}|g" "$INSTALL_PATH/config"; then
  echo -e "${RED}Error: Failed to configure the base path. Exiting.${NC}"
  exit 1
fi

# Step 6: Add the alias to .zshrc
echo
echo -e "${FUCHSIA}Adding alias to .zshrc...${NC}"
echo '' >> ~/.zshrc
echo '# MP Gemini Launcher Alias' >> ~/.zshrc
echo "alias mp-gemini=\"$INSTALL_PATH/gemini-launcher.sh\"" >> ~/.zshrc

# Step 7: Confirmation and instructions
echo
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${DARK_BLUE}Next Steps:${NC}"
echo -e "1. Close and reopen your terminal, or run: ${GREEN}source ~/.zshrc${NC}"
echo -e "2. Type: ${GREEN}mp-gemini${NC} to begin."
echo
echo -e "Enjoy!"

exit 0