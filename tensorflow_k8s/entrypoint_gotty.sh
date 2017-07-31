#!/bin/bash

set -x

/usr/bin/gotty --permit-write --credential $GOTTY_USER:$GOTTY_PASS --reconnect /bin/bash
