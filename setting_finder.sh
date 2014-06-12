#!/bin/sh

defaults read 1> _settings_before.txt
read -n 1 -s
defaults read 1> _settings_after.txt
diff -u _settings_before.txt _settings_after.txt
rm _settings_before.txt _settings_after.txt