options=( "cli/cd_aliases" "cli/ls_aliases" "npm/install_aliases" "npm/update_aliases")
urls=( https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/cli/cd_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/cli/ls_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/npm/install_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/npm/update_aliases)
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
done

printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${urls[i]}"; msg=""; }
done

echo "$msg"
