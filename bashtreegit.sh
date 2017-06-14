#!/bin/bash

# Pointless bash script which makes a git repo, adds a file and commits it 
# Next dumps all the tree files into the one directory, then figures out how to restore them to their correct locations

REPO=repo

# remove the repo directory if it exists
if [ -d "$REPO" ]; then
  if [ -L "$REPO" ]; then
    rm "$REPO"
  else
    rm -rf "$REPO"
  fi
fi

# make a new repo directory

mkdir "$REPO"

# set a new repo directory

cd "$REPO"
git init .
# make a new file
echo -n "Hello World, at " > hello.txt	
echo $(date) >> hello.txt	
# appends current date to end of file
git add hello.txt
git commit -m "added hello.txt"

# move files in the git metadata which wrecks the repo
# Puts all the commit references/tre object files thingies into the upper level objects folder
mv .git/objects/*/* .git/objects/

# Can navigate to /.git/refs/heads and cat master to see the latest commit and its containing folder
# get file name without newline
MASTER=$(cut -f1 .git/refs/heads/master)

# echo $MASTER | cut -c3- -	# get everything from the 3rd character
# echo $MASTER | cut -c1-2 -	# get 1st 2 characters

# Move first file back to correct place
mv .git/objects/$(echo $MASTER | cut -c3- -) .git/objects/$(echo $MASTER | cut -c1-2 -)

# Now 1st one is moved back, have a vector to get the second one, because within commit is the hash value for tree of the commit

# find out previous tree reference
git cat-file -p $MASTER
# see output "tree <blahblahb hash string>
# grab the hash value by getting file list, piping that to grep and looking for the "tree" entry, piping that to cut at the space and grabbing 2nd part

TREE=$(git cat-file -p $MASTER | grep tree | cut -d' ' -f2 -)
mv .git/objects/$(echo $TREE | cut -c3- -) .git/objects/$(echo $TREE | cut -c1-2 -)

# check out file structure thingy and get 100644 blob <hashstringwewant> hello.txt
git cat-file -p $TREE

HELLOFILE=$(git cat-file -p $TREE | grep hello.txt | cut -d' ' -f3 - | cut -f1 -)
mv .git/objects/$(echo $HELLOFILE | cut -c3- -) .git/objects/$(echo $HELLOFILE | cut -c1-2 -)



