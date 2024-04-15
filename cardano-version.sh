#!/bin/bash
#

GIT_REPO="https://api.github.com/repositories/188299874/releases/latest"
CARDANO_NODE=$(cardano-node version)
CURRENT_VERSION=$(echo $CARDANO_NODE | grep -o "cardano-node [0-9.]*" | awk '{print $2}')
LAST_VERSION=$(curl -s $GIT_REPO | jq -r .tag_name)


if [ $CURRENT_VERSION = $LAST_VERSION ] ; then
    IFS='.'
    read -r CURRENT_MAJ CURRENT_MID CURRENT_LOW <<< "$CURRENT_VERSION"
    read -r LAST_MAJ LAST_MID LAST_LOW <<< "$LAST_VERSION"
    LATEST=1
    printf 'Latest %s\ncardano_current_maj %s\ncardano_current_mid %s\ncardano_current_low %s\n' $LATEST $CURRENT_MAJ $CURRENT_MID $CURRENT_LOW > /var/lib/prometheus/node-exporter/currentnodeversion.prom
    printf 'cardano_lattest_maj %s\ncardano_lattest_mid %s\ncardano_lattest_low %s\n' $LAST_MAJ $LAST_MID $LAST_LOW > /var/lib/prometheus/node-exporter/lattestnodeversion.prom
else 
    IFS='.'
    read -r CURRENT_MAJ CURRENT_MID CURRENT_LOW <<< "$CURRENT_VERSION"
    read -r LAST_MAJ LAST_MID LAST_LOW <<< "$LAST_VERSION"
    LATEST=0
    printf 'Latest %s\ncardano_current_maj %s\ncardano_current_mid %s\ncardano_current_low %s\n' $LATEST $CURRENT_MAJ $CURRENT_MID $CURRENT_LOW > /var/lib/prometheus/node-exporter/currentnodeversion.prom
    printf 'cardano_lattest_maj %s\ncardano_lattest_mid %s\ncardano_lattest_low %s\n' $LAST_MAJ $LAST_MID $LAST_LOW > /var/lib/prometheus/node-exporter/lattestnodeversion.prom
fi
