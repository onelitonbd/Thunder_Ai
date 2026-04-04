# Facebook Setup - Visual Guide (5 Minutes)

## 🎬 Quick Video Tutorial
**Watch this first:** https://www.youtube.com/results?search_query=facebook+page+access+token+tutorial

---

## 📸 Step-by-Step with Screenshots

### STEP 1: Create Facebook App (2 min)

**1.1 Go to Developers Portal**
```
🌐 URL: https://developers.facebook.com
👆 Click: "My Apps" (top right corner)
👆 Click: "Create App" (green button)
```

**1.2 Choose App Type**
```
📱 Select: "Business" (first option)
👆 Click: "Next"
```

**1.3 Fill App Details**
```
📝 Display Name: "My Facebook Bot"
📧 Email: your@email.com
👆 Click: "Create App"
✅ App created! You'll see app dashboard
```

---

### STEP 2: Get Access Token (3 min)

**2.1 Open Graph API Explorer**
```
🌐 URL: https://developers.facebook.com/tools/explorer/
OR
👆 In app dashboard: Tools > Graph API Explorer
```

**2.2 Configure Explorer**
```
📱 Top dropdown: Select YOUR APP (not "Graph API Explorer")
👤 User/Page dropdown: Select YOUR PAGE
```

**2.3 Add Permissions**
```
👆 Click: "Permissions" tab
🔍 Search: "pages_manage_posts"
✅ Check: pages_manage_posts
✅ Check: pages_read_engagement (optional)
👆 Click: "Generate Access Token" (blue button)
```

**2.4 Authorize**
```
🔐 Facebook login popup appears
👆 Click: "Continue as [Your Name]"
✅ Check all permissions
👆 Click: "Done"
📋 Copy the token (long string starting with EAAA...)
```

---

### STEP 3: Get Never-Expiring Token (CRITICAL!)

**3.1 Get Page Token**
```
🌐 Open new tab: https://developers.facebook.com/tools/explorer/
📱 Select your app
👤 Select your page
👆 Click: Generate Access Token
📋 Copy this token (call it TOKEN_1)
```

**3.2 Convert to Page Token**
```
🌐 Open: https://developers.facebook.com/tools/explorer/
📝 In query box, paste:
   me/accounts

👆 Click: "Submit"
```

**3.3 Copy Results**
```
📊 You'll see JSON response like:
{
  "data": [
    {
      "access_token": "EAAAxxxx...",  ← COPY THIS!
      "id": "123456789",              ← COPY THIS TOO!
      "name": "Your Page Name"
    }
  ]
}

✅ This access_token NEVER EXPIRES!
✅ The id is your PAGE_ID!
```

---

### STEP 4: Test Token (1 min)

**4.1 Test in Graph API Explorer**
```
🌐 Stay in: https://developers.facebook.com/tools/explorer/
📝 Paste your PAGE token in "Access Token" field
📝 In query box, type: me
👆 Click: "Submit"

✅ Should show your page info
❌ If error, token is wrong
```

**4.2 Test Posting**
```
📝 In query box, type: me/feed
📝 Change GET to POST (dropdown)
📝 Add parameter:
   Key: message
   Value: Test post 🤖
👆 Click: "Submit"

✅ Check your Facebook page - post should appear!
❌ If error, check permissions
```

---

## 🎯 What You Need to Copy

After completing above steps, you should have:

```
✅ FACEBOOK_PAGE_ID
   Example: 123456789012345
   Where: From step 3.3 (the "id" field)

✅ FACEBOOK_ACCESS_TOKEN  
   Example: EAAAxxxxxxxxxxxxxxxxxxxxxxxxx
   Where: From step 3.3 (the "access_token" field)
   Note: This is the PAGE token, not user token!
```

---

## 📝 Add to Bot

**1. Edit .env file:**
```bash
nano .env
```

**2. Add these lines:**
```env
FACEBOOK_PAGE_ID=123456789012345
FACEBOOK_ACCESS_TOKEN=EAAAxxxxxxxxxxxxxxxxxxxxxxxxx
```

**3. Save and exit:**
```
Ctrl + X
Y
Enter
```

**4. Start bot:**
```bash
python bot.py
```

---

## ✅ Verification Checklist

Before running bot, verify:

- [ ] Created Facebook App at developers.facebook.com
- [ ] App has "Facebook Login" product added
- [ ] Generated access token with `pages_manage_posts` permission
- [ ] Converted to PAGE token (not user token)
- [ ] Token is never-expiring (from me/accounts endpoint)
- [ ] Copied Page ID (numeric, not page name)
- [ ] Added both to .env file
- [ ] Tested token in Graph API Explorer
- [ ] Test post appeared on Facebook page

---

## 🆘 Common Issues

### "Invalid OAuth access token"
```
❌ Problem: Token expired or wrong
✅ Solution: 
   1. Go to Graph API Explorer
   2. Select your app
   3. Select your page
   4. Generate new token
   5. Use me/accounts to get page token
```

### "Permissions error"
```
❌ Problem: Missing pages_manage_posts permission
✅ Solution:
   1. Graph API Explorer
   2. Permissions tab
   3. Add pages_manage_posts
   4. Generate new token
```

### "Page not found"
```
❌ Problem: Wrong page ID
✅ Solution:
   1. Use numeric ID (123456789)
   2. Not page username (@yourpage)
   3. Get from me/accounts response
```

### Token expires after 1 hour
```
❌ Problem: Using user token, not page token
✅ Solution:
   1. Must use me/accounts endpoint
   2. Get page token from response
   3. Page tokens never expire!
```

---

## 🎥 Video Tutorials (Recommended)

Search YouTube for:
- "Facebook page access token tutorial"
- "Facebook Graph API get page token"
- "Never expiring Facebook page token"

Or use these commands in terminal:

```bash
# Quick test your token
curl "https://graph.facebook.com/v18.0/me?access_token=YOUR_TOKEN"

# Get page token
curl "https://graph.facebook.com/v18.0/me/accounts?access_token=YOUR_USER_TOKEN"

# Test posting
curl -X POST "https://graph.facebook.com/v18.0/YOUR_PAGE_ID/feed" \
  -d "message=Test 🤖" \
  -d "access_token=YOUR_PAGE_TOKEN"
```

---

## 🎉 You're Done!

Once you have:
1. ✅ Page ID in .env
2. ✅ Page Access Token in .env
3. ✅ Token tested and working

**Run the bot:**
```bash
python bot.py
```

**In Telegram:**
- Send `/start`
- Click "Generate Post Now"
- Click "Post Now"
- Check Facebook page! 🚀

---

## 💡 Pro Tips

1. **Keep token safe** - Never share or commit to git
2. **Use page token** - Not user token (page tokens don't expire)
3. **Test first** - Always test in Graph API Explorer
4. **Backup token** - Save token somewhere safe
5. **Monitor app** - Check Facebook app dashboard weekly

---

## 📞 Need Help?

If stuck:
1. Check FACEBOOK_SETUP.md for detailed guide
2. Search: "Facebook Graph API page token" on YouTube
3. Visit: Facebook Developers Community
4. Check bot logs: `docker-compose logs -f`

**The bot will NOT access your personal Facebook account - only your PAGE!** 🔒
