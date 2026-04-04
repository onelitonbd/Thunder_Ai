# Host Bot FREE on GitHub Actions (24/7)

## 🎯 Why GitHub Actions?
- ✅ **100% FREE** - No credit card needed
- ✅ **24/7 Running** - Automatic restarts
- ✅ **2,000 minutes/month free** - More than enough
- ✅ **No server needed** - GitHub handles everything
- ✅ **Easy setup** - Just push code

---

## 🚀 Setup (5 Minutes)

### Step 1: Create GitHub Repository

```bash
# In your bot folder
cd facebook-automation-bot

# Initialize git
git init

# Add files
git add .

# Commit
git commit -m "Initial commit - Facebook automation bot"

# Create repo on GitHub (go to github.com)
# Then connect:
git remote add origin https://github.com/YOUR_USERNAME/facebook-bot.git
git branch -M main
git push -u origin main
```

---

### Step 2: Add Secrets to GitHub

1. **Go to your repository on GitHub**
   - Click "Settings" tab
   - Click "Secrets and variables" > "Actions"
   - Click "New repository secret"

2. **Add these secrets one by one:**

   **Secret 1: TELEGRAM_BOT_TOKEN**
   - Name: `TELEGRAM_BOT_TOKEN`
   - Value: Your bot token from @BotFather
   - Click "Add secret"

   **Secret 2: GROQ_API_KEY**
   - Name: `GROQ_API_KEY`
   - Value: Your Groq API key
   - Click "Add secret"

   **Secret 3: FACEBOOK_ACCESS_TOKEN**
   - Name: `FACEBOOK_ACCESS_TOKEN`
   - Value: Your Facebook page token
   - Click "Add secret"

   **Secret 4: FACEBOOK_PAGE_ID**
   - Name: `FACEBOOK_PAGE_ID`
   - Value: Your Facebook page ID
   - Click "Add secret"

   **Secret 5: ADMIN_CHAT_ID**
   - Name: `ADMIN_CHAT_ID`
   - Value: Your Telegram chat ID
   - Click "Add secret"

---

### Step 3: Enable GitHub Actions

1. **Go to "Actions" tab** in your repository
2. **Enable workflows** if prompted
3. **Click "I understand my workflows, go ahead and enable them"**

---

### Step 4: Run the Bot

**Option A: Automatic (Recommended)**
- Bot runs automatically every 6 hours
- No action needed!

**Option B: Manual Start**
1. Go to "Actions" tab
2. Click "Facebook Bot 24/7" workflow
3. Click "Run workflow" button
4. Click green "Run workflow"

---

## 📊 How It Works

### Workflow Schedule
```
Every 6 hours:
- 00:00 UTC (6:00 AM Bangladesh)
- 06:00 UTC (12:00 PM Bangladesh)
- 12:00 UTC (6:00 PM Bangladesh)
- 18:00 UTC (12:00 AM Bangladesh)
```

### Bot Behavior
1. **Workflow starts** every 6 hours
2. **Bot runs** for ~6 hours
3. **Generates posts** at scheduled times (8 AM, 1 PM, 6 PM, 10 PM Bangladesh)
4. **Sends to Telegram** for your approval
5. **You approve** via Telegram buttons
6. **Bot posts** to Facebook
7. **Workflow restarts** automatically

---

## 🎮 Using the Bot

### Start Bot
1. Open Telegram
2. Find your bot
3. Send `/start`
4. Click "▶️ Start Bot"

### Approve Posts
1. Bot sends post preview to Telegram
2. You see 3 buttons:
   - ✅ **Approve & Post** - Posts immediately
   - 🔄 **Regenerate** - Creates new post
   - ❌ **Reject** - Skips this post

### Check Status
- Send `/status` in Telegram
- Or click "📊 Status" button

---

## ⚙️ Configuration

### Change Posting Times (Bangladesh Time)

Edit `.github/workflows/bot.yml`:
```yaml
on:
  schedule:
    - cron: '0 2,7,12,16 * * *'  # 8AM, 1PM, 6PM, 10PM Bangladesh
```

Cron calculator: https://crontab.guru

### Change Posts Per Day

Edit `bot.py`:
```python
POSTS_PER_DAY = 4  # Change to 2, 3, 5, etc.
POSTING_TIMES = ['08:00', '13:00', '18:00', '22:00']  # Bangladesh time
```

### Disable Approval (Full Automation)

Edit `bot.py`:
```python
REQUIRE_APPROVAL = False  # Bot will post without asking
```

---

## 📈 Monitor Bot

### View Logs
1. Go to "Actions" tab
2. Click latest workflow run
3. Click "run-bot" job
4. See real-time logs

### Check if Running
```bash
# In Telegram, send:
/status

# You'll see:
# 🔄 Running: ✅ Yes
# 📝 Posts Generated: 12
# 📤 Posts Published: 10
# ⏰ Last Post: 2024-01-15 14:30:00
```

---

## 🔧 Troubleshooting

### Bot Not Running
**Check workflow status:**
1. Go to "Actions" tab
2. Look for red ❌ or yellow ⚠️
3. Click to see error logs

**Common fixes:**
- Verify all secrets are added correctly
- Check secret names match exactly
- Ensure tokens are valid

### Bot Not Responding in Telegram
**Check bot token:**
```bash
# Test token
curl https://api.telegram.org/bot<YOUR_TOKEN>/getMe
```

**Should return:**
```json
{"ok":true,"result":{"id":123456789,"is_bot":true,"first_name":"YourBot"}}
```

### Posts Not Generating
**Check Groq API:**
- Verify API key is correct
- Check free tier limits (30 req/min)
- View logs in Actions tab

### Posts Not Posting to Facebook
**Check Facebook token:**
```bash
curl "https://graph.facebook.com/v18.0/me?access_token=YOUR_TOKEN"
```

**Should return page info**

---

## 💡 Pro Tips

### 1. Keep Bot Alive 24/7
GitHub Actions has 2,000 free minutes/month.
- Each workflow runs ~6 hours
- 4 runs per day = 24 hours
- 30 days × 24 hours = 720 hours/month
- Well within free tier! ✅

### 2. Multiple Workflows
Create separate workflows for different times:

`.github/workflows/morning.yml`:
```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # 8 AM Bangladesh
```

`.github/workflows/afternoon.yml`:
```yaml
on:
  schedule:
    - cron: '0 7 * * *'  # 1 PM Bangladesh
```

### 3. Backup Strategy
- Keep tokens in password manager
- Export bot state weekly
- Save approved posts locally

### 4. Optimize for Engagement
- Post at peak times (8 AM, 1 PM, 6 PM, 10 PM)
- Test different content types
- Monitor Facebook Insights
- Adjust based on performance

---

## 🔒 Security

### Protect Your Secrets
- ✅ Never commit .env file
- ✅ Use GitHub Secrets only
- ✅ Rotate tokens monthly
- ✅ Enable 2FA on GitHub

### Repository Settings
1. Go to Settings > General
2. Scroll to "Danger Zone"
3. Make repository **Private** (recommended)
4. Or keep public but NEVER commit secrets

---

## 📊 Cost Breakdown

| Service | Cost | Usage |
|---------|------|-------|
| GitHub Actions | $0 | 2,000 min/month free |
| Groq API | $0 | Free tier |
| Telegram Bot | $0 | Free forever |
| Facebook API | $0 | Free forever |
| **TOTAL** | **$0** | **100% FREE** |

---

## 🎯 Workflow Explained

### What Happens Every 6 Hours:

```
1. GitHub Actions starts workflow
   ↓
2. Installs Python & dependencies
   ↓
3. Runs bot.py
   ↓
4. Bot connects to Telegram
   ↓
5. At scheduled times (8AM, 1PM, 6PM, 10PM):
   - Searches trending topics
   - Generates post with Groq AI
   - Sends to you on Telegram
   ↓
6. You receive notification
   ↓
7. You click "Approve" or "Regenerate"
   ↓
8. Bot posts to Facebook
   ↓
9. You get confirmation
   ↓
10. Repeat until workflow ends
    ↓
11. New workflow starts automatically
```

---

## 🚀 Quick Commands

### Push Updates
```bash
git add .
git commit -m "Update bot settings"
git push
```

### View Logs
```bash
# In GitHub Actions tab, or:
gh run list
gh run view
```

### Manual Trigger
```bash
gh workflow run bot.yml
```

---

## 📱 Telegram Commands

```
/start - Show control panel
/status - Check bot status
/setniche technology - Set niche
/setaudience developers - Set audience
/settone professional - Set tone
/help - Show help
```

---

## ✅ Final Checklist

Before going live:

- [ ] Repository created on GitHub
- [ ] All 5 secrets added correctly
- [ ] GitHub Actions enabled
- [ ] Workflow running (check Actions tab)
- [ ] Bot responding in Telegram
- [ ] Test post generated and approved
- [ ] Post appeared on Facebook page
- [ ] Scheduled times set for Bangladesh timezone
- [ ] Approval workflow working

---

## 🎉 You're Live!

Your bot is now:
- ✅ Running 24/7 on GitHub Actions
- ✅ Generating posts automatically
- ✅ Asking for your approval
- ✅ Posting to Facebook
- ✅ Completely FREE
- ✅ No server needed

**Just approve posts from Telegram and watch your page grow! 🚀**

---

## 🆘 Need Help?

### Check Logs
```
GitHub > Actions > Latest run > run-bot > View logs
```

### Test Components
```bash
# Test Telegram
curl https://api.telegram.org/bot<TOKEN>/getMe

# Test Groq
curl https://api.groq.com/openai/v1/models \
  -H "Authorization: Bearer <KEY>"

# Test Facebook
curl "https://graph.facebook.com/v18.0/me?access_token=<TOKEN>"
```

### Common Issues
- **"Invalid token"** → Regenerate and update secret
- **"Workflow failed"** → Check logs in Actions tab
- **"Bot not responding"** → Verify TELEGRAM_BOT_TOKEN
- **"Can't post"** → Check FACEBOOK_ACCESS_TOKEN

---

**Your bot is now autonomous and will work 24/7 for FREE! 🎊**
