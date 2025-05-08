#!/bin/bash
APPS=$(grep -hr ^Name= /usr/share/applications ~/.local/share/applications | sed 's/^Name=//' | sort -u)
SELECTION=$(echo -e "$APPS" | rofi -dmenu -p "App/Search:" -format 's' -i -theme "$HOME/.config/rofi/launchers/type-4/style-10.rasi")
EXIT_STATUS=$?
if [ $EXIT_STATUS -eq 0 ]; then
    if [[ "$SELECTION" =~ ^px\  ]]; then
        QUERY="${SELECTION#px }"
        echo "Searching Perplexity AI for: $QUERY"
        xdg-open "https://www.perplexity.ai/?q=$QUERY"
    else
        if echo "$APPS" | grep -qFx "$SELECTION"; then
            APP_FILE=$(grep -r "^Name=$SELECTION$" /usr/share/applications ~/.local/share/applications | head -n 1 | cut -d: -f1)
            if [ -n "$APP_FILE" ]; then
                EXEC_LINE=$(grep "^Exec=" "$APP_FILE" | head -n 1 | cut -d'=' -f2-)
                if [ -n "$EXEC_LINE" ]; then
                    EXEC_COMMAND=$(echo "$EXEC_LINE" | sed 's/%.*//g' | xargs)
                    echo "Launching: $EXEC_COMMAND"
                    eval "exec $EXEC_COMMAND"
                else
                    echo "Error: No Exec line found in $APP_FILE"
                    hyprctl notify -1 3000 "rgb(FFFFFF)" "Error: No Exec line found in $APP_FILE"
                fi
            else
                echo "Error: Could not find .desktop file for $SELECTION"
                hyprctl notify -1 3000 "rgb(FFFFFF)" "Error: Could not find .desktop file for $SELECTION"
            fi
        else
            xdg-open "https://www.google.com/search?q=$SELECTION"
        fi
    fi
elif [ $EXIT_STATUS -eq 1 ]; then
    echo "Rofi cancelled."
    hyprctl notify -1 3000 "rgb(FFFFFF)" "Rofi cancelled"
else
    echo "Rofi exited with status: $EXIT_STATUS"
    hyprctl notify -1 3000 "rgb(FFFFFF)" "Rofi exited with status: $EXIT_STATUS"
fi
