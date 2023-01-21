#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

COUNT=0
#if there is no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #get all the elements 
  AVAILABLE_ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name FROM elements ORDER BY atomic_number")
  echo "$AVAILABLE_ELEMENTS" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
  do
    #check if the element is in the DB
    if [[ $1 == $ATOMIC_NUMBER || $1 == $SYMBOL || $1 == $NAME ]]
    then
      #if found
      #get the atomic number
      ATOMIC_NUMBER_FOUND=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER OR symbol = '$SYMBOL' OR name = '$NAME'")
      #output if element found
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER_FOUND")
      ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER_FOUND")
      ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER_FOUND")
      ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_TYPE_ID")
      ELEMENT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER_FOUND")
      ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER_FOUND")
      ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER_FOUND")

      #format the infos
      ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g')
      ELEMENT_NAME=$(echo $ELEMENT_NAME | sed -r 's/^ *| *$//g')
      ELEMENT_SYMBOL=$(echo $ELEMENT_SYMBOL | sed -r 's/^ *| *$//g')
      ELEMENT_TYPE=$(echo $ELEMENT_TYPE | sed -r 's/^ *| *$//g')
      ELEMENT_ATOMIC_MASS=$(echo $ELEMENT_ATOMIC_MASS | sed -r 's/^ *| *$//g')
      ELEMENT_MELTING_POINT=$(echo $ELEMENT_MELTING_POINT | sed -r 's/^ *| *$//g')
      ELEMENT_BOILING_POINT=$(echo $ELEMENT_BOILING_POINT | sed -r 's/^ *| *$//g')
      
      #print info about this element 
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
      break
    
    else 
      #if the element not found in the DB
      ((COUNT++))
      if [[ COUNT -eq 10 ]]
      then 
        echo "I could not find that element in the database."
      fi
    fi
    
  done
fi