import mysql.connector
import random
import time
import requests

# Connect to the Database (grabs information from db.py)
from db import db_user, db_password, db_host, db_name

# Replace with your Discord API token and channel ID
discord_token = "your-bot-token"
channel_id = "your-discord-channel-id"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = "Daily challenges have been reset and new challenges are available."
requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})

# Randomize the active challenges
cursor.execute("SELECT COUNT(*) FROM Challenges WHERE active IS NOT NULL")
active_count = cursor.fetchone()[0]
if active_count > 0:
    active_challenges = random.sample(range(2, active_count + 1), min(3, active_count - 1))
    for i, challenge_id in enumerate(active_challenges, start=1):
        cursor.execute(f"UPDATE Challenges SET active = {i} WHERE id = {challenge_id}")
    cnx.commit()

    # Set all other challenges to inactive
    all_challenges = set(range(2, active_count + 1))  # get all challenges with an active value of NULL
    inactive_challenges = all_challenges - set(active_challenges)  # get the set difference between all and active challenges
    for challenge_id in inactive_challenges:
        cursor.execute(f"UPDATE Challenges SET active = NULL WHERE id = {challenge_id}")
    cnx.commit()

# Check if the previously active table had a highest score and charName value
cursor.execute("SELECT id, info, highestScore, charName FROM Challenges WHERE active = 1 AND highestScore IS NOT NULL AND charName != ''")
row = cursor.fetchone()
if row:
    id, info, highest_score, char_name = row

    # Send a message to the Discord channel
    message = f"Congratulations {char_name.capitalize()}, you achieved the highest score in one of today's daily activities! ({info})"
    requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})

    # Clear the charName table and set the highest score to 0
    cursor.execute(f"UPDATE Challenges SET highestScore = 0, charName = '' WHERE id = {id} AND charName != ''")
    cnx.commit()

# Sleep for 60 seconds before restarting the script
time.sleep(60)
