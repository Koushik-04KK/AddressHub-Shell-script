#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'

to_sentence_case() {
    echo "$1" | sed 's/\b\(.\)/\u\1/g'
}

read_with_timeout() {
    local prompt="$1"
    local timeout="$2"
    local var_name="$3"
    local timeout_flag=0
    local pid

    timeout_function() {
        sleep "$timeout"
        timeout_flag=1
    }

    timeout_function &
    pid=$!

    read -p "$prompt" "$var_name"

    if [ "$timeout_flag" -eq 0 ]; then
        if ps -p $pid > /dev/null; then
            kill $pid
        fi
    fi
}

validate_name() {
    while true; do
        read_with_timeout "$(echo -e "${CYAN}Enter Name (Alphabets and spaces only): ${NC}")" 10 name
        if echo "$name" | grep -Eq "^[a-zA-Z ]+$"; then
            name=$(to_sentence_case "$name")  
            break
        else
            echo -e "${RED}Invalid Name. Please enter only alphabets and spaces.${NC}"
        fi
    done
}

validate_email() {
    while true; do
        read_with_timeout "$(echo -e "${CYAN}Enter Email (valid format: example@domain.com): ${NC}")" 10 email
        if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            echo -e "${RED}Invalid Email. Please try again.${NC}"
        fi
    done
}

validate_tel() {
    while true; do
        read_with_timeout "$(echo -e "${CYAN}Enter Telephone Number (digits only): ${NC}")" 10 tel
        if echo "$tel" | grep -Eq "^[0-9]+$"; then
            break
        else
            echo -e "${RED}Invalid Telephone Number. Please enter only digits.${NC}"
        fi
    done
}

validate_mobile() {
    while true; do
        read_with_timeout "$(echo -e "${CYAN}Enter Mobile Number (10 digits, digits only): ${NC}")" 10 mobile
        if echo "$mobile" | grep -Eq "^[0-9]{10}$"; then
            break
        else
            echo -e "${RED}Invalid Mobile Number. Please enter a 10-digit number.${NC}"
        fi
    done
}

validate_place() {
    while true; do
        read_with_timeout "$(echo -e "${CYAN}Enter Place (Alphabets and spaces only): ${NC}")" 10 place
        if echo "$place" | grep -Eq "^[a-zA-Z ]+$"; then
            place=$(to_sentence_case "$place") 
            break
        else
            echo -e "${RED}Invalid Place. Please enter only alphabets and spaces.${NC}"
        fi
    done
}

add_entry() {
    echo -e "${GREEN}============================== Add Entry ==============================${NC}"
    validate_name
    validate_email
    validate_tel
    validate_mobile
    validate_place
    read_with_timeout "$(echo -e "${CYAN}Enter Message: ${NC}")" 10 message
    message=$(to_sentence_case "$message")  
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    entry="==========\n$name\n$email\n$tel\n+91$mobile\n$place\n$message\n$timestamp\n=========="
    echo -e "$entry" >> database.csv
    log "Added new entry for $name"
    echo -e "${GREEN}Entry added successfully!${NC}"
}

log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" >> database.log
}

check_data_file() {
    if [ ! -s database.csv ]; then
        echo -e "${YELLOW}No data found. Please add an entry first.${NC}"
        return 1
    fi
    return 0
}

search_entry() {
    if ! check_data_file; then
        return
    fi
    echo -e "${CYAN}Select the field to search by:${NC}"
    echo "1. Name"
    echo "2. Email"
    echo "3. Telephone"
    echo "4. Mobile"
    echo "5. Place"
    echo "6. Message"
    read_with_timeout "$(echo -e "${CYAN}Enter your choice (1-6): ${NC}")" 10 search_field
    case $search_field in
        1)
            read_with_timeout "$(echo -e "${CYAN}Enter the Name to search: ${NC}")" 10 search_value
            search_value=$(to_sentence_case "$search_value")
            ;;
        2)
            read_with_timeout "$(echo -e "${CYAN}Enter the Email to search: ${NC}")" 10 search_value
            ;;
        3)
            read_with_timeout "$(echo -e "${CYAN}Enter the Telephone Number to search: ${NC}")" 10 search_value
            ;;
        4)
            read_with_timeout "$(echo -e "${CYAN}Enter the Mobile Number to search: ${NC}")" 10 search_value
            ;;
        5)
            read_with_timeout "$(echo -e "${CYAN}Enter the Place to search: ${NC}")" 10 search_value
            search_value=$(to_sentence_case "$search_value")
            ;;
        6)
            read_with_timeout "$(echo -e "${CYAN}Enter the Message to search: ${NC}")" 10 search_value
            search_value=$(to_sentence_case "$search_value")
            ;;
        *)
            echo -e "${RED}Invalid choice! Please try again.${NC}"
            return
            ;;
    esac

    result=$(grep -i "$search_value" database.csv)
    if [ -z "$result" ]; then
        echo -e "${YELLOW}No matching entries found in AddressHub.${NC}"
    else
        echo -e "${GREEN}Found the following entry:${NC}"
        awk -v search="$search_value" 'BEGIN {RS="=========="} $0 ~ search {print "==========" "\n" $0 "\n=========="}' database.csv
    fi
}


edit_entry() {
    echo -e "${CYAN}Enter the Name or other detail to search the entry you want to edit:${NC}"
    read_with_timeout "$(echo -e "${CYAN}Enter search value: ${NC}")" 10 search_value
    search_value=$(to_sentence_case "$search_value")
    result=$(grep -i "$search_value" database.csv)
    
    if [ -z "$result" ]; then
        echo -e "${YELLOW}No matching entry found for '$search_value'. Cannot edit.${NC}"
        return
    fi

    echo -e "${GREEN}Found the following entry for editing:${NC}"
    awk -v search="$search_value" 'BEGIN {RS="=========="; ORS="==========\n"} $0 ~ search {print $0}' database.csv

    echo -e "${CYAN}Which field would you like to edit?${NC}"
    echo "1. Name"
    echo "2. Email"
    echo "3. Telephone"
    echo "4. Mobile"
    echo "5. Place"
    echo "6. Message"
    echo "7. Cancel"
    read_with_timeout "$(echo -e "${CYAN}Enter your choice (1-7): ${NC}")" 10 choice
    
    case $choice in
        1)
            validate_name
            ;;
        2)
            validate_email
            ;;
        3)
            validate_tel
            ;;
        4)
            validate_mobile
            ;;
        5)
            validate_place
            ;;
        6)
            read_with_timeout "$(echo -e "${CYAN}Enter new Message: ${NC}")" 10 new_message
            new_message=$(to_sentence_case "$new_message")
            ;;
        7)
            echo -e "${YELLOW}Canceling edit operation.${NC}"
            return
            ;;
        *)
            echo -e "${RED}Invalid option. No changes made.${NC}"
            return
            ;;
    esac

    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    awk -v search="$search_value" -v new_name="$name" -v new_email="$email" -v new_tel="$tel" -v new_mobile="$mobile" -v new_place="$place" -v new_message="$new_message" -v new_timestamp="$timestamp" '
    BEGIN {RS="=========="; ORS="==========\n"}
    $0 ~ search {
        if (new_name) $1 = new_name
        if (new_email) $2 = new_email
        if (new_tel) $3 = new_tel
        if (new_mobile) $4 = "+91" new_mobile
        if (new_place) $5 = new_place
        if (new_message) $6 = new_message
        $7 = new_timestamp
    }
    {print $1 "\n" $2 "\n" $3 "\n" $4 "\n" $5 "\n" ($6 ? $6 : $6) "\n" $7 "\n=========="}' database.csv > temp.csv && mv temp.csv database.csv

    log "Updated entry for $name"
    echo -e "${GREEN}Entry updated successfully!${NC}"
}

menu() {
    while true; do
        echo -e "${BLUE}============================== Main Menu ==============================${NC}"
        echo "1. Add Entry"
        echo "2. Search Entry"
        echo "3. Edit Entry"
        echo "4. Exit"
        read_with_timeout "$(echo -e "${CYAN}Enter your choice (1-4): ${NC}")" 10 choice
        
        case $choice in
            1) add_entry ;;
            2) search_entry ;;
            3) edit_entry ;;
            4) exit 0 ;;
            *)
                echo -e "${RED}Invalid choice! Please try again.${NC}"
                ;;
        esac
    done
}
echo -e "${GREEN}==============================================================="
echo "        Welcome to AddressHub: Your Connected World"
echo "===============================================================${NC}"
menu
