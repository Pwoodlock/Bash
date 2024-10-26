#!/bin/bash
#####################################################################
# AIO QEMU Installer for common Distros
#



echo "  $$$$$$$\                       $$$$$$\                      "
echo "  $$  __$$\                     $$  __$$\                     "
echo "  $$ |  $$ | $$$$$$\ $$\    $$\ $$ /  \__| $$$$$$\   $$$$$$$\ "
echo "  $$ |  $$ |$$  __$$\\$$\  $$  |\$$$$$$\  $$  __$$\ $$  _____|"
echo "  $$ |  $$ |$$$$$$$$ |\$$\$$  /  \____$$\ $$$$$$$$ |$$ /      "
echo "  $$ |  $$ |$$   ____| \$$$  /  $$\   $$ |$$   ____|$$ |      "
echo "  $$$$$$$  |\$$$$$$$\   \$  /   \$$$$$$  |\$$$$$$$\ \$$$$$$$\ "
echo "  \_______/  \_______|   \_/     \______/  \_______| \_______|"
echo "                                                              "
echo "                                                              "
echo "                                                              "
echo "                           QEMU AIO Setup                     "
echo



# Is this running as root ?
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root. Please use sudo or run as root."
        exit 1
    fi
}

# Function to install and enable QEMU Guest Agent
install_qemu_agent() {
    echo "Installing QEMU Guest Agent for $1..."

    case "$1" in
        "Debian"|"Ubuntu")
            apt update -y
            apt install -y qemu-guest-agent
            systemctl enable --now qemu-guest-agent
            ;;

        "AlmaLinux"|"CentOS"|"RHEL")
            if [ -f /etc/redhat-release ]; then
                yum install -y epel-release
            fi
            yum install -y qemu-guest-agent
            systemctl enable --now qemu-guest-agent
            ;;

        "Proxmox")
            apt update -y
            apt install -y qemu-guest-agent
            systemctl enable --now qemu-guest-agent
            ;;

        *)
            echo "Unsupported OS. Exiting..."
            exit 1
            ;;
    esac

    echo "QEMU Guest Agent installed and enabled on $1."
}

# Determine OS type
if [ -f /etc/os-release ]; then
    source /etc/os-release
    OS=$ID
elif [ -f /etc/debian_version ]; then
    OS="Debian"
elif [ -f /etc/redhat-release ]; then
    OS=$(cat /etc/redhat-release | awk '{print $1}')
else
    echo "Cannot determine OS. Exiting..."
    exit 1
fi

# Execute installation based on detected OS
case "$OS" in
    "debian")
        install_qemu_agent "Debian"
        ;;
    "ubuntu")
        install_qemu_agent "Ubuntu"
        ;;
    "centos")
        install_qemu_agent "CentOS"
        ;;
    "almalinux")
        install_qemu_agent "AlmaLinux"
        ;;
    "rhel")
        install_qemu_agent "RHEL"
        ;;
    "proxmox")
        install_qemu_agent "Proxmox"
        ;;
    *)
        echo "Unsupported OS detected: $OS. Exiting..."
        exit 1
        ;;
esac

# Verify installation and status
systemctl status qemu-guest-agent --no-pager
echo "QEMU Guest Agent setup complete."
