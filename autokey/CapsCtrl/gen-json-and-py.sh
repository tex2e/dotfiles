#!/bin/bash -e

for ch in {0..9}; do
cat <<EOS > .caps_$ch.json
{
    "type": "script",
    "description": "caps_$ch",
    "store": {},
    "modes": [
        3
    ],
    "usageCount": 0,
    "prompt": false,
    "omitTrigger": false,
    "showInTrayMenu": false,
    "abbreviation": {
        "abbreviations": [],
        "backspace": true,
        "ignoreCase": false,
        "immediate": false,
        "triggerInside": false,
        "wordChars": "[\\\\w]"
    },
    "hotkey": {
        "modifiers": [
            "<hyper>"
        ],
        "hotKey": "$ch"
    },
    "filter": {
        "regex": null,
        "isRecursive": false
    }
}
EOS
cat <<EOS > caps_$ch.py
keyboard.send_keys("<ctrl>+$ch")
EOS
done
