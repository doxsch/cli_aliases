options=( "cli/cd_aliases" "cli/ls_aliases" "kubectl/kubectl_aliases" "npm/install_aliases" "npm/update_aliases")
urls=( https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/cli/cd_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/cli/ls_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/kubectl/kubectl_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/npm/install_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/npm/update_aliases)
#!/bin/bash

# customize with your own.
# options=( "cli/cd_aliases" "cli/ls_aliases" "npm/install_aliases" "npm/update_aliases")
# urls=( https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/cli/cd_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/cli/ls_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/npm/install_aliases https://raw.githubusercontent.com/doxsch/cli_aliases/master/dist/bash/npm/update_aliases)


# define functions install / uninstall


install() {
    # $1 option $2 url
    echo "source <(curl -s -H 'Cache-Control: no-cache' $2)" >> $profileFile 
    echo ""
    echo ""
    echo ""
    echo "------------------------------"
    echo "$1 installed"
    echo "------------------------------"
    echo ""
}

uninstall() {
    # $1 option $2 url
    encodedUrl=$(echo "$2"|sed "s|\.|\\\.|g")
    cat $profileFile | sed "s|^source <(curl -s -H 'Cache-Control: no-cache' $encodedUrl)\$||g" | sed '/^$/d' > $profileFile 

    # unaliasUrl=$(echo $2 | sed "s|aliases$|unaliases|g")
    # echo "source <(curl -s -H 'Cache-Control: no-cache' $unaliasUrl)" >> $uninstallFile

    echo ""
    echo ""
    echo ""
    echo "------------------------------"
    echo "$1 uninstalled"
    echo "------------------------------"
    echo ""
}


echo "       _  _             _  _                _____              _          _  _                       ___     ___     _ "
echo "  ___ | |(_)      __ _ | |(_)  __ _  ___    \_   \ _ __   ___ | |_  __ _ | || |  ___  _ __  __   __ / _ \   / _ \   / |"
echo " / __|| || |     / _\` || || | / _\` |/ __|    / /\/| '_ \ / __|| __|/ _\` || || | / _ \| '__| \ \ / /| | | | | | | |  | |"
echo "| (__ | || |    | (_| || || || (_| |\__ \ /\/ /_  | | | |\__ \| |_| (_| || || ||  __/| |     \ V / | |_| |_| |_| |_ | |"
echo " \___||_||_|_____\__,_||_||_| \__,_||___/ \____/  |_| |_||___/ \__|\__,_||_||_| \___||_|      \_/   \___/(_)\___/(_)|_|"
echo "           |_____|                                                                                                     "


#change to home directory
cd ~

profileFile=".bash_profile"
uninstallFile=".cli_alias_to_uninstall"

# create file if not exists
test -f $profileFile || touch $profileFile
test -f $uninstallFile || touch $uninstallFile

# Read save file

for i in ${!options[@]}; do
    if grep -q "${urls[i]}" "$profileFile"; then
        choices[i]="+"
    fi
done

menu() {
    echo ""
    echo "----------------------"
    echo "| Avaliable aliases: |"
    echo "----------------------"
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    # if [[ "$msg" ]]; then echo "$msg"; fi
}
echo "---------------------------------------------------------------"
echo " # ) = not installed" 
echo " #+) = already installed"
echo "---------------------------------------------------------------"
prompt="Select number to install this alias[es] (again to uninstall, Hit ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { msg="Invalid option: $num"; continue; }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
    [[ "${choices[num]}" ]] && install ${options[num]} ${urls[num]} || uninstall ${options[num]} ${urls[num]}
done

printf "Exit Installer. Please run 'unalias -a && source ~/.bash_profile' to apply install/uninstall";

options=()
choices=()


