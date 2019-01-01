#!/bin/bash

MEPATH=$(dirname "${BASH_SOURCE[0]}")
[ -e "${MEPATH}/creds" ] && source "${MEPATH}/creds"

export ENVIRONMENT="hostdb-datastore"
