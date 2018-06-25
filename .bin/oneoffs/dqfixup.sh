#!/bin/bash

EMEA_MARKETS=${EMEA_MARKETS:-ams batseu ber bru chixeu cmee dme dus eurex ham han jse lifams lifbru lifpar lis lme mse mun omx osl par swx swxsp trq wbag xetra}
NSAC_MARKETS=${NSAC_MARKETS:-cbf cbot cbotmd chixca cme cmemd cxtwo lynx mgex mx neoe nlx nymex nymexmd omega opra us}

cd /data01/zaccam/puppet/modules/feedprocessor/files/configs/
pwd

for market in ${NSAC_MARKETS}; do
	sed -i -e 's/mergerpt/merge_report/g' -e 's/brokerrpt/broker_csv_report/g' -e 's/brokererror/broker_csv_errors/g' ${market}/*;
done

for f in `git diff | grep "+ b/" | cut -d'/' -f6-`; do 
	echo "===${Green}${f}${NC}===";
	# Cleanup trailing spaces
	sed -i 's/[ \t]*$//g' ${f};
	# Remove Id and URL
	sed -i -e '/\$Id.*\$/d' -e '/\$URL.*\$/d' ${f};
	# Clean out version
	sed -i 's/ version=\"\$Rev.*\$\"//g' ${f};
	# Remove double blank lines
	sed -i 's/\n\n/\n/g' ${f};
	# Remove deprecated properties
	sed -i '/useFAVIDFor/d' ${f}

	fpConfigValidator -q ${f}

done

