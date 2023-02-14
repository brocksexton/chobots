#!/bin/bash

cd /var/www/html/
if [ ! -f maintenance.html.disabled ]; then
  ln -s maintenance.html.disabled maintenance.html
fi
