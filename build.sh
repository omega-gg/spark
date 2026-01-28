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
# Settings
#--------------------------------------------------------------------------------------------------

bin="$SKY_PATH_BIN"

name="spark"

repository="https://github.com/sparkjsdev/spark.git"

version="v0.1.10"

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
# Environment
#--------------------------------------------------------------------------------------------------

sudo apt-get update

sudo apt-get install -y git python3 python3-pip python3-venv nodejs npm rustc cargo

check git
check python3
check node
check npm
check rustc
check cargo

#--------------------------------------------------------------------------------------------------
# Clean
#--------------------------------------------------------------------------------------------------

cd "$bin"

rm -rf "$name"

#--------------------------------------------------------------------------------------------------
# Clone
#--------------------------------------------------------------------------------------------------

git clone --depth=1 --branch "$version" "$repository"

cd "$name"

#--------------------------------------------------------------------------------------------------
# Install
#--------------------------------------------------------------------------------------------------

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
