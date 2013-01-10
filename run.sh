#!/bin/bash


if [ -e configuration.rb ];
then
  echo "Configuration found, running notifier..."
  ruby notifier.rb
else
  echo "No configuration found! adjust & cp configuration.rb.example -> configuration.rb"
fi
