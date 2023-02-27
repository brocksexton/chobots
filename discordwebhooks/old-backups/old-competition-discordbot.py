import mysql.connector
import requests
import datetime
import time

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord API token and channel ID
discord_token = "OTMzMTk2MTg2MjYzOTAwMTcw.GnA1ye.rXBhoLLZy4x-OQ56jANI7hBTxIa6qSHuFvcEiI"
channel_id = "1077309053849567263"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = f"**Competition Tool Online**"
requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})


# Get the current datetime on the server
now = datetime.datetime.now()

# Check for competitions that have ended more than 2 weeks ago
query = f"SELECT id, name, start, finish FROM Competition WHERE finish < '{(now - datetime.timedelta(weeks=2)).strftime('%Y-%m-%d %H:%M:%S')}'"
cursor.execute(query)
competitions = cursor.fetchall()

if competitions:
    for competition in competitions:
        id, name, start, finish = competition

        # Calculate the new start and finish dates
        new_start = now + datetime.timedelta(hours=2)
        new_finish = new_start + datetime.timedelta(weeks=1)

        # Update the competition in the database
        query = f"UPDATE Competition SET start = '{new_start.strftime('%Y-%m-%d %H:%M:%S')}', finish = '{new_finish.strftime('%Y-%m-%d %H:%M:%S')}' WHERE id = {id}"
        cursor.execute(query)
        cnx.commit()

        # Send a message to the Discord channel with start and end dates as Discord timestamps
        start_timestamp = int(new_start.timestamp())
        end_timestamp = int(new_finish.timestamp())
        message = f"The {name} competition has started! It will run from <t:{start_timestamp}:f> to <t:{end_timestamp}:f>."
        requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})

        # Wait for a short interval before checking again
        time.sleep(14600)

cursor.close()
cnx.close()
