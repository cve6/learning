#!/bin/bash
#https://github.com/cve6/learning/blob/main/dys.sh
clear
# ---------- COLORS --------- #
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
blue='\e[34m'
purple='\e[35m'
cyan='\e[36m'
reset='\e[0m'
bold='\e[1m'
subl='\e[4m'

# ---------- VERIFICATIONS --------- #
#is root?
if [[ $EUID -ne 0 ]]; then
echo -e "\n\n\t\t ${red}[ ✖ ] Need root. \n\n${reset}"
exit 0
fi

#who?
echo -e "\n\n"
read -p "        ✚ Your interface: " interface
if ! ip link show "$interface" > /dev/null 2>&1; then
echo -e "${green}${bold}\t✚ Hey! Listen:${reset} ${bold}ip link show${reset} | ${bold}ip a${reset} | ${bold}ifconfig${reset} | ${bold}iwconfig${reset}\n\n"
exit 0
fi

# ---------- FUNCTIONS --------- #
clear
#here are the builds
menu_buildrules(){
    while true; do
    clear
    echo -e "\n\n${cyan}
\t▛▀▖▌ ▌▜▘▌  ▛▀▖▞▀▖
\t▙▄▘▌ ▌▐ ▌  ▌ ▌▚▄ 
\t▌ ▌▌ ▌▐ ▌  ▌ ▌▖ ▌
\t▀▀ ▝▀ ▀▘▀▀▘▀▀ ▝▀ ${reset}\n\n"
    echo -e "\t${bold}⮞ ${subl}Analist Ghost${reset} (1)
    \t${bold}⮞ ${subl}Return${reset} (2)\n\n"
    read -p "   ＊  Choose a build: " opt2
    case "$opt2" in

#applying rules for a new especific chain
    1)
    clear
    iptables -N dys_"$interface"
    iptables -A INPUT -i "$interface" -j dys_"$interface" 
    iptables -A dys_"$interface" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A dys_"$interface" -p tcp --dport 2222 -j ACCEPT #dont use default ssh port, adjust
    iptables -A dys_"$interface" -j DROP
    clear
    echo -e "\n\n\t ${green}[ ✔ ] Rules applied, use Actual Rules in the main menu to see them.${reset}"
    sleep 0.9
    read -p "         [ ☁ ] Press Enter..."
    ;;
#just return
    2)
    clear
    return
    ;;
#what you doin???
    *)
    echo -e "${red}[ ✘ ] Invalid Option. ${reset}"
    ;;
    esac
done
}

#main menu
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
    read -p "     ⛰  Option: " opt1

case "$opt1" in
1)
menu_buildrules
;;

2)
clear
iptables -L -n -v
echo -e "\n\t\t${blue}⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻${reset}\n"
iptables -L -n --line-numbers
echo -e "\n\n"
read -p "         [ ☁ ] Press Enter..."
clear
;;

3)
clear
iptables -L -n -v
echo -e "\n\t\t${blue}⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻${reset}\n"
iptables -L -n --line-numbers
echo -e "\n\n"
read -p "    Chain name: " chain
read -p "    INPUT rule number: " number
read -p "    Are you sure? (y/n)" sure
if [[ "$sure" == 'y' ]]; then
iptables -F "$chain"
iptables -D INPUT "$number"
iptables -X "$chain"
clear
echo -e "\n\n\t\t[ ✚ ] ${green}Rules have been cleared.${reset}\n"
echo -e "\t\t[ ☹ ] ${yellow}WARN${reset}: You're ${red}insecure${reset}!\n"
else
clear
fi
;;
4)
iptables-save -f /etc/iptables/iptables.rules
echo -e "\n\n\t ${green}[ ✚ ] Rules saved. ${reset}"
sleep 0.5
read -p "         [ ☁ ] waiting enter..."
clear
;;
5)
clear
exit 0
;;
*)
clear
echo -e "\n\n\t\t ${red} [ ✘ ] Invalid Option. ${reset}"
;;
esac
done
}

# ---------- CALLING FUNCTIONS --------- #
menu
