#!/bin/bash

echo "Daemon installieren <1>" 
echo "Daemon starten <2>" 
read -p "Auswahl: " -n1 opt

if [ "$opt" = "1" ]; then
    cp ProcChecker.rb /usr/bin/ProcChecker
    chmod a+x /usr/bin/ProcChecker
    apt-get install ruby1.8 -yf
fi

if [ "$opt" = "2" ]; then
    ProcChecker > /dev/null&
fi
