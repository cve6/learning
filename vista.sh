#!/bin/bash
#######---- colors
reset='\e[0m'
red='\e[31m'
redlight='\e[1;31m'
greenlight='\e[1;32m'
yellow='\e[33m'
hardyellow='\e[1;33m'
dpink='\e[35m'
pink='\e[95m'
white='\e[1;37m'


#######---- functions
##-- passive recon
passive(){
    clear
    echo -e "\n\n\t${hardyellow}Recommended format: vulnweb.com${reset}"
    read -p "        ✱ Website Adress: " website
    clear
    echo -e "\n\n\t ${greenlight}✸ WHOIS RESULTS | "$website" ✸${reset}\n\n"
    whois "$website" | grep -E "Creation Date|Registrant|Name Server|Expir|Name|Phone|Email|ID"
    echo -e "\n\n\t ${greenlight}✸ DIG RESULTS | "$website" ✸${reset}\n\n"
    dig "$website" A +noall +answer && dig "$website" NS +noall +answer && dig MX +noall +answer
    echo -e "\n\n\t ${greenlight}✸ cURL RESULTS | "$website" ✸${reset}\n\n"
    curl -s "https://crt.sh/?q="$website"&output=json" | jq -r '.[] | .name_value' | sort -u
    read -p "❯ Press Enter..."
}

##-- active recon (i will do)

#main (bruh)
main(){
while true; do
clear
echo -e "\n\n                          ${yellow}☻${reset}${pink}
\t\t     ▄   ▄█   ▄▄▄▄▄     ▄▄▄▄▄▀ ██   
\t\t     █  ██   █     ▀▄ ▀▀▀ █    █ █  
\t\t█     █ ██ ▄  ▀▀▀▀▄       █    █▄▄█ 
\t\t █    █ ▐█  ▀▄▄▄▄▀       █     █  █ 
\t\t  █  █   ▐              ▄▀         █ 
\t\t   █▐           by cve6            █  
\t\t   ▐                              ▀\n\n${reset}"
echo -e "\t\t ${red}❥${reset} ${white}1. Passive Recon${reset}"
echo -e "\t\t ${red}❥${reset} ${white}2. Active Recon${reset}"
echo -e "\t\t ${red}❥${reset} ${white}3. Fingerprint${reset}"
echo -e "\t\t ${red}❥${reset} ${white}4. Exit\n${reset}\n"
read -p "   ⮚ Your choose: " opt
case "$opt" in
1)
passive
;;
2)
;;
3)
;;
4)
clear
exit 0
;;
*)
echo -e "${red}\t\t\t[ ✖ ] Really?${reset}"
sleep 2
;;
esac
done
}


#call the main function
main