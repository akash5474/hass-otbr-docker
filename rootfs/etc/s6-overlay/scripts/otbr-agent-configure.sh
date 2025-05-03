#!/usr/bin/with-contenv bash
# ==============================================================================
# Configure OTBR depending on add-on settings
# ==============================================================================

# Check if NAT64 is set and not equal to "0"
if [ -n "$NAT64" ] && [ "$NAT64" != "0" ] ; then
    echo "INFO: Enabling NAT64."
    ot-ctl nat64 enable
    ot-ctl dns server upstream enable
fi

if [ -n "$THREAD_NET_PREFIX" ] && [ "$THREAD_NET_PREFIX" != "0" ] ; then
    echo "INFO: Setting Thread network ipv6 prefix to $THREAD_NET_PREFIX"
    ot-ctl prefix add $THREAD_NET_PREFIX paos
fi

# Check if SET_LEADER is set and not equal to "0"
if [ -n "$SET_LEADER" ] && [ "$SET_LEADER" != "0" ] ; then
    # Disable SRP Client
    ot-ctl srp client stop
    ot-ctl srp client autostart disable

    # Enable SRP Server
    ot-ctl srp server auto enable
    ot-ctl srp server enable

    # Check if LEADER_WEIGHT is set and not equal to "0"
    if [ -n "$LEADER_WEIGHT" ] && [ "$LEADER_WEIGHT" != "0" ] ; then
        echo "INFO: Setting leader weight to $LEADER_WEIGHT"
        ot-ctl leaderweight $LEADER_WEIGHT
    fi

    echo "INFO: Setting as Leader."
    ot-ctl state leader
fi

# To avoid asymmetric link quality the TX power from the controller should not
# exceed that of what other Thread routers devices typically use.
ot-ctl txpower 6
