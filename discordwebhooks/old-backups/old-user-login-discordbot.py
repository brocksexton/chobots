import mysql.connector
import requests
import time

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord webhook URL
webhook_url = "https://discordapp.com/api/webhooks/1077365678169923656/qSkiQRPvsVTxOV8kVi1k0eY7IjHwsjHxcRTqRxde85tjLrmjb66vY1mRZjeRjujojKnV"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = f"**User Login Tool Online**"
requests.post(webhook_url, json={"content": message})

# Get the last id in the UserServer table
query = "SELECT MAX(id) FROM UserServer"
cursor.execute(query)
last_id_result = cursor.fetchone()
if last_id_result is not None:
    last_id = last_id_result[0]
else:
    last_id = 0

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

            # Send a message to the Discord channel
            message = f"{display_name} has logged in and entered server {server_name}"
            requests.post(webhook_url, json={"content": message})

            # Update the last id
            last_id = id
    else:
        # Wait for a short interval before checking again
        time.sleep(10)

cursor.close()
cnx.close()
