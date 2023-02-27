import mysql.connector
import requests
import time

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord webhook URL
webhook_url = "https://discordapp.com/api/webhooks/1078963632609693709/b1wIxK2-AxxqgTz5hCms9g3aVTv534U_2NpQqCRwM_4-NaqCMJkcZRl72VNNiofOb0uU"

# Connect to the database
cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
cursor = cnx.cursor()

# Send a message to the Discord channel
message = f"**Vault Tool Online**"
requests.post(webhook_url, json={"content": message})

# Get the last claimedById in the Vault table
query = "SELECT MAX(claimedById) FROM Vault"
cursor.execute(query)
last_claimed_by_id = cursor.fetchone()[0]

while True:
    # Check for changes in the claimedById column in the Vault table
    query = f"SELECT id, code, prize, claimedById FROM Vault WHERE claimedById > {last_claimed_by_id}"
    cursor.execute(query)
    entries = cursor.fetchall()

    for entry in entries:
        id, code, prize, claimed_by_id = entry

        # Get the name of the user who claimed the prize
        query = f"SELECT username FROM User WHERE id = {claimed_by_id}"
        cursor.execute(query)
        result = cursor.fetchone()

        if result is not None:
            username = result[0]
            username = username.capitalize()

            # Send a message to the Discord channel
            message = f"**Vault Prize Claimed!** {username} has claimed prize {code} and won {prize}!"
            requests.post(webhook_url, json={"content": message})

            # Print the message to the console
            print(message)

        # Update the last claimedById
        last_claimed_by_id = claimed_by_id

    # Sleep for a short interval before checking again
    time.sleep(3)

cursor.close()
cnx.close()
