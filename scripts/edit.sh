#!/bin/bash
exec emacsclient --alternate-editor="" --create-frame "$@"
# since the string for alternate editor is empty, emacsclient starts Emacs in daemon mode and then tries connecting again.
