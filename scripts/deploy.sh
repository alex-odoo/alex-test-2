#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/alex-odoo/rteam-fze.git"
DEPLOY_DIR="/opt/rteam-fze"

echo "=== rteam-fze Odoo 19 Deployment Script ==="

# Install Docker if not present
if ! command -v docker &>/dev/null; then
    echo ">>> Installing Docker..."
    apt-get update -qq
    apt-get install -y -qq ca-certificates curl gnupg lsb-release
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        > /etc/apt/sources.list.d/docker.list
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
    systemctl enable --now docker
    echo ">>> Docker installed."
else
    echo ">>> Docker already installed."
fi

# Clone or update repo
if [ -d "$DEPLOY_DIR/.git" ]; then
    echo ">>> Updating existing repo..."
    git -C "$DEPLOY_DIR" pull
else
    echo ">>> Cloning repo to $DEPLOY_DIR..."
    git clone "$REPO_URL" "$DEPLOY_DIR"
fi

cd "$DEPLOY_DIR"

# Create .env from example if it doesn't exist yet
if [ ! -f .env ]; then
    cp .env.example .env
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "  IMPORTANT: Edit $DEPLOY_DIR/.env and set passwords"
    echo "  then run: cd $DEPLOY_DIR && docker compose up -d"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ""
else
    echo ">>> .env already exists, skipping copy."
    # Pull latest images and restart
    docker compose pull
    docker compose up -d
    echo ">>> Deployment complete. Odoo is starting up..."
    docker compose ps
fi
