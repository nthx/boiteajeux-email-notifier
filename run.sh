#!/bin/bash


if [ -e src/configuration.rb ];
then
  echo "Configuration found, running notifier..."
  ruby src/notifier.rb
else
  echo "No configuration found! adjust & cp src/configuration.rb.example -> src/configuration.rb"
fi
