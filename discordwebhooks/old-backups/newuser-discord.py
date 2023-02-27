import mysql.connector
import requests
import time

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord webhook URL
webhook_url = "https://discordapp.com/api/webhooks/1077294930403283045/KjT6AD86to4m1VKDSzh5EUeX6dBNV-JAtU6F_kN3JYyepZST_hEN29ETky_ihDmDIeby"

# Connect to the database
try:
    cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
    print("Successful database connection")
except mysql.connector.Error as error:
    print("Error connecting to database:", error)
    exit()

cursor = cnx.cursor()

# Get the last created timestamp in the GameChar table
query = "SELECT MAX(created) FROM GameChar"
cursor.execute(query)
last_created_result = cursor.fetchone()
if last_created_result is not None:
    last_created = last_created_result[0]
else:
    last_created = 0

while True:
    # Check for new entries in the GameChar table
    query = f"SELECT id, userId, created FROM GameChar WHERE created > '{last_created}'"
    cursor.execute(query)
    entries = cursor.fetchall()

    if entries:
        print("New game character(s) found")
        for entry in entries:
            id, user_id, created = entry

            # Get the login for the corresponding user
            query = f"SELECT login FROM User WHERE id = {user_id}"
            cursor.execute(query)
            login = cursor.fetchone()[0]

            current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime())

            # Send a message to the Discord channel
            message = f"{login} has created a new game character. Game character created on {current_time} and has id {id}."
            response = requests.post(webhook_url, json={"content": message})
            print("Sending discord webhook request... Response:", response.text)

            # Update the last created timestamp
            last_created = created
    else:
        print("No new game character found")


    # Sleep for 10 seconds before checking again
    time.sleep(10)

cursor.close()
cnx.close()
