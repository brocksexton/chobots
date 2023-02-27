import mysql.connector
import requests
import json
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
print("Database Connected & Connected to Discord")

# Send a message to the Discord channel
message = f"**Vault Monitor Online**"
requests.post(webhook_url, json={"content": message})
print(message)

# Get the last claimedById in the Vault table
query = "SELECT MAX(claimedById) FROM Vault"
cursor.execute(query)
last_claimed_by_id_result = cursor.fetchone()
if last_claimed_by_id_result is not None:
    last_claimed_by_id = last_claimed_by_id_result[0]
    print(last_claimed_by_id)
else:
    last_claimed_by_id = None
    print(last_claimed_by_id)

# Load the log of previous claimedById values
log_file = open("vault_log.txt", "a+")
log_file.seek(0)
vault_log = set(log_file.read().splitlines())
print("loaded vault_log.txt")

while True:
    # Check for new entries in the Vault table
    query = f"SELECT claimedById FROM Vault WHERE claimedById > {last_claimed_by_id}"
    cursor.execute(query)
    entries = cursor.fetchall()

    if entries:
        for entry in entries:
            claimed_by_id = entry[0]

            # Check if the claimedById value is new
            if claimed_by_id not in vault_log:
                # Add the claimedById value to the log
                vault_log.add(claimed_by_id)

                # Get the user's name from the User table
                query = f"SELECT login FROM User WHERE id = {claimed_by_id}"
                cursor.execute(query)
                user_login_result = cursor.fetchone()

                if user_login_result is not None:
                    user_login = user_login_result[0]

                    # Capitalize the first letter of the user's name
                    username = user_login.capitalize()

                    # Send a message to the Discord channel
                    message = f"Congratulations to {username} for redeeming a Vault ID!"
                    print(message)
                    requests.post(webhook_url, json={"content": message})

                    # Write the event to the log file
                    log_file.write(f"{claimed_by_id}\n")
            else:
                print(f"claimedById {claimed_by_id} already in log")

            # Update the last claimedById value
            last_claimed_by_id = claimed_by_id

    # Sleep for a short interval before checking again
    time.sleep(10)
    print("Vault Check Refreshed")

cursor.close()
cnx.close()
log_file.close()
