#!/bin/bash

# no need to get notifications about gh CLI updates available
GH_NO_UPDATE_NOTIFIER=0

alias gpf="git push --force-with-lease"

alias gh-pr="gh pr create --fill"
alias gh-pr-yolo="gh pr create --fill --label \"s: skip review 🚀️\""
