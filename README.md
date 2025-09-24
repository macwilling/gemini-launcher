### 🚀 Gemini Launcher

A simple Bash script to streamline launching the Gemini CLI, ensuring your project repository is up-to-date before you start chatting.

### ⬇️ Installation

The install.sh script provides a simple, guided installation process for macOS and other Unix-like systems.

**Run the Installer from GitHub:**

```shell
bash <(curl -s https://raw.githubusercontent.com/macwilling/gemini-launcher/main/install.sh)
```

**Enter Your Repository Path:**
The script will prompt you to drag and drop your main repository folder into the terminal. This sets the BASE_PATH for the launcher.

**Finish Setup:**
The script will create a project directory, download the necessary files, set permissions, and add an alias to your ~/.zshrc file.

**Reload Your Terminal:**
Close and reopen your terminal or run source ~/.zshrc to activate the new alias.

### ⚙️ Configuration

The launcher relies on a config file to define the base path for your repositories. The install.sh script handles this for you, but you can manually edit the file at ~/.gemini-launcher/config if needed.

### 🚀 Usage

After installation, simply type the alias in your terminal to launch the script:

```shell
mp-gemini
```

The launcher will display a list of projects in your base path. Select a project by entering its number, or type quit to exit. The script will update the selected repository and then launch the Gemini CLI for you.
