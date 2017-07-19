#!/bin/sh

## Configure git
git config --global user.name ptgreiner
git config --global user.email pgreiner@uoregon.edu

## Change the "origin" remote URL and push
git remote set-url origin https://github.com/ptgreiner/handouts.git

## Set the SESYNC-CI repository upstream and pull updates
git remote add upstream https://github.com/sesync-ci/handouts.git
git pull upstream master
