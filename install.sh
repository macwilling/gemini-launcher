#!/bin/bash

# --- Color Codes ---
MP_GREEN='\033[0;32m'
MP_RED='\033[0;31m'
NC='\033[0m'

# --- Configuration ---
INSTALL_PATH="$HOME/projects/gemini-launcher"
SCRIPT_URL="https://raw.githubusercontent.com/macwilling/gemini-launcher/main/gemini-launcher.sh"
CONFIG_URL="https://raw.githubusercontent.com/macwilling/gemini-launcher/main/config.example"

# --- Installation Steps ---
echo "--- MP Gemini Launcher Installer ---"

# Step 1: Get the base path from the user
read -p "Enter the absolute path to your repositories: " BASE_PATH_INPUT

if [[ -z "$BASE_PATH_INPUT" ]]; then
  echo -e "${MP_RED}Error: A base path is required. Exiting.${NC}"
  exit 1
fi

# Step 2: Create the necessary folders
echo "Creating project directory..."
mkdir -p "$INSTALL_PATH"

# Step 3: Download the script files
echo "Downloading scripts from GitHub..."
curl -sL "$SCRIPT_URL" -o "$INSTALL_PATH/gemini-launcher.sh"
curl -sL "$CONFIG_URL" -o "$INSTALL_PATH/config"

# Step 4: Configure the base path
echo "Configuring the base path..."
sed -i '' "s|/your/path/to/repositories|${BASE_PATH_INPUT}|g" "$INSTALL_PATH/config"

# Step 5: Add the alias to .zshrc
echo "Adding alias to .zshrc..."
echo '' >> ~/.zshrc
echo '# MP Gemini Launcher Alias' >> ~/.zshrc
echo "alias mp-gemini=\"$INSTALL_PATH/gemini-launcher.sh\"" >> ~/.zshrc

# Step 6: Confirmation
echo -e "\n${MP_GREEN}Installation complete!${NC}"
echo "Run 'source ~/.zshrc' or open a new terminal to use 'mp-gemini'."
echo "Enjoy!"

exit 0
