#!/bin/bash

# Maximum uptime before restart (in seconds)
max_uptime=60 #12 hours

# Define Discord webhook URL here
discord_webhook_url="https://discordapp.com/api/webhooks/1077366002960052255/86L1-gLeW3qOhxYDCx8fNf3A5GTs4vICw28az22TAeHP_hvsx4KnpKNDj7e-eERLhajH"

# Check if the Red5 server is running
if pgrep -f red5.jar > /dev/null; then
    echo "Red5 server is already running."

    # Get the PID of the Red5 server process
    pid=$(pgrep -f red5.jar)

    # Get the uptime of the Red5 server process in seconds
    uptime=$(($(date +%s) - $(date -d "$(ps -p $pid -o lstart=)" +%s)))

    if [[ $uptime -gt $max_uptime ]]; then
        echo "Red5 server has been running for longer than 12 hours... Time for a restart!"
        curl -H "Content-Type: application/json" -d "{\"content\": \"The game server will be restarting and it'll take up to 60 seconds. Please stand by...\"}" "$discord_webhook_url"
        killall -9 screen
        screen -dmS red5 sh /home/localhost/red5/red5.sh
        sleep 60
        curl -H "Content-Type: application/json" -d "{\"content\": \"The game server is now back online. Thank you for your patience!\"}" "$discord_webhook_url"
    else
        echo "Red5 server has been running for less than 12 hours. No need to restart just yet."
    fi
else
    echo "Red5 server is not running. Starting it now..."
    curl -H "Content-Type: application/json" -d "{\"content\": \"The game server is starting up. Please allow a moment for it to come online...\"}" "$discord_webhook_url"
    screen -dmS red5 sh /home/localhost/red5/red5.sh
    sleep 60
    curl -H "Content-Type: application/json" -d "{\"content\": \"The game server is now online! Enjoy!\"}" "$discord_webhook_url"
fi
