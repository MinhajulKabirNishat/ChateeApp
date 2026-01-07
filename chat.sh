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
    echo -e "${GREEN}Multiple clients supported${RESET}"
    echo -e "${GREEN}Messages logged to $LOG_FILE${RESET}"

    ncat -l -p $PORT --keep-open --broker | while read MESSAGE; do
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
        exit 1
    fi

    echo "🔵 Connected to server at $2:$PORT"
    echo "Type messages. Type /exit to leave."

    
    {
        while read MESSAGE; do
            if [ "$MESSAGE" == "/exit" ]; then
                echo "[$USERNAME] left the chat."
                echo "[$USERNAME] left the chat."
                break
            fi
            echo "[$USERNAME]: $MESSAGE"
        done
    } | ncat "$2" $PORT



else
    echo "Usage:"
    echo "  ./chat.sh server"
    echo "  ./chat.sh client <SERVER_IP>"
fi
