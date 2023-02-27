import json
import random
import mysql.connector
import requests
import time
import xml.etree.ElementTree as ET

# Replace with the path to your JSON file containing the dirty words
json_file = 'DirtyWords.json'

# Load the dirty words from the JSON file
with open(json_file) as f:
    dirty_words = json.load(f)['RECORDS']

# Create a set of dirty words for fast lookup
dirty_words = {record['word'] for record in dirty_words}

# Replace with the path to your XML file
xml_file = 'kavalok.enUS.xml'

# Parse the XML file
tree = ET.parse(xml_file)
root = tree.getroot()

# Create the location code to location name mapping
location_mapping = {}
for elem in root:
    location_mapping[elem.tag] = elem.text

# Create the server location code to location server name mapping
locationserver_mapping = {}
for elem in root:
    locationserver_mapping[elem.tag] = elem.text

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord webhook URL
webhook_url = "https://discordapp.com/api/webhooks/1077309084233109535/NkIF2SyfGMhYjesVMZAZvmYjoUI1KPs948C7GHxsQ9apaGxy7IJ4UvkbUtif1uGvk-DY"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = f"**Chat Tool Online**"
requests.post(webhook_url, json={"content": message})

# Get the last id in the ChatLog table
query = "SELECT MAX(id) FROM ChatLog"
cursor.execute(query)
last_id = cursor.fetchone()[0]

def censor_word(word):
    # Replace the word with asterisks of the same length
    return ''.join(['$' for _ in range(len(word))])

while True:
    # Check for new entries in the ChatLog table
    query = f"SELECT id, created, location, message, server, ip, username, userId FROM ChatLog WHERE id > {last_id}"
    cursor.execute(query)
    entries = cursor.fetchall()

    for entry in entries:
        id, created, location, message, server, ip, username, userId = entry

        # Map the location code to the location name
        location_name = location_mapping.get(location, location)
        # Map the server location code to the server name
        server_name = locationserver_mapping.get(server, server)

        # Split the message into words
        words = message.split()

        # Check if any of the words are dirty words
        if any(word.lower() in dirty_words for word in words):
                        message = "(<:chobots_sad:981649955561299978> This message has been removed, as it is deemed against our rules. <:cho7:931721598979956746>)"
        else:
            # Join the words back together to form the message
            message = ' '.join(words)

        # Capitalize the first letter of the username
        username = username.capitalize()

        # Check if the user is a staff member or agent
        query = f"SELECT staff, agent FROM User WHERE id = {userId}"
        cursor.execute(query)
        result = cursor.fetchone()

        if result is not None:
            staff, agent = result
            if staff == 1:
                username = f"<:newmodbadgechobots:981764495250698263> {username}"
            elif agent == 1:
                username = f"<:newagentbadgechobots:981764495728840704> {username}"




        # Send a message to the Discord channel
        message = f"**[{created.strftime('%b %d, %Y %I:%M %p')}] [{location_name}] [{server_name}]** *{username}*: {message}"
        requests.post(webhook_url, json={"content": message})

        # Print the message to the console
        print(message)

        # Update the last id
        last_id = id

    # Sleep for a short interval before checking again
    time.sleep(3)

cursor.close()
cnx.close()
