#!/bin/bash

#script som skapar användare och deras katalogstruktur

#kontrollerar så det körs från root
if [ "$EUID" -ne 0 ]; then
    echo "Scriptet måste köras som root"
    exit 1
fi

#steg1: skapa användare
for username in "$@"
do
    useradd -m "$username"
done

#steg2: skapa mappar och filer
for username in "$@"
do

    HOME_DIR="/home/$username"

    #skapa mappar
    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    #sätt ägare
    chown -R "$username":"$username" "$HOME_DIR"

    #sätt rättigheter
    chmod 700 "$HOME_DIR/Work"

    #skapa welcome.txt
    echo "Välkommen $username" > "$HOME_DIR/welcome.txt"

    #lista alla användare
    cut -d: -f1 /etc/passwd >> "$HOME_DIR/welcome.txt"

done