#! /usr/bin/sh

# Lifted from
# https://bbs.archlinux.org/viewtopic.php?pid=1625398#p1625398

# Fix instant wake from suspend problem on Thinkpad X1 Extreme.
# Add your candidates below but make sure that no pattern matches
# more than one device in /proc/acpi/wakeup
# 
# Thinkpad X1 Extreme
CANDIDATES="XHC"

for ACPIDEV in $CANDIDATES; do
ACTIVE=$(grep enabled /proc/acpi/wakeup | cut -f 1 | grep "$ACPIDEV")
    if [ -n "$ACTIVE" ]; then 
        echo "$ACTIVE" > /proc/acpi/wakeup
        echo "DEBUG: disabled -$ACTIVE-" >&2
    else
        echo "DEBUG: no active -$ACPIDEV- found." >&2
    fi
done
