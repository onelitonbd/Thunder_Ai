#!/bin/bash

echo "🤖 Facebook Automation Bot - Quick Setup"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python found: $(python3 --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from template..."
    cp .env.example .env
    echo "✅ Created .env file"
    echo ""
    echo "📝 Please edit .env file with your credentials:"
    echo "   nano .env"
    echo ""
    echo "You need:"
    echo "  1. Telegram Bot Token (from @BotFather)"
    echo "  2. Groq API Key (from console.groq.com)"
    echo "  3. Facebook Page ID and Access Token"
    echo "  4. Your Telegram Chat ID (from @userinfobot)"
    echo ""
    read -p "Press Enter after you've configured .env file..."
fi

echo ""
echo "🚀 Starting bot..."
echo ""
python3 bot.py
