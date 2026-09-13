#!/bin/bash
clear #i dont like visual trash
##### colors
black='\e[30m'
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
purple='\e[35m'
cyan='\e[36m'
reset='\e[0m'
bold='\e[1m'

##### is root?
if [[ $EUID -ne 0 ]]; then
echo -e "\n\n\t\t ${red}[ ✖ ] Need root. \n\n${reset}"
exit 0
fi


##### who?
echo -e "\n\n"
read -p "        ✚ Your interface: " interface
if ! ip link show "$interface" > /dev/null 2>&1; then
echo -e "${green}${bold}\t✚ Hey! Listen:${reset} ${bold}ip link show${reset} | ${bold}ip a${reset} | ${bold}ifconfig${reset} | ${bold}iwconfig${reset}\n\n"
exit 0
fi

clear #ye, i really dont like visual trash
##### functions
menu_buildrules(){
    while true; do
    clear
    echo -e "\n\t\t# ===\* BUILDS \*=== #\n\n"
    echo -e "\t1. Analist Ghost"
    echo -e "\t2. Return\n\n"
    read -p "+------- Choose a build: " opt2
    case "$opt2" in

#applying rules
    1)
    clear
    sudo iptables -A INPUT -i "$interface" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -i "$interface" -p tcp --dport 22 -j ACCEPT *#dont use default ssh port, adjust*
    sudo iptables -A INPUT -i "$interface" -j DROP
    clear
    echo -e "\t${green}\t\n [ + ] - Rules applied, use Actual Rules in the main menu to see them.\n${reset}"
    read -p "[ \</> ] - waiting enter..."
    ;;
#just return

    2)
    clear
    return
    ;;

#what you doin???
    *)
    echo -e "${red}[ - ] - Invalid Option. ${reset}"
    ;;
    esac
done
}

##### main menu
menu(){
    while true; do
    echo -e "\n\n\t${cyan}
\t████▄  ██  ██ ▄█████ 
\t██  ██  ▀██▀  ▀▀▀▄▄▄ 
\t████▀    ██   █████▀${reset}
\t ${bold}✤ Defend yourself.${reset}\n\n"
    echo -e "\t1 ➜ Build Rules"
    echo -e "\t2 ➜ Actual Rules"
    echo -e "\t3 ➜ Reset Rules"
    echo -e "\t4 ➜ Save Rules"
    echo -e "\t5 ➜ Exit\n\n"
    read -p "#----- Option: " opt1

case "$opt1" in
1)
menu_buildrules
;;

2)
clear
echo -e "\n\n"
sudo iptables -L -n -v
echo -e "\n"
;;

3)
read -p "Are you sure? This option will reset the rules in ALL interfaces. (0/1)" sure
if [[ "$sure" -eq 0 ]]; then
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo iptables -X
clear
echo -e "\n\t\t[ + ] - ${green}ALL Rules have been cleared ON ALL INTERFACES.${reset}\n"
echo -e "\t\t[ ! ] - ${yellow}WARN${reset}: You're ${red}insecure${reset}!\n"
else
clear
fi
;;

4)
sudo iptables-save -f /etc/iptables/iptables.rules
echo -e "\t\t\n${green}[ + ] - Rules saved.${reset}\n"
read -p "[ \</> ] waiting enter..."
clear
;;

5)
clear
exit 0
;;

*)
clear
echo -e "${red}\n\n\t[ - ] - Invalid Option.\n${reset}"
;;
esac
done
}

menu