#!/bin/bash

# Define Discord webhook URL here
discord_webhook_url="https://discordapp.com/api/webhooks/1077366002960052255/86L1-gLeW3qOhxYDCx8fNf3A5GTs4vICw28az22TAeHP_hvsx4KnpKNDj7e-eERLhajH"

# Create build log directory if it doesn't exist
build_log_dir="/home/localhost/build-script-logs"
if [ ! -d "$build_log_dir" ]; then
  mkdir "$build_log_dir"
fi

# Define function to send Discord webhook message
function send_discord_webhook {
  message=$1
  curl -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" "$discord_webhook_url"
}

# Step 1: Go to /home/localhost/trunk and run "ant build"
cd /home/localhost/trunk
echo "Building Trunk, please wait 3-4 minutes..."
ant > "$build_log_dir/1-build-trunk.log" 2>&1

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Build successful for trunk"
    send_discord_webhook "Game Files Successfully built, building Red5 Server"

    # Step 2: Go to /home/localhost/server and run "ant build"
    cd /home/localhost/server
    ant > "$build_log_dir/2-build-server.log" 2>&1

    # Check if the build was successful
    if [ $? -eq 0 ]; then
        echo "Build successful for server"
        send_discord_webhook "Build successful for Red5 Server"

        # Step 3: Shut down the Red5 server and restart it
        echo "Shutting down Red5 server..."
        send_discord_webhook "Shutting down Red5 server..."
        killall -9 java
        echo "Starting Red5 server..."
        send_discord_webhook "Starting Red5 Server..."
        cd /home/localhost/red5
        screen -dmS red5 sh red5.sh
        send_discord_webhook "Red5 Server Online, game is live at https://kavalok.net/"
    else
        echo "Build failed for server"
        send_discord_webhook "Build failed for Red5 Server, investigate log in server."
    fi
else
    echo "Build failed for trunk"
    send_discord_webhook "Build failed for Trunk/Game Files, investigate log in server."
fi

# Delete oldest build log if more than 7 logs exist
if [ $(ls -1 $build_log_dir | wc -l) -gt 7 ]; then
  oldest_build_log=$(ls -t $build_log_dir | tail -1) \
  rm "$build_log_dir/$oldest_build_log"
fi
