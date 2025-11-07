#!/bin/bash

BUNGEE_PID=""
SERVER_PID=""

while true; do
  current_hour=$(TZ="Europe/Helsinki" date +%H)

  if [ "$current_hour" -ge 6 ] && [ "$current_hour" -lt 22 ]; then
    if [ -z "$SERVER_PID" ]; then
      echo "Starting Eaglercraft server..."

      cd bungee
      java -jar bungee.jar &
      BUNGEE_PID=$!
      cd ..
      cd server
      java -jar server.jar &
      SERVER_PID=$!

      echo "Server launched. Emotional uptime active."
    else
      echo "Server already running. Emotional uptime continues."
    fi
  else
    if [ -n "$SERVER_PID" ]; then
      echo "Downtime window detected (10PM–6AM EST). Initiating shutdown ritual..."

      kill $SERVER_PID
      kill $BUNGEE_PID

      SERVER_PID=""
      BUNGEE_PID=""

      echo "Server offline. Emotional uptime paused."
    else
      echo "Server remains offline. Ritual window active. Next check in 1 hour..."
    fi
  fi

  sleep 3600
done
