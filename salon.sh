#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"





MAIN_MENU() {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "1) cut \n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  if [[ $SERVICE_ID_SELECTED > 0  && $SERVICE_ID_SELECTED < 6 ]]
  then
    CUT_MENU
  else
    MAIN_MENU "I could not find that service. What would you like today?"
  fi

  # case $SERVICE_ID_SELECTED in
  #   1) CUT_MENU ;;
  #   *) MAIN_MENU "I could not find that service. What would you like today?"
  # esac
}

CUT_MENU() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  #check for customer with phone
  CHECK_CUSTOMER_PHONE=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")

  #if not exists
  if [[ -z $CHECK_CUSTOMER_PHONE ]]
  then
    echo -e "\nI dont't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    #Insert customer info
    INSERT_NAME_NUMBER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  fi
  
  GET_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
  GET_SERVICE=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your $GET_SERVICE,$GET_NAME?"
  read SERVICE_TIME

  GET_CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

  SET_TIME=$($PSQL "insert into appointments(customer_id, service_id, time) values($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

  echo -e "\nI have put you down for a cut at $SERVICE_TIME,$GET_NAME."

}

MAIN_MENU