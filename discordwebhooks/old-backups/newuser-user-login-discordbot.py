import mysql.connector
import requests
import time

# Replace with your database credentials
db_user = "ossnman"
db_password = "di72Vj3gxKkcfyJN"
db_host = "149.248.56.2"
db_name = "chobotscajune2022"

# Replace with your Discord webhook URL
webhook_url = "https://discordapp.com/api/webhooks/1077309084233109535/NkIF2SyfGMhYjesVMZAZvmYjoUI1KPs948C7GHxsQ9apaGxy7IJ4UvkbUtif1uGvk-DY"

# Connect to the database
try:
    cnx = mysql.connector.connect(user=db_user, password=db_password, host=db_host, database=db_name)
    print("Successful database connection")
except mysql.connector.Error as error:
    print("Error connecting to database:", error)
    exit()

cursor = cnx.cursor()

# Get the last id in the UserServer table
query = "SELECT MAX(id) FROM UserServer"
cursor.execute(query)
last_user_server_id_result = cursor.fetchone()
if last_user_server_id_result is not None:
    last_user_server_id = last_user_server_id_result[0]
else:
    last_user_server_id = 0

# Get the last created timestamp in the GameChar table
query = "SELECT MAX(created) FROM GameChar"
cursor.execute(query)
last_game_char_created_result = cursor.fetchone()
if last_game_char_created_result is not None:
    last_game_char_created = last_game_char_created_result[0]
else:
    last_game_char_created = 0

while True:
    # Check for new entries in the UserServer table
    query = f"SELECT id, userId, serverId FROM UserServer WHERE id > {last_user_server_id}"
    cursor.execute(query)
    user_server_entries = cursor.fetchall()

    if user_server_entries:
        for entry in user_server_entries:
            id, userId, serverId = entry

            # Get the login from the User table
            query = f"SELECT login FROM User WHERE id = {userId}"
            cursor.execute(query)
            login = cursor.fetchone()
            if login is not None:
                display_name = login[0]
            else:
                display_name = "Unknown User"

            # Get the server name
            server_name = "Chocolate" if serverId == 1 else "Vanilla"

            # Send a message to the Discord channel
            message = f"{display_name} has logged in and entered server {server_name}"
            requests.post(webhook_url, json={"content": message})

            # Update the last id
            last_user_server_id = id

    # Check for new entries in the GameChar
    query = f"SELECT id, userId, created FROM GameChar WHERE created > '{last_game_char_created}'"
    cursor.execute(query)
    game_char_entries = cursor.fetchall()

    if game_char_entries:
        print("New game character(s) found")
        for entry in game_char_entries:
            id, user_id, created = entry

            # Subtract 1 from the user_id to get the corresponding login
            user_id -= 1

            # Get the login for the corresponding user
            query = f"SELECT login FROM User WHERE id = {user_id}"
            cursor.execute(query)
            login = cursor.fetchone()
            if login is not None:
                display_name = login[0]
            else:
                display_name = "Unknown User"

            current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime())

            # Send a message to the Discord channel
            message = f"{display_name} has created a new game character. Game character created on {current_time} and has id {id}."
            response = requests.post(webhook_url, json={"content": message})
            print("Sending discord webhook request... Response:", response.text)

            # Update the last created timestamp
            last_game_char_created = created
    else:
        print("No new game character found")

    # Sleep for 10 seconds before checking again
    time.sleep(10)

cursor.close()
cnx.close()