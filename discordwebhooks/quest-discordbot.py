import mysql.connector
import random
import time

# connect to MySQL database
mydb = mysql.connector.connect(
  host="149.248.56.2",
  user="ossnman",
  password="di72Vj3gxKkcfyJN",
  database="chobotscajune2022"
)

# create a cursor to interact with the database
cursor = mydb.cursor()

# create a webhook to send messages to a Discord channel
webhook_url = "https://discordapp.com/api/webhooks/1077366002960052255/86L1-gLeW3qOhxYDCx8fNf3A5GTs4vICw28az22TAeHP_hvsx4KnpKNDj7e-eERLhajH"
webhook = DiscordWebhook(url=webhook_url)

# set the minimum and maximum number of days before disabling a quest
MIN_DAYS_ENABLED = 5
MAX_DAYS_ENABLED = 7

# set the minimum and maximum number of days before enabling a quest again
MIN_DAYS_DISABLED = 7
MAX_DAYS_DISABLED = 14

# query to get the list of enabled quests
select_enabled_quest_query = "SELECT id, name FROM Quest WHERE enabled = 1"

# get the list of enabled quests from the database
cursor.execute(select_enabled_quest_query)
enabled_quests = cursor.fetchall()

# if there are no enabled quests, do nothing
if len(enabled_quests) == 0:
  print("No enabled quests")
else:
  # choose a random quest to disable
  quest_to_disable = random.choice(enabled_quests)

  # disable the selected quest
  update_disabled_query = f"UPDATE Quest SET enabled = 0 WHERE id = {quest_to_disable[0]}"
  cursor.execute(update_disabled_query)
  mydb.commit()

  # log the time the quest was disabled
  log_disabled_query = f"INSERT INTO QuestLogs (quest_id, date_disabled) VALUES ({quest_to_disable[0]}, NOW())"
  cursor.execute(log_disabled_query)
  mydb.commit()

  # send a Discord message announcing the quest has been disabled
  embed = DiscordEmbed(title=f"{quest_to_disable[1]} has left the world of Chobots", description="They will return in the future.", color='03b2f8')
  webhook.add_embed(embed)
  response = webhook.execute()

  # wait for a random interval before enabling another quest
  days_to_wait = random.randint(MIN_DAYS_DISABLED, MAX_DAYS_DISABLED)
  print(f"Waiting {days_to_wait} days before enabling another quest")
  time.sleep(days_to_wait * 24 * 60 * 60)

  # get the list of disabled quests from the log
  select_disabled_query = "SELECT quest_id, date_disabled FROM QuestLogs WHERE date_enabled IS NULL"
  cursor.execute(select_disabled_query)
  disabled_quests = cursor.fetchall()

  # if there are no disabled quests, do nothing
  if len(disabled_quests) == 0:
    print("No disabled quests")
  else:
    # choose a random quest to enable
    quest_to_enable = random.choice(disabled_quests)

    # enable the selected quest
    update_enabled_query = f"UPDATE Quest SET enabled = 1 WHERE id = {quest_to_enable[0]}"
    cursor.execute(update_enabled_query)
    mydb.commit()

    # log the time the quest was enabled
    log_enabled_query = f"UPDATE QuestLogs SET date_enabled = NOW() WHERE quest_id = {quest_to_enable[0]} AND date_enabled IS NULL"
    cursor.execute(log_enabled_query)
    mydb.commit()

    # send a Discord message announcing the quest has been enabled
    embed = DiscordEmbed(title=f"{quest_to_enable[1]} is visiting the world of Chobots", description="They are only here for a limited time, so visit them while you can.")
    webhook.add_embed(embed)
    response = webhook.execute()

    # update QuestLogs table
    cursor.execute(f"UPDATE QuestLogs SET date_enabled = '{datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')}' "f"WHERE quest_id = {quest_to_enable[0]} AND date_disabled IS NOT NULL")

    # commit the changes to the database
    cnx.commit()

    # sleep for 5 days before disabling the quest
    time.sleep(432000)

    # select the enabled quest
    cursor.execute(f"SELECT * FROM Quest WHERE enabled = 1")
    quests = cursor.fetchall()

    if quests:
        quest_to_disable = random.choice(quests)

        # send a Discord message announcing the quest has been disabled
        embed = DiscordEmbed(title=f"{quest_to_disable[1]} has left the world of Chobots", description="They will return in the future.")
        webhook.add_embed(embed)
        response = webhook.execute()

        # update QuestLogs table
        cursor.execute(f"INSERT INTO QuestLogs (quest_id, date_disabled) "
                    f"VALUES ({quest_to_disable[0]}, '{datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')}')")

        # disable the quest
        cursor.execute(f"UPDATE Quest SET enabled = 0 WHERE id = {quest_to_disable[0]}")

        # commit the changes to the database
        cnx.commit()

    cnx.close()
