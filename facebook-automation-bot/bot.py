import os
import asyncio
import logging
from datetime import datetime, timedelta
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Application, CommandHandler, CallbackQueryHandler, MessageHandler, filters, ContextTypes
from groq import Groq
import requests
from bs4 import BeautifulSoup
import json
import random
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

# Configure logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Configuration
class Config:
    TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN', 'YOUR_TELEGRAM_BOT_TOKEN')
    GROQ_API_KEY = os.getenv('GROQ_API_KEY', 'YOUR_GROQ_API_KEY')
    FACEBOOK_PAGE_ID = os.getenv('FACEBOOK_PAGE_ID', 'YOUR_PAGE_ID')
    FACEBOOK_ACCESS_TOKEN = os.getenv('FACEBOOK_ACCESS_TOKEN', 'YOUR_ACCESS_TOKEN')
    ADMIN_CHAT_ID = os.getenv('ADMIN_CHAT_ID', 'YOUR_TELEGRAM_CHAT_ID')
    
    # Bot settings
    POSTS_PER_DAY = 4
    POSTING_TIMES = ['08:00', '13:00', '18:00', '22:00']  # Bangladesh time (GMT+6)
    AUTO_POST_WITHOUT_APPROVAL = False  # Set to True for full automation
    REQUIRE_APPROVAL = True  # Bot will ask before posting
    
    # Content preferences
    NICHE = "technology"  # Change to your niche
    TARGET_AUDIENCE = "tech enthusiasts, developers, and entrepreneurs"
    TONE = "engaging, informative, and conversational"
    POST_LENGTH = "medium"  # short, medium, long

# Initialize Groq client
groq_client = Groq(api_key=Config.GROQ_API_KEY)

# Storage for bot state
bot_state = {
    'is_running': False,
    'posts_generated': 0,
    'posts_published': 0,
    'last_post_time': None,
    'pending_approval': [],  # Posts waiting for approval
    'approved_posts': [],  # Posts approved and ready to post
    'preferences': {
        'niche': Config.NICHE,
        'target_audience': Config.TARGET_AUDIENCE,
        'tone': Config.TONE,
        'post_length': Config.POST_LENGTH
    }
}

# Web scraping for trending topics
async def search_trending_topics(niche: str) -> list:
    """Search for trending topics in the niche"""
    try:
        topics = []
        
        # Search Google News
        search_query = f"{niche} latest news"
        url = f"https://www.google.com/search?q={search_query}&tbm=nws"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Extract headlines
        headlines = soup.find_all('div', class_='BNeawe vvjwJb AP7Wnd')
        for headline in headlines[:10]:
            topics.append(headline.get_text())
        
        # Fallback topics if scraping fails
        if not topics:
            topics = [
                f"Latest trends in {niche}",
                f"Top {niche} innovations this week",
                f"What's new in {niche}",
                f"{niche} tips and tricks",
                f"Future of {niche}"
            ]
        
        return topics[:5]
    except Exception as e:
        logger.error(f"Error searching topics: {e}")
        return [f"Latest in {niche}", f"{niche} updates", f"{niche} insights"]

# Generate Facebook post using Groq
async def generate_facebook_post(topic: str, preferences: dict) -> dict:
    """Generate engaging Facebook post using Groq AI"""
    try:
        prompt = f"""You are a professional social media content creator specializing in Facebook posts.

Topic: {topic}
Niche: {preferences['niche']}
Target Audience: {preferences['target_audience']}
Tone: {preferences['tone']}
Post Length: {preferences['post_length']}

Create an engaging Facebook post that:
1. Hooks the reader in the first line
2. Provides valuable information or insights
3. Includes relevant emojis naturally
4. Ends with a call-to-action or question to boost engagement
5. Uses line breaks for readability
6. Is optimized for Facebook algorithm (engagement-focused)

Also suggest 5 relevant hashtags.

Format your response as JSON:
{{
    "post_text": "the complete post text with emojis",
    "hashtags": ["hashtag1", "hashtag2", "hashtag3", "hashtag4", "hashtag5"],
    "best_time_to_post": "morning/afternoon/evening"
}}
"""

        response = groq_client.chat.completions.create(
            model="llama-3.3-70b-versatile",  # Free tier model
            messages=[
                {"role": "system", "content": "You are an expert social media content creator."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.8,
            max_tokens=1000
        )
        
        content = response.choices[0].message.content
        
        # Extract JSON from response
        start_idx = content.find('{')
        end_idx = content.rfind('}') + 1
        json_str = content[start_idx:end_idx]
        
        post_data = json.loads(json_str)
        
        # Add hashtags to post
        full_post = f"{post_data['post_text']}\n\n{' '.join(['#' + tag for tag in post_data['hashtags']])}"
        
        return {
            'text': full_post,
            'topic': topic,
            'generated_at': datetime.now().isoformat()
        }
        
    except Exception as e:
        logger.error(f"Error generating post: {e}")
        return {
            'text': f"🚀 Exciting updates in {preferences['niche']}!\n\n{topic}\n\nWhat are your thoughts? 💭\n\n#{preferences['niche']} #trending #updates",
            'topic': topic,
            'generated_at': datetime.now().isoformat()
        }

# Post to Facebook
async def post_to_facebook(post_text: str) -> bool:
    """Post content to Facebook page"""
    try:
        url = f"https://graph.facebook.com/v18.0/{Config.FACEBOOK_PAGE_ID}/feed"
        
        payload = {
            'message': post_text,
            'access_token': Config.FACEBOOK_ACCESS_TOKEN
        }
        
        response = requests.post(url, data=payload, timeout=30)
        
        if response.status_code == 200:
            logger.info("Successfully posted to Facebook")
            return True
        else:
            logger.error(f"Facebook API error: {response.text}")
            return False
            
    except Exception as e:
        logger.error(f"Error posting to Facebook: {e}")
        return False

# Automated posting job
async def automated_post_job(context: ContextTypes.DEFAULT_TYPE):
    """Job that runs at scheduled times to create and post content"""
    if not bot_state['is_running']:
        return
    
    try:
        logger.info("Starting automated post generation...")
        
        # Check if there are approved posts ready to publish
        if bot_state['approved_posts']:
            post_data = bot_state['approved_posts'].pop(0)
            
            # Post to Facebook
            success = await post_to_facebook(post_data['text'])
            
            if success:
                bot_state['posts_published'] += 1
                bot_state['last_post_time'] = datetime.now().isoformat()
                
                await context.bot.send_message(
                    chat_id=Config.ADMIN_CHAT_ID,
                    text=f"✅ *Post Published!*\n\n📊 Posts Today: {bot_state['posts_published']}\n\n📝 {post_data['text'][:150]}...",
                    parse_mode='Markdown'
                )
            return
        
        # Generate new post for approval
        topics = await search_trending_topics(bot_state['preferences']['niche'])
        selected_topic = random.choice(topics)
        
        # Generate post
        post_data = await generate_facebook_post(selected_topic, bot_state['preferences'])
        post_data['id'] = len(bot_state['pending_approval'])
        
        # Add to pending approval
        bot_state['pending_approval'].append(post_data)
        bot_state['posts_generated'] += 1
        
        # Send for approval
        if Config.REQUIRE_APPROVAL:
            keyboard = [
                [InlineKeyboardButton("✅ Approve & Post", callback_data=f'approve_{post_data["id"]}')],
                [InlineKeyboardButton("🔄 Regenerate", callback_data=f'regenerate_{post_data["id"]}')],
                [InlineKeyboardButton("❌ Reject", callback_data=f'reject_{post_data["id"]}')]
            ]
            reply_markup = InlineKeyboardMarkup(keyboard)
            
            message = f"🤖 *New Post Generated!*\n\n"
            message += f"📌 *Topic:* {selected_topic}\n\n"
            message += f"📝 *Post Preview:*\n{post_data['text']}\n\n"
            message += f"⏰ *Scheduled for:* Next posting time\n\n"
            message += "Please review and approve:"
            
            await context.bot.send_message(
                chat_id=Config.ADMIN_CHAT_ID,
                text=message,
                reply_markup=reply_markup,
                parse_mode='Markdown'
            )
        else:
            # Auto-approve if approval not required
            bot_state['approved_posts'].append(post_data)
            success = await post_to_facebook(post_data['text'])
            
            if success:
                bot_state['posts_published'] += 1
                bot_state['last_post_time'] = datetime.now().isoformat()
            
    except Exception as e:
        logger.error(f"Error in automated job: {e}")
        await context.bot.send_message(
            chat_id=Config.ADMIN_CHAT_ID,
            text=f"⚠️ Error in automation: {str(e)}"
        )

# Telegram bot commands
async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Start command handler"""
    keyboard = [
        [InlineKeyboardButton("▶️ Start Bot", callback_data='start_bot')],
        [InlineKeyboardButton("⏸️ Stop Bot", callback_data='stop_bot')],
        [InlineKeyboardButton("📊 Status", callback_data='status')],
        [InlineKeyboardButton("⚙️ Settings", callback_data='settings')],
        [InlineKeyboardButton("📝 Generate Post Now", callback_data='generate_now')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    
    welcome_text = """
🤖 *Facebook Automation Bot*

Welcome! I'm your 24/7 Facebook content automation assistant.

*Features:*
• 🔍 Auto-research trending topics
• ✍️ Generate engaging posts with AI
• 📅 Schedule posts automatically
• 📊 Track performance
• 🎯 Optimize for engagement

Use the buttons below to control the bot.
    """
    
    await update.message.reply_text(welcome_text, reply_markup=reply_markup, parse_mode='Markdown')

async def button_callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle button callbacks"""
    query = update.callback_query
    await query.answer()
    
    # Handle approval callbacks
    if query.data.startswith('approve_'):
        post_id = int(query.data.split('_')[1])
        
        # Find post in pending
        post = next((p for p in bot_state['pending_approval'] if p['id'] == post_id), None)
        
        if post:
            # Move to approved queue
            bot_state['pending_approval'].remove(post)
            bot_state['approved_posts'].append(post)
            
            await query.edit_message_text(
                f"✅ *Post Approved!*\n\nPost will be published at next scheduled time.\n\n📝 Preview:\n{post['text'][:200]}...",
                parse_mode='Markdown'
            )
            
            # Post immediately
            success = await post_to_facebook(post['text'])
            if success:
                bot_state['posts_published'] += 1
                bot_state['last_post_time'] = datetime.now().isoformat()
                await context.bot.send_message(
                    chat_id=Config.ADMIN_CHAT_ID,
                    text="✅ Posted to Facebook successfully!"
                )
        else:
            await query.edit_message_text("❌ Post not found or already processed.")
    
    elif query.data.startswith('regenerate_'):
        post_id = int(query.data.split('_')[1])
        
        # Find and remove old post
        post = next((p for p in bot_state['pending_approval'] if p['id'] == post_id), None)
        if post:
            bot_state['pending_approval'].remove(post)
        
        await query.edit_message_text("🔄 Regenerating post... Please wait.")
        
        # Generate new post
        topics = await search_trending_topics(bot_state['preferences']['niche'])
        new_post = await generate_facebook_post(random.choice(topics), bot_state['preferences'])
        new_post['id'] = len(bot_state['pending_approval'])
        bot_state['pending_approval'].append(new_post)
        
        keyboard = [
            [InlineKeyboardButton("✅ Approve & Post", callback_data=f'approve_{new_post["id"]}')],
            [InlineKeyboardButton("🔄 Regenerate", callback_data=f'regenerate_{new_post["id"]}')],
            [InlineKeyboardButton("❌ Reject", callback_data=f'reject_{new_post["id"]}')]
        ]
        reply_markup = InlineKeyboardMarkup(keyboard)
        
        await context.bot.send_message(
            chat_id=Config.ADMIN_CHAT_ID,
            text=f"🆕 *New Post Generated!*\n\n📝 {new_post['text']}\n\nPlease review:",
            reply_markup=reply_markup,
            parse_mode='Markdown'
        )
    
    elif query.data.startswith('reject_'):
        post_id = int(query.data.split('_')[1])
        
        post = next((p for p in bot_state['pending_approval'] if p['id'] == post_id), None)
        if post:
            bot_state['pending_approval'].remove(post)
        
        await query.edit_message_text("❌ Post rejected. Bot will generate a new one at next scheduled time.")
    
    elif query.data == 'start_bot':
        bot_state['is_running'] = True
        await query.edit_message_text(
            "✅ *Bot Started!*\n\nThe bot will now:\n• Generate posts at scheduled times\n• Send them to you for approval\n• Post after you approve\n\n⏰ Next post: At next scheduled time",
            parse_mode='Markdown'
        )
        
    elif query.data == 'stop_bot':
        bot_state['is_running'] = False
        await query.edit_message_text(
            "⏸️ *Bot Stopped!*\n\nAutomatic posting is paused. Use /start to resume.",
            parse_mode='Markdown'
        )
        
    elif query.data == 'status':
        pending_count = len(bot_state['pending_approval'])
        approved_count = len(bot_state['approved_posts'])
        
        status_text = f"""
📊 *Bot Status*

🔄 Running: {'✅ Yes' if bot_state['is_running'] else '❌ No'}
📝 Posts Generated: {bot_state['posts_generated']}
📤 Posts Published: {bot_state['posts_published']}
⏰ Last Post: {bot_state['last_post_time'] or 'Never'}

📝 *Pending Approval:* {pending_count}
✅ *Approved Queue:* {approved_count}

⚙️ *Settings:*
• Niche: {bot_state['preferences']['niche']}
• Posts/Day: {Config.POSTS_PER_DAY}
• Times: {', '.join(Config.POSTING_TIMES)} (Bangladesh Time)
• Approval Required: {'✅ Yes' if Config.REQUIRE_APPROVAL else '❌ No'}
        """
        await query.edit_message_text(status_text, parse_mode='Markdown')
        
    elif query.data == 'generate_now':
        await query.edit_message_text("🔄 Generating post... Please wait.")
        
        topics = await search_trending_topics(bot_state['preferences']['niche'])
        post_data = await generate_facebook_post(random.choice(topics), bot_state['preferences'])
        
        preview_text = f"📝 *Generated Post:*\n\n{post_data['text']}\n\n"
        preview_text += "Post to Facebook?"
        
        keyboard = [
            [InlineKeyboardButton("✅ Post Now", callback_data='post_now')],
            [InlineKeyboardButton("🔄 Regenerate", callback_data='generate_now')],
            [InlineKeyboardButton("❌ Cancel", callback_data='cancel')]
        ]
        reply_markup = InlineKeyboardMarkup(keyboard)
        
        context.user_data['pending_post'] = post_data['text']
        
        await query.edit_message_text(preview_text, reply_markup=reply_markup, parse_mode='Markdown')
        
    elif query.data == 'post_now':
        post_text = context.user_data.get('pending_post')
        if post_text:
            success = await post_to_facebook(post_text)
            if success:
                bot_state['posts_published'] += 1
                await query.edit_message_text("✅ Posted successfully to Facebook!")
            else:
                await query.edit_message_text("❌ Failed to post. Check your Facebook credentials.")
        else:
            await query.edit_message_text("❌ No post to publish.")
            
    elif query.data == 'settings':
        settings_text = f"""
⚙️ *Current Settings:*

• Niche: {bot_state['preferences']['niche']}
• Target Audience: {bot_state['preferences']['target_audience']}
• Tone: {bot_state['preferences']['tone']}
• Post Length: {bot_state['preferences']['post_length']}
• Posts Per Day: {Config.POSTS_PER_DAY}
• Posting Times: {', '.join(Config.POSTING_TIMES)} (Bangladesh Time)
• Approval Required: {'✅ Yes' if Config.REQUIRE_APPROVAL else '❌ No'}

To change settings, use:
/setniche <your_niche>
/setaudience <your_audience>
/settone <your_tone>
        """
        await query.edit_message_text(settings_text, parse_mode='Markdown')
    
    elif query.data == 'cancel':
        await query.edit_message_text("❌ Cancelled.")

async def set_niche(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Set niche preference"""
    if context.args:
        bot_state['preferences']['niche'] = ' '.join(context.args)
        await update.message.reply_text(f"✅ Niche updated to: {bot_state['preferences']['niche']}")
    else:
        await update.message.reply_text("Usage: /setniche <your_niche>")

async def set_audience(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Set target audience"""
    if context.args:
        bot_state['preferences']['target_audience'] = ' '.join(context.args)
        await update.message.reply_text(f"✅ Target audience updated to: {bot_state['preferences']['target_audience']}")
    else:
        await update.message.reply_text("Usage: /setaudience <your_audience>")

async def set_tone(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Set tone preference"""
    if context.args:
        bot_state['preferences']['tone'] = ' '.join(context.args)
        await update.message.reply_text(f"✅ Tone updated to: {bot_state['preferences']['tone']}")
    else:
        await update.message.reply_text("Usage: /settone <your_tone>")

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Help command"""
    help_text = """
📚 *Available Commands:*

/start - Start the bot and show menu
/help - Show this help message
/status - Check bot status
/setniche <niche> - Set content niche
/setaudience <audience> - Set target audience
/settone <tone> - Set content tone

*How it works:*
1. Bot searches for trending topics in your niche
2. Generates engaging posts using AI
3. Posts automatically at scheduled times
4. Runs 24/7 without intervention

*Free Services Used:*
• Groq API (Free AI)
• Telegram Bot (Free)
• Facebook Graph API (Free)
    """
    await update.message.reply_text(help_text, parse_mode='Markdown')

def main():
    """Main function to run the bot"""
    # Create application
    application = Application.builder().token(Config.TELEGRAM_BOT_TOKEN).build()
    
    # Add handlers
    application.add_handler(CommandHandler("start", start_command))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(CommandHandler("setniche", set_niche))
    application.add_handler(CommandHandler("setaudience", set_audience))
    application.add_handler(CommandHandler("settone", set_tone))
    application.add_handler(CallbackQueryHandler(button_callback))
    
    # Setup scheduler for automated posts
    scheduler = AsyncIOScheduler()
    
    # Schedule posts at specified times
    for post_time in Config.POSTING_TIMES:
        hour, minute = map(int, post_time.split(':'))
        scheduler.add_job(
            automated_post_job,
            CronTrigger(hour=hour, minute=minute),
            args=[application]
        )
    
    scheduler.start()
    
    logger.info("Bot started successfully!")
    logger.info(f"Scheduled posts at: {Config.POSTING_TIMES}")
    
    # Run the bot
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == '__main__':
    main()
