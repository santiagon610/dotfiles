#!/usr/bin/env bash

# -------------------
# Weather via wttr.in
# -------------------
#
# If you leave WX_LOCATION blank, wttr.in will use Geolocate your IP address to
# obtain weather data. If you add WX_LOCATION in URL-encoded format, that location
# will be the one used, e.g. "Philadelphia,%20PA"
WX_LOCATION=""

WX_SERVER="https://wttr.in"
WX_TIMEOUT_CMD="timeout 4"
WX_COMMAND="${WX_TIMEOUT_CMD} curl -sk -H \"Accept-Language: en\" ${WX_SERVER}/${WX_LOCATION}"
alias wxcurrent="echo \"Current conditions in \" && ${WX_COMMAND}\?0qF"
alias wx="${WX_COMMAND}\?1nqF"
