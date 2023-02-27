import subprocess
import time

def run_script(script_path):
    subprocess.Popen(["/usr/bin/python3", script_path])

run_script("chatlog-discordbot.py")
run_script("user-login-discordbot.py")
run_script("competition-discordbot.py")
#run_script("vault-discordbot.py")
#run_script("dailychallenges-discordbot.py")
#run_script("petadopt-discordbot.py")
#run_script("newuser-discord.py")

while True:
    # Keep the main process running
    time.sleep(60)
