#!/usr/bin/env bash

NH_FLAKE=$(mktemp -d)
git clone . "$NH_FLAKE" #TODO: replace . with valid bash for script dir.

cd "$NH_FLAKE" || exit
git lfs install
git lfs pull
rm -rf "$NH_FLAKE/.git"

nh os switch
