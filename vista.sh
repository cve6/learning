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
    curl -s "https://crt.sh/?q=%25."$website"&output=json" | grep -Po '"name_value":"[^"]*"' | sed 's/"name_value":"//;s/"//g' | sort -u
    curl -s "https://ipinfo.io/"$website"/json" | jq -r '.org, .country, .city'
    curl -s "https://api.hackertarget.com/whois/?q="$website""
    echo -e "\n\n\t ${greenlight}${sublin}✸ assetfinder RESULTS | "$website" ✸${reset}\n\n"
    assetfinder -subs-only "$website"
    echo -e "\n\n\t ${greenlight}${sublin}✸ subfinder RESULTS | "$website" ✸${reset}\n\n"
    subfinder -d "$website" -all -recursive -silent
    echo -e "\n"
    read -p "         ❯ Press Enter..."
}

##-- active recon
active(){
    clear
    echo -e "\n\n\t${hardyellow}Recommended format: ${sublin}vulnweb.com${reset}"
    read -p "        ✱ Website Adress: " website
    clear
    echo -e "\n\n\t ${greenlight}${sublin}✸ nmap RESULTS | "$website" ✸${reset}\n\n"
    #- is root?
    if [[ $EUID -eq 0 ]]; then
    sudo nmap -sS -Pn -n --top-ports 3000 --max-rate 400 --max-retries 1 -sV --version-light "$website"
    #sudo nmap -sS -p- -Pn -n -T4 --min-rate 1000 --max-retries 2 -sV --version-intensity 5 "$website" #active if you want
    else
    nmap -sT -Pn -n --top-ports 1000 --max-rate 300 --max-retries 1 -sV --version-light "$website"
    #nmap -sT -Pn -n -p- --min-rate 2500 --max-retries 0 -sV "$website" #active if you want
    fi
    echo -e "\n\n\t ${greenlight}${sublin}✸ naabu RESULTS | "$website" ✸${reset}\n\n"
    naabu -host "$website" -top-ports 1000 -rate 2000 -c 50 -silent
    #naabu -host "$website" -p - -rate 3000 -c 75 -exclude-cdn -json #active if you want
    echo -e "\n\n\t ${greenlight}${sublin}✸ dnsx RESULTS | "$website" ✸${reset}\n\n"
    echo "$website" | dnsx -a -aaaa -cname -resp -silent -t 100 #-d = bruteforce, needs wordlist
    #echo "$website" | dnsx -a -aaaa -cname -mx -ns -txt -srv -soa -caa -resp -t 250 -rl 500 -retry 3 #active if you want
    echo -e "\n\n\t ${greenlight}${sublin}✸ gospider RESULTS | "$website" ✸${reset}\n\n"
    gospider -s "$website" -c 10 -d 3 --js --sitemap --robots
    #gospider -s "$website" -t 20 -c 15 -d 5 --js --sitemap --robots --subs -a -w -r --blacklist "\.(jpg|jpeg|png|gif|css|woff|woff2|ttf|svg|ico|mp4|mp3|pdf|zip|rar|exe|dmg)$" --json #active if you want
    echo -e "\n\n\t ${greenlight}${sublin}✸ traceroute RESULTS | "$website" ✸${reset}\n\n"
    traceroute -n -m 30 -w 2 -q 1 "$website" | awk 'NR>1 {print $0}'    
    echo -e "\n"
    read -p "         ❯ Press Enter..."
}

##-- fingerprint
fingerprint(){
    clear
    echo -e "\n\n\t${hardyellow}Recommended format: ${sublin}vulnweb.com${reset}"
    read -p "        ✱ Website Adress: " website
    clear
    echo -e "\n\n\t ${greenlight}${sublin}✸ whatweb RESULTS | "$website" ✸${reset}\n\n"
    whatweb -a 3 -v --color=always -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" --no-errors "$website"
    echo -e "\n"
    echo -e "\n\n\t ${greenlight}${sublin}✸ httpx RESULTS | "$website" ✸${reset}\n\n"
    httpx -u "$website" -sc -cl -ct -title -server -td -ip -cname -cdn -location -favicon -jarm -rt -silent -rl 150 -t 50 -timeout 10 -retries 2
    #httpx -u "$website" -sc -cl -ct -title -server -td -cpe -favicon -jarm -hash sha256 -ip -cname -asn -cdn -location -method -ws -rt -lc -wc -bp 200 -tls-grab -tls-probe -csp-probe -http2 -pipeline -vhost -path /,/admin,/login,/api,/robots.txt,/sitemap.xml -x all -fr -fhr -maxr 10 -pa -json -irh -include-chain -sr -srd httpx_raw/ -rl 300 -t 100 -timeout 15 -retries 3 -silent
    echo -e "\n\n\t ${greenlight}${sublin}✸ wafw00f RESULTS | "$website" ✸${reset}\n\n"
    wafw00f -a -v "$website"
    read -p "         ❯ Press Enter..."
}


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
\t\t   █▐        ⛧  by cve6           █  
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
active
;;
3)
fingerprint
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
