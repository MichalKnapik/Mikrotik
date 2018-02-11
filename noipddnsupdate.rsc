#set details of your account/domain here
:local dynlogin PUT_LOGIN_HERE;
:local dynpass PUT_PASSWORD_HERE;
:local sitename PUT_SITENAME_HERE;

#any plaintext IP service
:local ipchecker "http://wgetip.com/";

#copy previous IP (if any)
:local prevwanip "0.0.0.0";
:if ([:len [:file find name="wanresult.txt"]] > 0) do={
:set prevwanip [:file get "wanresult.txt" contents];
}

:tool fetch url="$ipchecker" keep-result=yes dst-path="/wanresult.txt";
:local wanip [:file get "wanresult.txt" contents];

#update IP, if change detected
if ( $prevwanip != $wanip ) do={
:log info "DDNS No-IP updater: IP changed from $prevwanip to $wanip. Updating DDNS records."
:tool fetch password="$dynpass" user="$dynlogin" url="https://dynupdate.no-ip.com/nic/update\?hostname=$sitename&myip=$wanresult" mode=https keep-result=no;
} else={
:log info "DDNS No-IP updater: no IP change detected ($wanip)."
}