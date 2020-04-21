#!/bin/bash

# customize with your own.
options=("AAA" "BBB" "CCC" "DDD" "EEE")

# define functions install / uninstall

install() {
    echo "$1" >> $saveFile
    echo "$1 installed"
}

uninstall() {
    cat ~/.cli_aliases | sed "s|^$1\$||g" | sed '/^$/d' > $saveFile
    echo "$1 uninstalled"
}


#change to home directory
cd ~

saveFile=".cli_aliases"

# create file if not exists
test -f $saveFile || touch $saveFile

# Read save file

for i in ${!options[@]}; do
    if grep -q "${options[i]}" "$saveFile"; then
        choices[i]="+"
    fi
done

menu() {
    echo "Avaliable options:"
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    if [[ "$msg" ]]; then echo "$msg"; fi
}

prompt="Check an option (again to uncheck, ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { msg="Invalid option: $num"; continue; }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
    [[ "${choices[num]}" ]] && install ${options[num]} || uninstall ${options[num]}
done

printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
done

echo "$msg"
options=()
choices=()



