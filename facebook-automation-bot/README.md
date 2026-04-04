# Facebook Automation Bot - Complete Setup Guide

## 🎯 What This Bot Does
- **24/7 Automated Facebook Posting** - Never miss a post
- **AI-Powered Content** - Uses Groq (FREE) to generate engaging posts
- **Web Research** - Automatically finds trending topics in your niche
- **Smart Scheduling** - Posts at optimal times for engagement
- **Telegram Control** - Manage everything from your phone
- **100% FREE** - No costs, runs forever

---

## 📋 Prerequisites

### 1. Get Telegram Bot Token (FREE)
1. Open Telegram and search for `@BotFather`
2. Send `/newbot`
3. Follow instructions to create your bot
4. Copy the token (looks like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)
5. Get your Chat ID:
   - Search for `@userinfobot` on Telegram
   - Send any message
   - Copy your Chat ID

### 2. Get Groq API Key (FREE - No Credit Card)
1. Go to https://console.groq.com
2. Sign up (free, no credit card needed)
3. Go to API Keys section
4. Create new API key
5. Copy the key (starts with `gsk_`)

### 3. Get Facebook Access Token
1. Go to https://developers.facebook.com
2. Create an app (Business type)
3. Add "Facebook Login" product
4. Go to Tools > Graph API Explorer
5. Select your page
6. Generate token with permissions:
   - `pages_manage_posts`
   - `pages_read_engagement`
7. Get Page ID from your Facebook page settings

---

## 🚀 Quick Start

### Option 1: Run Locally (Simple)

```bash
# 1. Clone/Download the bot
cd facebook-automation-bot

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Create .env file
cp .env.example .env

# 4. Edit .env with your credentials
nano .env  # or use any text editor

# 5. Run the bot
python bot.py
```

### Option 2: Docker (Recommended for 24/7)

```bash
# 1. Create .env file with your credentials
cp .env.example .env
nano .env

# 2. Build and run with Docker
docker-compose up -d

# 3. Check logs
docker-compose logs -f

# 4. Stop bot
docker-compose down
```

---

## 🌐 Deploy for FREE 24/7 (No Server Costs)

### Option A: Railway.app (Easiest)
1. Go to https://railway.app
2. Sign up with GitHub (free)
3. Click "New Project" > "Deploy from GitHub repo"
4. Select your bot repository
5. Add environment variables in Railway dashboard
6. Deploy! (Free $5/month credit, enough for 24/7)

### Option B: Render.com
1. Go to https://render.com
2. Sign up (free)
3. New > Web Service
4. Connect your GitHub repo
5. Add environment variables
6. Deploy (Free tier available)

### Option C: Fly.io
```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
flyctl auth login

# Deploy
flyctl launch
flyctl secrets set TELEGRAM_BOT_TOKEN=your_token
flyctl secrets set GROQ_API_KEY=your_key
flyctl secrets set FACEBOOK_ACCESS_TOKEN=your_token
flyctl secrets set FACEBOOK_PAGE_ID=your_page_id
flyctl secrets set ADMIN_CHAT_ID=your_chat_id

# Deploy
flyctl deploy
```

### Option D: Oracle Cloud (Always Free)
1. Sign up at https://cloud.oracle.com (free tier forever)
2. Create VM instance (ARM-based, free)
3. SSH into instance
4. Install Docker:
   ```bash
   sudo apt update
   sudo apt install docker.io docker-compose -y
   ```
5. Upload bot files
6. Run: `docker-compose up -d`

### Option E: Google Cloud Run (Free Tier)
```bash
# Install gcloud CLI
# Then:
gcloud run deploy facebook-bot \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

---

## 🎮 Using the Bot

### Start the Bot
1. Open Telegram
2. Search for your bot
3. Send `/start`
4. You'll see control panel with buttons

### Commands
- `/start` - Show main menu
- `/help` - Show help
- `/status` - Check bot status
- `/setniche technology` - Set your niche
- `/setaudience developers and tech enthusiasts` - Set audience
- `/settone professional and engaging` - Set tone

### Control Panel Buttons
- **▶️ Start Bot** - Begin automatic posting
- **⏸️ Stop Bot** - Pause automation
- **📊 Status** - View statistics
- **⚙️ Settings** - View/change settings
- **📝 Generate Post Now** - Create post immediately

---

## ⚙️ Configuration

### Edit Posting Schedule
In `bot.py`, change:
```python
POSTING_TIMES = ['09:00', '14:00', '20:00']  # 3 posts per day
```

### Change Niche/Preferences
```python
NICHE = "technology"  # Your niche
TARGET_AUDIENCE = "tech enthusiasts"
TONE = "engaging and informative"
POST_LENGTH = "medium"  # short, medium, long
```

### Adjust Posts Per Day
```python
POSTS_PER_DAY = 3  # Change to 1, 2, 5, etc.
```

---

## 🔧 Troubleshooting

### Bot Not Posting
1. Check Facebook token is valid
2. Verify page permissions
3. Check logs: `docker-compose logs -f`

### Groq API Errors
- Free tier: 30 requests/minute
- If exceeded, bot will retry
- Consider adding delay between requests

### Telegram Not Responding
- Verify bot token is correct
- Check bot is running: `docker ps`
- Restart: `docker-compose restart`

---

## 📊 Features Explained

### 1. Web Research
- Scrapes Google News for trending topics
- Filters by your niche
- Selects most relevant content

### 2. AI Content Generation
- Uses Groq's Llama 3.3 70B model (FREE)
- Generates engaging, viral-worthy posts
- Adds emojis and hashtags automatically
- Optimized for Facebook algorithm

### 3. Smart Scheduling
- Posts at optimal times
- Avoids spam detection
- Maintains consistent presence

### 4. Engagement Optimization
- Includes call-to-action
- Uses questions to boost comments
- Hashtag optimization
- Emoji placement for visibility

---

## 💡 Tips for Maximum Engagement

1. **Set Specific Niche**: "AI and Machine Learning" > "Technology"
2. **Know Your Audience**: Be specific about who you're targeting
3. **Consistent Posting**: 2-3 posts/day is optimal
4. **Best Times**: 9 AM, 2 PM, 8 PM (adjust for your timezone)
5. **Monitor Performance**: Check Facebook Insights weekly
6. **Adjust Tone**: Test different tones to see what works

---

## 🔒 Security Best Practices

1. **Never commit .env file** - Already in .gitignore
2. **Rotate tokens monthly** - Generate new Facebook tokens
3. **Use environment variables** - Don't hardcode credentials
4. **Monitor bot activity** - Check logs regularly
5. **Limit token permissions** - Only grant necessary permissions

---

## 📈 Scaling Up

### Multiple Pages
Create multiple bot instances with different configs:
```bash
docker-compose -f docker-compose-page1.yml up -d
docker-compose -f docker-compose-page2.yml up -d
```

### Advanced Features (Future)
- Image generation with DALL-E
- Video posting
- Story automation
- Analytics dashboard
- A/B testing posts

---

## 🆘 Support

### Common Issues

**"Invalid token"**
- Regenerate Facebook token
- Check token hasn't expired

**"Rate limit exceeded"**
- Groq free tier: 30 req/min
- Add delays in code

**"Bot not responding"**
- Check bot is running
- Verify Telegram token
- Check internet connection

---

## 📝 Example .env File

```env
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
ADMIN_CHAT_ID=123456789
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxx
FACEBOOK_PAGE_ID=123456789012345
FACEBOOK_ACCESS_TOKEN=EAAxxxxxxxxxxxxxxxxxx
POSTS_PER_DAY=3
NICHE=technology
```

---

## 🎉 You're All Set!

Your bot is now ready to:
- ✅ Research trending topics 24/7
- ✅ Generate engaging content with AI
- ✅ Post automatically to Facebook
- ✅ Grow your page on autopilot
- ✅ Run forever for FREE

**Start the bot and watch your Facebook page grow! 🚀**
