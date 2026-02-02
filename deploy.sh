#!/bin/bash

# deploy.sh - Production Deployment Script
set -e

echo "🚀 Starting VolGuard Deployment..."

# 1. Rename folders to lowercase to match Linux standards (if they exist)
if [ -d "Config" ]; then mv Config config; echo "✅ Renamed Config -> config"; fi
if [ -d "Volguard" ]; then mv Volguard volguard; echo "✅ Renamed Volguard -> volguard"; fi

# 2. Create data directories
echo "📂 Creating data directories..."
mkdir -p volguard_data
mkdir -p volguard_logs
mkdir -p config

# 3. FIX PERMISSIONS (Critical for the 'volguard' user)
# We set ownership to 1000:1000 so the container can write to them
echo "🔒 Setting permissions for UID 1000..."
sudo chown -R 1000:1000 volguard_data
sudo chown -R 1000:1000 volguard_logs

# 4. Check for .env
if [ ! -f .env ]; then
    echo "❌ ERROR: .env file missing!"
    echo "   Please create .env with UPSTOX_ACCESS_TOKEN etc."
    exit 1
fi

# 5. Build and Launch
echo "🏗️ Building and Launching Docker containers..."
docker-compose down  # Stop old versions
docker-compose up -d --build

echo "✅ Deployment Complete!"
echo "   📊 Grafana:    http://localhost:3000"
echo "   📈 Prometheus: http://localhost:9090"
echo "   💓 Health:     docker-compose ps"
