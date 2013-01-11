#!/bin/bash

date >> log

if [ -e src/configuration.rb ];
then
  echo "Configuration found, running notifier..."
  ruby src/notifier.rb | tee -a log
else
  echo "No configuration found! adjust & cp src/configuration.rb.example -> src/configuration.rb"
fi
