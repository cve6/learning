#!/bin/bash
#######---- colors
reset='\e[0m'
sublin='\e[4m'
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
    echo -e "\n\n\t${hardyellow}Recommended format: ${sublin}vulnweb.com${reset}"
    read -p "        ✱ Website Adress: " website
    clear
    echo -e "\n\n\t ${greenlight}${sublin}✸ WhoIs RESULTS | "$website" ✸${reset}\n\n"
    whois "$website" | grep -E "Creation Date|Registrant|Name Server|Expir|Name|Phone|Email|ID|e-mail|status|person|owner|responsible|owner-id|domain|inetnum|netname|country|descr|org-name|address|abuse-mailbox|route|CIDR|netmask|Privacy"
    echo -e "\n\n\t ${greenlight}${sublin}✸ nslookup RESULTS | "$website" ✸${reset}\n\n"
    nslookup "$website" | grep -E "Server|Address|Name|Non"
    echo -e "\n\n\t ${greenlight}${sublin}✸ host RESULTS | "$website" ✸${reset}\n\n"
    host "$website" && host -v "$website" | grep "from"
    echo -e "\n\n\t ${greenlight}${sublin}✸ dig RESULTS | "$website" ✸${reset}\n\n"
    dig "$website" A +noall +answer && dig "$website" NS +noall +answer && dig "$website" MX +noall +answer && dig "$website" TXT +noall +answer && dig "$website" SOA +noall +answer && dig "www.$website" CNAME +noall +answer && dig "$website" ANY +noall +answer
    echo -e "\n\n\t ${greenlight}${sublin}✸ cURL RESULTS | "$website" ✸${reset}\n\n"
    curl -s "https://crt.sh/?q="$website"&output=json" | jq -r '.[] | .name_value' | sort -u
    curl -s "https://crt.sh/?q=%25.$website&output=json" | grep -Po '"name_value":"[^"]*"' | sed 's/"name_value":"//;s/"//g' | sort -u
    curl -s "https://ipinfo.io/$IP/json" | jq -r '.org, .country, .city'
    curl -s "https://api.hackertarget.com/whois/?q=$website"
    curl -s "https://ct-search-api.cloudflare.com/api/v1/domains/$website" | jq -r '.results[].name' | sort -u
    echo -e "\n\n\t ${greenlight}${sublin}✸ assetfinder RESULTS | "$website" ✸${reset}\n\n"
    assetfinder -subs-only "$website"
    echo -e "\n"
    read -p "         ❯ Press Enter..."
}

##-- active recon (i will do)
#active(){

#}


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
\t\t   █▐      ⛧   by cve6            █  
\t\t   ▐                              ▀\n\n${reset}"
echo -e "\t\t ${red}❥${reset} ${white}1. Passive Recon${reset}"
echo -e "\t\t ${red}❥${reset} ${white}2. Active Recon${reset}"
echo -e "\t\t ${red}❥${reset} ${white}3. Fingerprint${reset}"
echo -e "\t\t ${red}❥${reset} ${white}4. Exit\n${reset}\n"
read -p "  ⮚ Your choose: " opt
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
echo -e "${red}\t\t\t[ ✖ ] Really?!${reset}"
sleep 2
;;
esac
done
}
#call the main function
main
