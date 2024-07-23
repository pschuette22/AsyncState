#!/bin/bash

# Create the custom template directory for async state
if [[ -z ~/Library/Developer/Xcode/Templates/Async\ State ]]; then
  echo "Creating directory for custom Xcode templates"
  mkdir -p ~/Library/Developer/Xcode/Templates/Async\ State
else
  echo "Removing existing templates"
  rm -rf ~/Library/Developer/Xcode/Templates/Async\ State/**
fi

# Move the latest templates
echo "Copying latest templates"
cp -r xctemplates/* ~/Library/Developer/Xcode/Templates/Async\ State/
echo "done"
