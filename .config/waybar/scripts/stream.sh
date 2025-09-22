#!/bin/bash

status=$(/usr/bin/obs-cmd streaming status 2>/dev/null)

if echo "$status" | grep -q "Streaming status: true"; then
    echo '{"text":"󰑊"}'
else
    echo '{"text":""}'
fi
