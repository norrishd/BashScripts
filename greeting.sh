#!/bin/bash

NAME=$1

if ! [ -f "greeting.log" ]; then
  echo "Creating log file"
  touch greeting.log
fi

if [ "$NAME" == "log" ]; then
  cat greeting.log
elif [ "$NAME" == "Gandalf" ]; then
  GREETING="You're late, $NAME"
elif [ "$NAME" == "Frodo" ]; then
  GREETING="Hello there Mr. $NAME!"
elif [ "$NAME" == "Aragorn" ]; then
  GREETING="Greetings $NAME"
else
  GREETING="Well met, $NAME"
fi

echo $GREETING
echo $GREETING >> greeting.log

