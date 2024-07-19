#!/bin/bash

# Create the custom template directory for async state
if [[ -z ~/Library/Developer/Xcode/Templates/Async\ State ]]; then
  mkdir -p ~/Library/Developer/Xcode/Templates/Async\ State
else
  rm -rf ~/Library/Developer/Xcode/Templates/Async\ State/**
fi

# Move the latest templates
cp -r xctemplates/* ~/Library/Developer/Xcode/Templates/Async\ State/