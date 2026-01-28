#!/bin/sh
set -e
#==================================================================================================
#
#   Copyright (C) 2015-2020 Sky kit authors. <http://omega.gg/Sky>
#
#   Author: Benjamin Arnaud. <http://bunjee.me> <bunjee@omega.gg>
#
#   This file is part of the Sky hypergonar project.
#
#   - Private License Usage:
#   Sky professional licensees holding valid private licenses may use this file in accordance with
#   the private license agreement provided with the Software or, alternatively, in accordance with
#   the terms contained in written agreement between you and Sky professional authors. For further
#   information contact us at contact@omega.gg.
#
#==================================================================================================

#--------------------------------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------------------------------

check()
{
    if ! command -v "$1" >/dev/null 2>&1; then

        echo "build: '$1' is required but not found in PATH."

        exit 1
    fi
}

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 1 ] || [ "$1" != "default" ]; then

    echo "Usage: build <default>"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Install
#--------------------------------------------------------------------------------------------------

sudo apt-get update

sudo apt-get remove --purge -y nodejs npm libnode-dev node-cacache node-gyp || true
sudo apt-get autoremove -y
sudo apt-get clean

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

sudo apt-get install -y git python3 python3-pip python3-venv nodejs

if ! command -v rustup >/dev/null 2>&1; then

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

. "$HOME/.cargo/env"

rustup target add wasm32-unknown-unknown

#--------------------------------------------------------------------------------------------------
# Install
#--------------------------------------------------------------------------------------------------

git config --global --add safe.directory "*"

python3 -m pip install --upgrade pip

python3 -m pip install mkdocs mkdocs-material

if [ -f "package-lock.json" ]; then

    npm ci
else
    npm install
fi

npm run build

npm run assets:download

npm run site:build
