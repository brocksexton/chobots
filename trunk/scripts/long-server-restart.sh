#!/usr/bin/ruby

NAME="red5"
RED5_HOME="/usr/lib/#{NAME}"
PIDFILE="/var/run/#{NAME}.pid"
DAEMON="/etc/init.d/#{NAME}"
WAIT_TO_STOP=60
WAIT_TO_START=120
WAIT_ATOM_INTERVAL=10

def running?
  PID > 0 && `ps -p #{PID} | grep #{PID} | wc -l`.to_i > 0
end

def started?
  `grep "Startup done" #{RED5_HOME}/log/std.log | wc -l`.to_i > 0
end

def wait_up_to(time)
  (@tries+=1) * WAIT_ATOM_INTERVAL < time+WAIT_ATOM_INTERVAL && sleep(WAIT_ATOM_INTERVAL)
end

def reset_wait_counter
  @tries = 0
end

puts <<-MESSAGE
Hi, you have initialized Chobots super restarter !!!
Do you want to restart Chobots server ?
  say 'yes' - and press enter - and i will put chobots.com to maintanence
  say anything else - and chobots.com will stay online"
MESSAGE
exit unless $stdin.readline {} =~ /yes\W+/

`sudo /root/bin/start-maintanence.sh`

# remember pid
PID=`if [ -f #{PIDFILE} ];then cat #{PIDFILE}; fi`.to_i
PID=`sudo ps x | grep red5 | grep -v grep | awk '{print $1}'`.to_i unless running?
# stop red5
# wait max 6x10 seconds in a loop and check if it's stopped
  # kill if not down

puts `sudo #{DAEMON} stop`

reset_wait_counter
puts "waiting for server to stop" while(running? && wait_up_to(WAIT_TO_STOP))
  
`sudo kill -9 #{PID}` and puts "killed the server" if running?

# start again
puts `sudo #{DAEMON} start`

# wait for start
reset_wait_counter
puts "waiting for server to start" while(!started? && wait_up_to(WAIT_TO_START))

unless started?
  puts <<-MESSAGE 
server still not started !! what the hell ?
i will show you the last 10 lines from the log and exit, CALL FOR HELP !!!!:
#{`sudo tail -10 #{RED5_HOME}/log/std.log`.gsub /^/, '    '}
  MESSAGE
  exit
end

puts <<-MESSAGE
server is started
check http://www.chobots.com/game/MainLoader.swf if everything is ok.
  say 'yes' - and i will remove chobots.com maintanence page
  say 'no' - and CALL FOR HELP !!! chobots.com will stay on maintanence"
MESSAGE

exit unless $stdin.readline {} =~ /yes\W+/

`sudo /root/bin/stop-maintanence.sh`
puts "Chobots is live"
