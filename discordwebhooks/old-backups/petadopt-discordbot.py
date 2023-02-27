import time
import mysql.connector
import requests

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

# Get the last id in the Pet table
query = "SELECT MAX(id) FROM Pet"
cursor.execute(query)
last_id = cursor.fetchone()[0]

while True:
    try:
        # Check for new entries in the Pet table
        query = f"SELECT id, created, name, gameChar_id FROM Pet WHERE id > {last_id}"
        cursor.execute(query)
        entries = cursor.fetchall()


        for entry in entries:
            id, created, pet_name, gameChar_id = entry

            # Get the username of the user who adopted the pet
            query = f"SELECT username FROM User WHERE id = (SELECT user_id FROM GameChar WHERE id = {gameChar_id})"
            cursor.execute(query)
            username = cursor.fetchone()[0]

            # Capitalize the first letter of the username and pet name
            username = username.capitalize()
            #pet_name = pet_name.capitalize()

            # Format the message
            message = f"**{username} has adopted a new pet! Everyone welcome {pet_name} to Chobots! - Adopted on {created.strftime('%b %d, %Y %I:%M %p')}**"

            # Send the message to the Discord channel
            response = requests.post(webhook_url, json={"content": message})

            # Print the message to the console
            print(f"Message sent: {message}")
            print(f"Discord response: {response.status_code}")

            # Update the last id
            last_id = id

        # Sleep for 2 minutes before checking again
        time.sleep(120)

    except Exception as e:
        print(f"Error: {e}")

cursor.close()
cnx.close()
