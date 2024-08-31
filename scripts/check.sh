#!/usr/bin/bash

if type "java" &>/dev/null; then
    echo "[*] Java"
else
    echo "[ ] Java"
fi

if type "conda" &>/dev/null; then
    echo "[*] Conda"
else
    echo "[ ] Conda"
fi
