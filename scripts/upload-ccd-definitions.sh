#!/bin/zsh

[ -f ~/.zshrc ] && source ~/.zshrc

cd "$DEFINITION_STORE_PATH" && yarn upload-wa
