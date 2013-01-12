#!/bin/bash

echo "--- `date`" | tee -a log

if [ -e src/configuration.rb ];
then
  echo "Configuration found, running notifier..." | tee -a log
  ruby src/notifier.rb 2>&1 | tee -a log
else
  echo "No configuration found! adjust & cp src/configuration.rb.example -> src/configuration.rb" | tee -a log
fi
