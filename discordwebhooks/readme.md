# discordwebhooks for Chobots

The discordwebhooks folder in the Chobots repository contains a collection of python scripts for generating Discord notifications and modifying the database. The following scripts are included:

1. chatlog-discordbot.py: This script grabs information from the ChatLog table in the database and outputs the conversation to a discord channel.
2. competition-discordbot.py: This script checks if competitions have been hosted in the last 2 weeks. If a competition was last hosted over 14 days ago, it will automatically set up the competition to be hosted and announce it in a discord channel with the date.
3. vault-discordbot.py: This script generates new vault codes for the Vault Cracking mini-game and checks the StuffType table to make sure an item exists before using it as a prize.
4. user-login-discordbot.py: This script tracks user logins and announces when a user has logged in and which server the user selected. It also announces when a user has logged in for the first time.
5. quest-discordbot.py: This script checks when the last time a Quest NPC has visited the world. If it's been over 7 days, it will consider activating the quest. If it has been more than 14 days, it will immediately enable the quest and announce that the Quest NPC is visiting the world. It will also announce when the quest has ended after 5-7 days of the quest being enabled.

To run all of these scripts at once, the suggested route is to use `python3 ./runall.py`. Note that all files currently require users to modify the database login & tokens before using.

For more information about Chobots please visit the main repository's [readme](https://github.com/ZeSquare/chobots/blob/main/README.md).
