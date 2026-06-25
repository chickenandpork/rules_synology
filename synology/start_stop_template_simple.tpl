#!/bin/sh
# This is rules_synology/synology/start_stop_template_simple.tpl

case "$1" in
    start)
        COMPOSE_UP
        ;;
    stop)
        COMPOSE_DOWN
        ;;
    status)
        COMPOSE_STATUS
        ;;
esac

exit 0
