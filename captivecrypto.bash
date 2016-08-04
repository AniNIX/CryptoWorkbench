#!/bin/bash

if [ $(pgrep -afc cryptoworkbench.exe) -gt 10 ]; then
    echo All slots used -- you\'ll have to wait.
    sleep 5
    exit;
fi

exec bash -c "time mono /opt/cryptoworkbench.exe --blind; read"
