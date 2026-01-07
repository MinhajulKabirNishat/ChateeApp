#!/bin/bash

PORT=5000

if [ "$1" == "server" ]; then
    echo "🟢 Chat server started on port $PORT"
    echo "Waiting for client..."
    ncat -l -p $PORT

elif [ "$1" == "client" ]; then
    if [ -z "$2" ]; then
        echo "❌ Usage: ./chat.sh client <SERVER_IP>"
        exit 1
    fi

    echo "🔵 Connected to server at $2:$PORT"
    ncat "$2" $PORT

else
    echo "Usage:"
    echo "  ./chat.sh server"
    echo "  ./chat.sh client <SERVER_IP>"
fi
