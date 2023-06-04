#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~Salon Appointment Scheduler~~~"

MAIN_MENU(){
if [[ $1 ]]
  then
    echo -e "\n$1"
fi

echo -e "\nWelcome! Please, choose a service:\n"
SERVICES_AVAILABLE=$($PSQL "SELECT service_id, name FROM services")
echo "$SERVICES_AVAILABLE" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done

read SERVICE_ID_SELECTED

#check if service selected is available
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED");

if [[ -z $SERVICE_NAME ]]
then
MAIN_MENU "That service doesn't exist. What service would you like today?"
else

#enter phone number
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE

#check if phone number exists
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  #get new customer name
  echo -e "\nWhat is your name?"
  read CUSTOMER_NAME

  #insert new customer
  INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

#enter appointment time
echo -e "\nWhat is your preferred appointment time?"
read SERVICE_TIME

#get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

#insert appointment info
INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi
}

MAIN_MENU
