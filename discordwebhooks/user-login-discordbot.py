import mysql.connector
import requests
import time
import json

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord API token and channel ID
discord_token = "OTM0Njc4NDEzMzU1MTUxNDIw.G8kw8y.MIZKhGmdWvlO1MkAwEw6hgROl5M1netz16a5_I"
channel_id = "1077309053849567263"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = f"**User Login Tool Online**"
requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})

# Get the last id in the UserServer table
query = "SELECT MAX(id) FROM UserServer"
cursor.execute(query)
last_id_result = cursor.fetchone()
if last_id_result is not None:
    last_id = last_id_result[0]
else:
    last_id = 0

# Load the log of previous users who have logged in
log_file = open("user_log.txt", "a+")
log_file.seek(0)
user_log = set(log_file.read().splitlines())

while True:
    # Check for new entries in the UserServer table
    query = f"SELECT id, userId, serverId FROM UserServer WHERE id > {last_id}"
    cursor.execute(query)
    entries = cursor.fetchall()

    if entries:
        for entry in entries:
            id, userId, serverId = entry

            # Get the login from the User table
            query = f"SELECT login FROM User WHERE id = {userId}"
            cursor.execute(query)
            display_name = cursor.fetchone()[0]

            # Get the server name
            server_name = "Chocolate" if serverId == 1 else "Vanilla"

            # Check if the user is new
            if display_name not in user_log:
                # Add the user to the log
                user_log.add(display_name)

                # Welcome the user
                welcome_message = f"Welcome to Chobots, {display_name}! We hope you have a great time playing our game!"
                print(f"{display_name} logged in for the first time! Sent message to Discord channel: {welcome_message}")
                requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": welcome_message})

            # Send a message to the Discord channel
            message = f"{display_name} has logged in and entered server {server_name}"
            print(f"{display_name} has logged in to {server_name} - Sent message to Discord channel: {message}")
            requests.post(f"https://discordapp.com/api/channels/{channel_id}/messages", headers={"Authorization": f"Bot {discord_token}"}, json={"content": message})

            # Write the user to the log file
            log_file.write(display_name + "\n")

            # Update the last id
            last_id = id

    # Get the total number of users online
    query = f"SELECT COUNT(*) FROM UserServer"
    cursor.execute(query)
    total_users = cursor.fetchone()[0]

    # Get the number of users online in each server
    query = "SELECT COUNT(*) FROM UserServer WHERE serverId = 1"
    cursor.execute(query)
    chocolate_users = cursor.fetchone()[0]

    query = "SELECT COUNT(*) FROM UserServer WHERE serverId = 2"
    cursor.execute(query)
    vanilla_users = cursor.fetchone()[0]

    # Update the channel topic
    url = f"https://discordapp.com/api/channels/{channel_id}"
    headers = {"Authorization": f"Bot {discord_token}", "Content-Type": "application/json"}
    data = {"topic": f"Total Online Users: {total_users} - Chocolate: {chocolate_users} - Vanilla: {vanilla_users}"}
    response = requests.patch(url, headers=headers, data=json.dumps(data))
    #print(response.text)  # print the response from Discord API

    # Wait for a short interval before checking again
    time.sleep(10)

cursor.close()
cnx.close()
