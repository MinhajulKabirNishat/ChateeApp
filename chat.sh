#!/bin/bash

PORT=5000
LOG_FILE="logs/chat.log"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RESET="\033[0m"




echo "Enter your username:"
read USERNAME


if [ "$1" == "server" ]; then
    echo -e "${GREEN}🟢 Chat server started on port $PORT${RESET}"

    echo "Waiting for client..."
    echo "Messages will be logged in $LOG_FILE"

    ncat -l -p $PORT | while read MESSAGE; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

   
    if [[ "$MESSAGE" == *"left the chat"* ]]; then
        echo -e "${YELLOW}[$TIMESTAMP] $MESSAGE${RESET}"
    else
        echo -e "${BLUE}[$TIMESTAMP] $MESSAGE${RESET}"
    fi

  
    echo "[$TIMESTAMP] $MESSAGE" >> "$LOG_FILE"
done



elif [ "$1" == "client" ]; then
    if [ -z "$2" ]; then
        echo "❌ Usage: ./chat.sh client <SERVER_IP>"
        exit 1j
    fi

    echo "🔵 Connected to server at $2:$PORT"
    echo "Type messages and press Enter (Ctrl+C to exit)"

   while true; do
    read MESSAGE

    if [ "$MESSAGE" == "/exit" ]; then
       echo "[$USERNAME] left the chat."
       echo "[$USERNAME] left the chat." | ncat "$2" $PORT

 
        break
    fi

    echo "[$USERNAME]: $MESSAGE" | ncat "$2" $PORT
done



else
    echo "Usage:"
    echo "  ./chat.sh server"
    echo "  ./chat.sh client <SERVER_IP>"
fi
