#!/bin/bash

for market in `ls /smarts/data/ | grep "_i$" | grep -vE "fake|test" `; do 
	echo -e "===>${Green}${market}${NC}<===";
	START=`grep order_start_time /usr/share/marketconfig/${market%_i}/${market%_i}.cfg | cut -d'=' -f2`; 
	END=`grep order_finish_time /usr/share/marketconfig/${market%_i}/${market%_i}.cfg | cut -d'=' -f2`;
	
	echo "--Before Start--";
	if  [[ -f /smarts/data/${market}/track/2017/01/20170118.fav.gz ]]; then
		favcount -e "time < ${START}" /smarts/data/${market}/track/2017/01/20170118.fav.gz;
		favdump -e "time < ${START} and type=OFFTR" /smarts/data/${market}/track/2017/01/20170118.fav.gz | head -n1
	else
		echo "No track available";
	fi
	echo "--After End--";
	if  [[ -f /smarts/data/${market}/track/2017/01/20170118.fav.gz ]]; then 
		favcount -e "time > ${END}" /smarts/data/${market}/track/2017/01/20170118.fav.gz; 
		favdump -e "time > ${END} and type=OFFTR" /smarts/data/${market}/track/2017/01/20170118.fav.gz | tail -n1
	else 
		echo "No track available for date 20170118";
	fi
done