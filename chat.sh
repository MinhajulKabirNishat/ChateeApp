#!/bin/bash

PORT=5000
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/chat.log"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# -------------------------------
# Create logs directory if missing
# -------------------------------
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

# -------------------------------
# SERVER MODE
# -------------------------------
if [ "$1" == "server" ]; then
    echo -e "${GREEN}🟢 Chat server started on port $PORT${RESET}"
    echo -e "${GREEN}📝 Logging to $LOG_FILE${RESET}"
    echo ""

    # ncat server
    ncat -l -p $PORT --keep-open | while read MESSAGE; do
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        LOG_LINE="[$TIMESTAMP] $MESSAGE"

        echo -e "${BLUE}$LOG_LINE${RESET}"
        echo "$LOG_LINE" >> "$LOG_FILE"
    done
fi

# -------------------------------
# CLIENT MODE
# -------------------------------
if [ "$1" == "client" ]; then
    if [ -z "$2" ]; then
        echo "Usage: ./chat.sh client <SERVER_IP>"
        exit 1
    fi

    echo -n "Enter your username: "
    read USERNAME

    echo "🔵 Connected to server $2:$PORT"
    echo "Type messages. Type /exit to leave."

    {
        echo "[$USERNAME] joined the chat"

        while read MESSAGE; do
            if [ "$MESSAGE" == "/exit" ]; then
                echo "[$USERNAME] left the chat"
                exit
            fi
            echo "[$USERNAME]: $MESSAGE"
        done
    } | ncat "$2" $PORT
fi
