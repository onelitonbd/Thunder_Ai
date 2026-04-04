# Facebook Access Token Setup - Complete Guide

## 🎯 Overview
The bot needs a **Page Access Token** to post on your behalf. This is NOT your password - it's a secure token with specific permissions.

---

## 📋 Step-by-Step Setup

### Step 1: Create Facebook App (5 minutes)

1. **Go to Facebook Developers**
   - Visit: https://developers.facebook.com
   - Click "My Apps" (top right)
   - Click "Create App"

2. **Choose App Type**
   - Select: **"Business"**
   - Click "Next"

3. **App Details**
   - Display Name: `My Facebook Bot` (or any name)
   - App Contact Email: Your email
   - Click "Create App"

4. **Add Products**
   - Find "Facebook Login" 
   - Click "Set Up"
   - Choose "Web" platform
   - Site URL: `https://localhost` (just for setup)
   - Save

---

### Step 2: Get Page Access Token (3 minutes)

1. **Go to Graph API Explorer**
   - Visit: https://developers.facebook.com/tools/explorer/
   - Or: In your app dashboard, click "Tools" > "Graph API Explorer"

2. **Select Your App**
   - Top dropdown: Select your app (not "Graph API Explorer")

3. **Select Your Page**
   - Click "User or Page" dropdown
   - Select your Facebook Page

4. **Add Permissions**
   - Click "Permissions" tab (or "Add a permission")
   - Search and add these permissions:
     - ✅ `pages_manage_posts` (Required - to create posts)
     - ✅ `pages_read_engagement` (Optional - to read stats)
     - ✅ `pages_show_list` (Optional - to list pages)
   - Click "Generate Access Token"

5. **Authorize**
   - Facebook will ask you to login
   - Grant permissions
   - Copy the token (starts with `EAAA...`)

---

### Step 3: Get Long-Lived Token (IMPORTANT!)

The token from Step 2 expires in 1 hour. We need a long-lived token (60 days or never expires).

#### Option A: Using Graph API Explorer (Easiest)

1. **In Graph API Explorer**
   - Click the "i" icon next to Access Token
   - Click "Open in Access Token Tool"

2. **Extend Token**
   - Click "Extend Access Token"
   - Copy the new token (this lasts 60 days)

#### Option B: Using API Call

```bash
# Replace these values:
# YOUR_APP_ID - from app dashboard
# YOUR_APP_SECRET - from app settings > basic
# SHORT_TOKEN - token from step 2

curl -X GET "https://graph.facebook.com/v18.0/oauth/access_token?grant_type=fb_exchange_token&client_id=YOUR_APP_ID&client_secret=YOUR_APP_SECRET&fb_exchange_token=SHORT_TOKEN"
```

#### Option C: Get Never-Expiring Token (Best!)

1. **Get User Token** (from Step 2)

2. **Get Page Token** (never expires):
```bash
curl -X GET "https://graph.facebook.com/v18.0/me/accounts?access_token=YOUR_USER_TOKEN"
```

3. **Response will show your pages:**
```json
{
  "data": [
    {
      "access_token": "EAAA...",  // This is your NEVER-EXPIRING page token!
      "category": "...",
      "name": "Your Page Name",
      "id": "123456789",  // This is your PAGE_ID
      "tasks": ["ANALYZE", "ADVERTISE", "MODERATE", "CREATE_CONTENT"]
    }
  ]
}
```

4. **Copy:**
   - `access_token` - Your Facebook Access Token
   - `id` - Your Facebook Page ID

---

### Step 4: Get Your Page ID (if you don't have it)

#### Method 1: From Page Settings
1. Go to your Facebook Page
2. Click "Settings"
3. Click "Page Info"
4. Copy "Page ID"

#### Method 2: From URL
1. Go to your Facebook Page
2. Look at URL: `facebook.com/YourPageName`
3. Or: `facebook.com/profile.php?id=123456789`
4. The number is your Page ID

#### Method 3: Using Graph API
```bash
curl "https://graph.facebook.com/v18.0/me/accounts?access_token=YOUR_TOKEN"
```

---

## 🔐 Security Best Practices

### 1. Token Permissions
Only grant these permissions:
- ✅ `pages_manage_posts` - To create posts
- ✅ `pages_read_engagement` - To read stats (optional)
- ❌ Don't grant unnecessary permissions

### 2. Token Storage
- ✅ Store in `.env` file (never commit to git)
- ✅ Use environment variables
- ❌ Never hardcode in code
- ❌ Never share publicly

### 3. Token Rotation
- Rotate tokens every 60 days
- Set calendar reminder
- Keep backup tokens

### 4. App Settings
In Facebook App Settings:
- Add your domain to "App Domains"
- Set "Privacy Policy URL" (required for public apps)
- Keep app in "Development Mode" (for personal use)

---

## 🧪 Test Your Token

### Test 1: Check Token Info
```bash
curl "https://graph.facebook.com/v18.0/me?access_token=YOUR_TOKEN"
```

Should return your page info.

### Test 2: Test Posting
```bash
curl -X POST "https://graph.facebook.com/v18.0/YOUR_PAGE_ID/feed" \
  -d "message=Test post from bot 🤖" \
  -d "access_token=YOUR_TOKEN"
```

Should create a post on your page.

### Test 3: Check Token Expiration
```bash
curl "https://graph.facebook.com/v18.0/debug_token?input_token=YOUR_TOKEN&access_token=YOUR_TOKEN"
```

Look for `expires_at` field:
- `0` = Never expires ✅
- Unix timestamp = Expiration date

---

## 📝 Add to Bot

1. **Edit `.env` file:**
```env
FACEBOOK_PAGE_ID=123456789012345
FACEBOOK_ACCESS_TOKEN=EAAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

2. **Test bot:**
```bash
python bot.py
```

3. **In Telegram:**
   - Send `/start`
   - Click "Generate Post Now"
   - Click "Post Now"
   - Check your Facebook page!

---

## ❌ Troubleshooting

### Error: "Invalid OAuth access token"
**Solution:** Token expired or wrong token
- Generate new token
- Make sure you copied full token
- Use page token, not user token

### Error: "Permissions error"
**Solution:** Missing permissions
- Go back to Graph API Explorer
- Add `pages_manage_posts` permission
- Generate new token

### Error: "Page ID not found"
**Solution:** Wrong page ID
- Double-check page ID
- Use numeric ID, not page name
- Try getting ID from Graph API

### Error: "App not authorized"
**Solution:** App in development mode
- Go to App Settings > Basic
- Add your Facebook account to "App Roles"
- Or switch app to "Live" mode

### Token Expires Too Soon
**Solution:** Get never-expiring page token
- Follow "Option C" in Step 3
- Use page token from `/me/accounts` endpoint

---

## 🔄 Token Renewal (Every 60 Days)

If using 60-day token, set up auto-renewal:

### Option 1: Manual Renewal
1. Set calendar reminder for 50 days
2. Go to Graph API Explorer
3. Generate new token
4. Update `.env` file
5. Restart bot

### Option 2: Automated Renewal (Advanced)
Add this to bot code:

```python
import requests
from datetime import datetime, timedelta

def check_token_expiry():
    url = f"https://graph.facebook.com/v18.0/debug_token"
    params = {
        'input_token': Config.FACEBOOK_ACCESS_TOKEN,
        'access_token': Config.FACEBOOK_ACCESS_TOKEN
    }
    response = requests.get(url, params=params)
    data = response.json()
    
    expires_at = data['data'].get('expires_at', 0)
    if expires_at == 0:
        return True  # Never expires
    
    expiry_date = datetime.fromtimestamp(expires_at)
    days_left = (expiry_date - datetime.now()).days
    
    if days_left < 7:
        # Send alert to admin
        return False
    return True
```

---

## 🎯 Quick Reference

### What You Need:
1. **Facebook Page** (not personal profile)
2. **Facebook App** (created at developers.facebook.com)
3. **Page Access Token** (from Graph API Explorer)
4. **Page ID** (numeric ID of your page)

### Token Types:
- **User Token** - Expires in 1 hour ❌
- **Extended User Token** - Expires in 60 days ⚠️
- **Page Token** - Never expires ✅ (Use this!)

### Required Permissions:
- `pages_manage_posts` - Create posts
- `pages_read_engagement` - Read stats (optional)

### Important URLs:
- App Dashboard: https://developers.facebook.com/apps/
- Graph API Explorer: https://developers.facebook.com/tools/explorer/
- Access Token Tool: https://developers.facebook.com/tools/accesstoken/

---

## 🎉 Done!

You now have:
- ✅ Facebook App created
- ✅ Page Access Token (never expires)
- ✅ Page ID
- ✅ Bot configured
- ✅ Ready to post automatically!

**Test it:** Send a test post from Telegram bot to verify everything works! 🚀
