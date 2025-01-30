#!/bin/bash
# This script downloads and utilizes mymcplusplus, which is licensed under GPLv3: https://github.com/Adubbz/mymcplusplus

echo -e "\e[32mUpdating Termux package lists...\e[0m"
pkg update -y && \
echo -e "\e[32mUpgrading Termux packages...\e[0m" && \
yes | pkg upgrade && \
echo -e "\e[32mGranting Termux Storage Access...\e[0m" && \
yes | termux-setup-storage

# Allow some time for the user to grant storage access
echo -e "\e[32mPlease allow storage access...\e[0m"
sleep 5
# Simulate pressing Enter to continue the script
printf '\n' | read

echo -e "\e[32mInstalling proot-distro...\e[0m"
pkg install proot-distro -y
echo -e "\e[32mSetting up Ubuntu environment inside proot-distro...\e[0m"
proot-distro install ubuntu
echo -e "\e[32mLogging into the installed Ubuntu environment and running the rest of the setup script...\e[0m"
proot-distro login ubuntu << 'EOF'

echo -e "\e[32mUpdating Ubuntu package lists...\e[0m"
apt update -y && \
echo -e "\e[32mUpgrading Ubuntu packages...\e[0m" && \
apt upgrade -y && \
echo -e "\e[32mInstalling python3...\e[0m" && \
apt install python3 -y && \
echo -e "\e[32mInstalling pipx...\e[0m" && \
apt install pipx -y && \
echo -e "\e[32mInstalling mymcplusplus...\e[0m" && \
pipx install mymcplusplus && \
echo -e "\e[32mAllowing pipx path access...\e[0m" && \
pipx ensurepath

EOF

# Now create the mymc.sh script in Termux home directory
cat > $HOME/mymc.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ANSI escape codes for text color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# Path to mymcplusplus executable
MYMCPLUSPLUS="/root/.local/bin/mymcplusplus"

# Function to run mymcplusplus commands in the Ubuntu environment
run_mymcplusplus_command() {
  case $1 in
    1)  # Import save files into the memory card
      proot-distro login ubuntu -- bash -c "$MYMCPLUSPLUS \"$2\" import \"$3\"" && echo -e "${GREEN}Successfully imported $3${RESET}"
      ;;
    2)  # Export save files from the memory card
      proot-distro login ubuntu -- bash -c "$MYMCPLUSPLUS \"$2\" export \"$4\"" && echo -e "${GREEN}Successfully exported $4${RESET}"
      ;;
    3)  # Display save file information
      proot-distro login ubuntu -- bash -c "$MYMCPLUSPLUS \"$2\" dir"
      ;;
    4)  # Delete a save file
      proot-distro login ubuntu -- bash -c "$MYMCPLUSPLUS \"$2\" delete \"$4\"" && echo -e "${GREEN}Successfully deleted $4${RESET}"
      ;;
    *)
      echo -e "${RED}Invalid choice. Please select a valid command number.${RESET}"
      ;;
  esac
}

# Display menu and prompt for user input
while true; do
  echo -e "${BOLD}${RESET}Supported commands:${RESET}"
  echo -e "${GREEN}1) Import save files into the memory card${RESET}"
  echo -e "${YELLOW}2) Export save files from the memory card${RESET}"
  echo -e "${BLUE}3) Display save file information${RESET}"
  echo -e "${MAGENTA}4) Delete a save file${RESET}"
  echo -e "${RED}5) Exit${RESET}"

  read -p "Enter the number of the command you want to execute (1-5): " choice

  # Check if the choice is within range
  if (( choice >= 1 && choice <= 5 )); then
    if [ $choice -eq 5 ]; then
      echo -e "${RED}Exiting...${RESET}"
      break
    fi

    read -p "Enter the path to the memory card: " memcard_path
    if [ $choice -eq 1 ]; then
      read -p "Enter the path to the save file: " savefile_path
      run_mymcplusplus_command $choice "$memcard_path" "$savefile_path"
    elif [ $choice -eq 2 ]; then
      read -p "Enter the name of the save file: " savefile_name
      run_mymcplusplus_command $choice "$memcard_path" "" "$savefile_name"
      mv "/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root/$savefile_name.psu" "$(dirname "$memcard_path")"
    elif [ $choice -eq 4 ]; then
      read -p "Enter the name of the save file: " savefile_name
      run_mymcplusplus_command $choice "$memcard_path" "" "$savefile_name"
    else
      run_mymcplusplus_command $choice "$memcard_path"
    fi
  else
    echo -e "${RED}Invalid choice. Please select a number between 1 and 5.${RESET}"
  fi
done

# Exit the script
exit 0
EOF

# Give the script execute permissions
chmod +x $HOME/mymc.sh

# Successful message
echo -e "\033[0;32mmymc.sh has been created and given execute permissions. You can now run it with: ./mymc.sh\033[0m"
