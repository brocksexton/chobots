# Chobots - Master Branch
![Chobots Logo](https://play.chobots.wiki/assets/images/logo.png)

Welcome to the Chobots repository! This repository contains the complete source code for the online multiplayer game Chobots - The Virtual World. In this repository, you will find all the files and folders necessary to build the game, as well as additional tools and resources to enhance your experience.

## Repository Structure

The repository consists of the following folders:

1. build-script-logs: This folder contains logs generated by the build-script.sh file.
2. discordwebhooks: This folder contains python files used to generate Discord Notifications & Modify the Database. The user can run all of these files by using `python3 ./runall.py`.
3. flex3sdk: This folder is named flex3 and is required for the game to build. To use this folder, users must run `chmod 777 /directory/flex3/bin/fcsh`.
4. trunk: This folder contains the source files and main game files for Chobots. To build the game, users can simply run `ant` in this folder or use the build-script.sh file.
5. server: This folder contains the files necessary to build the custom Red5 server. To build the server, users can simply run `ant` in this folder or use the build-script.sh file.
6. red5: This folder contains the built files generated by the server. To run the server, users can run `python3 ./red5-service-check.py` inside the red5 folder.

<sub><sup>More detailed information in each folder</sup></sub>

## Features

Chobots offers a wide range of features, including:

- Quests
- Pets
- Premium shop
- Administration/Moderator panel
- Quests
- Mini-games
- Multiplayer Games
- Citizenship
- Inventory/Wardrobe & Item Trading
- Much More (this is the complete source code of Chobots)

In addition, the game also includes new features not found in the original Chobots.com or Chobots.net, such as:

- In-Game Vault
- Custom UI's
- Outfit Saving
- Spin The Wheel
- Battle Pass & Level System (Leveling System originally included in Chobots.net, modified for Battle Pass)
- Weekly Challenges
- In-Game Market
- Item Color Changer
- In-Game Moderation Panel (WIP)
- Dual Colour Items
- Preview before buying in the shop
- Emeralds Premium Currency
- XP/Bug Multipliers
- Night Time
- More Emotes

## Building the Source

To build the source code, simply run `ant` in the terminal inside the trunk & server directories respectively. A build should take no longer than 2-3 minutes for trunk, or 20-30 seconds for server.

## Resources

For more information about Chobots, please visit [Chobots.wiki](https://www.chobots.wiki/).

For more development information about Chobots, please visit [dev.Chobots.wiki](https://dev.chobots.wiki/).

Join our Discord! [Discord](https://discord.gg/ewnWbAbqtk).

## Important
This repository contains the work of dozens of developers over the course of 2007 up until 2023 (and may continue to be updated with Pull Requests or if I ever personally continue to have the time) - Chobots has left a large impact on the hearts of many and I'm hoping a repository with documentation and information can help it continue to live. Please refer to the Wiki linked above to learn more.
