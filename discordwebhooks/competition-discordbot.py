import mysql.connector
import requests
import datetime
import time
import xml.etree.ElementTree as ET

# Replace with the path to your XML file
xml_file = 'competitions.enUS.xml'

# Parse the XML file
tree = ET.parse(xml_file)
root = tree.getroot()

# Create the location code to location name mapping
location_names = {}
for elem in root:
    location_names[elem.tag] = elem.text

# Print the competition names mapping
#print(location_names)

# Connect to the Database (grabs information from db.py)
from db import db_user, db_password, db_host, db_name

# Replace with your Discord API token and channel ID
discord_token = "your-bot-token"
channel_id = "your-discord-channel-id"

# Replace with your log file path
log_file_path = "competition_log.txt"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = f"**Competition Tool Online**"
requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})
print("Database Connected & Connected to Discord")

# Get the current datetime on the server
now = datetime.datetime.now()
print("Date & Time {now}")

# Check for competitions that have ended more than 2 weeks ago
query = f"SELECT id, name, start, finish FROM Competition WHERE finish < '{(now - datetime.timedelta(weeks=2)).strftime('%Y-%m-%d %H:%M:%S')}'"
cursor.execute(query)
competitions = cursor.fetchall()
print("Checking for competitions that have ended more than 2 weeks ago")

if competitions:
    for competition in competitions:
        id, location, start, finish = competition

        # Map the location code to the location name
        location_name = location_names.get(location, location)

        # Calculate the new start and finish dates
        start = now + datetime.timedelta(hours=2)
        new_finish = start + datetime.timedelta(weeks=1)

        # Update the competition in the database
        query = f"UPDATE Competition SET start = '{start.strftime('%Y-%m-%d %H:%M:%S')}', finish = '{new_finish.strftime('%Y-%m-%d %H:%M:%S')}' WHERE id = {id}"
        cursor.execute(query)
        cnx.commit()

        # Send a message to the Discord channel
        message = f"The {location_name} competition starting soon! It starts <t:{int(start.timestamp())}:R>."
        requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})
        print(f"Sent message to Discord channel: {message}")

        # Write to the log file
        with open(log_file_path, 'a') as f:
            f.write(f"{location} competition started at {now}.\n")

        # Wait for a short interval before checking again
        time.sleep(60)
        print(f"Competition's Successfuly Scheduled to Start")
else:
    # Check for competitions that have started within the last 4 hours
    query = f"SELECT id, name, start, finish FROM Competition WHERE start >= '{(now - datetime.timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')}' AND start <= '{now.strftime('%Y-%m-%d %H:%M:%S')}'"
    cursor.execute(query)
    competitions = cursor.fetchall()
    print("Checking for competitions that have started within the last 4 hours")

    if competitions:
        for competition in competitions:
            id, name, start, finish = competition

            # Map the location code to the location name
            location_name = location_names.get(name, name)

            # Check the log file for the competition start time
            with open(log_file_path, 'r') as f:
                log = f.read()
                if f"{name} competition started at {start}\n" in log:
                    # The competition was already announced, skip it
                    continue

            # Send a message to the Discord channel
            start_str = start.strftime('%B %d, %Y %I:%M %p')
            finish_str = finish.strftime('%B %d, %Y %I:%M %p')
            message = f"The {location_names.get(name, name)} competition has started! It will run from {start_str} (<t:{int(start.timestamp())}:R>) to {finish_str} (<t:{int(finish.timestamp())}:R>)."
            requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})
            print(f"Sent message to Discord channel: {message}")

            # Write to the log file
            with open(log_file_path, 'a') as f:
                f.write(f"{name} competition started at {start}\n")

            # Wait for a short interval before checking again
            time.sleep(300)
            print(f"Competition's Successfully Announced")
    else:
        # Get the current datetime on the server
        now = datetime.datetime.now()

        # Check for competitions that have ended within the last 4 hours
        query = f"SELECT id, name, start, finish FROM Competition WHERE finish >= '{(now - datetime.timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')}' AND finish <= '{now.strftime('%Y-%m-%d %H:%M:%S')}'"
        cursor.execute(query)
        competitions = cursor.fetchall()

        if competitions:
            for competition in competitions:
                id, name, start, finish = competition

                # Map the location code to the location name
                location_name = location_names.get(name, name)

                # Send a message to the Discord channel
                finish_str = finish.strftime('%B %d, %Y %I:%M %p')
                message = f"The {location_names.get(name, name)} competition has ended! It ran from {start.timestamp} (<t:{int(start.timestamp())}:R>) to {finish_str} (<t:{int(finish.timestamp())}:R>)."
                requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})
                print(f"Sent message to Discord channel: {message}")

                # Wait for a short interval before checking again
                time.sleep(300)
                print(f"Competition's Successfully Ended")
        else:
            # No competitions to update or announce, wait for a short interval before checking again
            time.sleep(300)
            print(f"No Competition Updates")

