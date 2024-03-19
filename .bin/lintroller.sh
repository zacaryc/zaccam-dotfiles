#!/bin/bash
######################################################################
#								     #
#		L  I  N  T  R  O  L  L  E  R			     #
#								     #
#	Written by Kevin Gatdula, shell scripting extraordinaire     #
#	SMBC Market Integration 2016				     #
#	@kevinofsydney						     #
#								     #
######################################################################

#	https://wiki.dev.smbc.nasdaqomx.com/confluence/display/CLINT/Lintroller

######################################################################
			  VERSION="1.1.2"
		  LAST_UPDATED="7th February 2017"

#   ===Version 1.1.2===
#Sent favutcountv2 banner to /dev/null
#Removed some typos 
#Added the option/s for the user to run only on market data, or only on broker data

#   ===Version 1.1.1===
#Lintroller now properly differentiates between RAW and CSV .zip files now

#   ===Version 1.1===
#Lintroller should properly handle .tar.gz files now
#Improved regex to find FIX header

#   ===Version 1.0===
#Fixed a bug where a certain filepath would not properly be assigned during the loop, affecting news check
#Adding the broker-name to the temp files
#Added a check for whether favutcountv2 is installed on the server, and if not, installs it
#Updates any favtools as necessary via yum
#favex() now properly captures a midfix when one is entered.
#Lintroller now properly detects who ran the report
#Lintroller now exits if no data for <broker>_<market> exists on /smarts/data/
#Added a prompt if the user inputs a date range greater than 20 days
#When a FAV is not found, Lintoller prints what else is in the directory
#Favlint summary now properly at the end of the report
#Zip now removed after it is sent to a ticket

#   ===Version 0.9.3===
#All relevant RAW messages are now printed, rather than the first 10 provided by 'head' command
#Fixed the messed up favlint summary by sending all stderr from favlint to /dev/null
#Users can no longer input a word or non-positive integer argument after invoking -n
#Users can no longer input a date in the future

#   ===Version 0.9.2===
#Completely overhauled violation descriptions
#Banner now says L I N T R O L L E R
#All output now goes to a single file (!)
#All output is now goes to a single directory, /data01/lintroller/$broker_$market rather than $bm_b and $bm_m
#Fixed the bug where not all temporary files were not being deleted on completion
#Code cleanup and consolidation
#Favlint output is now saved in the same directory as the lintroller output - it is no longer deleted
#Changed the grep filters at the end of favlint - now include INFOs and only excludes the header
#As a result of the above, the favlint summary now includes more stuff (e.g. MissingInitFlag)
#TOTAL, FAVID and FINIS have been excluded from the FAVCOUT section
#Changed the regex for the O-tag to be more general - now includes every character except space

#   ===Version 0.9.1===
#Added a favlint summary of violations at the end of the favlint section of the report
#UT, NEWS and CONTL checks only run on _m data now
#Created a much more useful usage() function to tell the user how to use Lintroller
#Added the number of each violation to the violation header in Lintroller()
#Moved the violation summary to the end of the file

#   ===Version 0.9.0===
#Lintroller checks if there are any securities in the bm's security.name file that do not match
#	the market's security.name file - utcheck
#Secnamefilecomparator runs checks against the security.name file on the market and the broker
#Fixed a bug where UT and control checks would still run even if the FAV did not exist in _m directory
#Secnamefilecomparator now operates using fav2name, resulting in a huge performance increase over using namedump -lc
#Function that resets all important variables on each iteration of the lintroller loop
#When a midfix is inputted, script will run favlint --use-midfix=$MIDFIX ...
#Using the -s flag the user can specify a ticket that they want to attach the report to (see MKTINT-23827)
#Quasi-quiet mode is now enabled by default - verbose mode can be re-enabled with -v
#Polisher() now removes all INFO messages from the final report and also moves the WARNING messages to the end of the report.
#Encoding issues fixed - thank you Jimmy Duong!

#   ===Version 0.8.0===
#Many, many changes.
#Most notably, the entire script has been modularised by putting all code into functions.
#Script now takes in four arguments by default and two options (MIDFIX for FAV and SUBS ticket)
#Script is now able to operate over a range of dates, using trday function
#Echo statements are now more informative, making use of INFO, WARNING and ERROR messages
#Output to file functionality has been disabled for the time being
#
#   ===Version 0.7.1===
#Temporary files are now fully contained inside the lintroller/temp folder
#Report filenames are now of the pattern '<broker>_<favdate>_report_<datetime>'

#   ===Version 0.7.0===
#lintroller.sh is now based out of /data01/lintroller/, and requires an alias to run.
#Script will now only run with sudo permission due to operations required in /data01/ directory
#Forced initial checks for brokermarket and date arguments at runtime
#	- Fixed bug where trailing slash on brokermarket would cause the script to fail
#Script is now able to handle multiple raw files
#Fixed a fatal error when user entered a brokermarket with a trailing slash
#	e.g. cgp_hkex_b/ as opposed to just cgp_hkex_b
#The script now operates off /smarts/data
#Output no longer goes to stdout; instead, output is written to individual reports,
#	which can be found in /data01/lintroller/<brokermarket>
#Reports have filename '<datetime>_<broker>_<favdate>_report'
#Wrote regression.sh, which can be used to test lintroller.sh
#Support for .tar filetype has been removed, while .tar.gz is now supported
#Supported filetypes:
#	- .raw.gz
#	- .zip
#	- .tar.gz
#
#   ===Version 0.6.0===
#Added violation coverage:
#	MissingOddLotFlagViolation
#	TradeInactiveOrderViolation
#	DuplicateOrderEntryViolation
# 	MissingMarketOrderFlagViolation
#This marks the completion of the primary list of violations
#Fixed a bug where the script would ignore messages if it was the last message
#	in one violation and subsequently the first message in another violation
#Further code cleanup and improved readability:
#	Removed redundant echo calls in rap() and jazz()
#Initial construction of rawFormatter(), written to handle FIX files
#Supported RAW filetypes:
#	- .raw.gz
#	- .zip
#	- .tar
#
#   ===Version 0.5.1===
#General code cleanup and improved readability
#
#   ===Version 0.5===
#Added violation coverage:
#	VolumeSanityViolation (almost lost my sanity doing this one)
#	OrderNotFoundViolation
#	InvalidISINViolation
#Improved favex function to be quicker in finding the O= tag
#Script now requires security.name file to function correctly
#	and for InvalidISINVio to function
#
#   ===Version 0.4===
#Added violation coverage:
#	OddLotFlagSet
#Lintroller now navigates to folders on its own once given a date:
#	e.g. when given 20161028, it navigates to raw|track/2016/10/20161028
#Fixed bug where emphasis would not be given to prices/volumes not ending in '.000'
#Script now deletes temp file 'temp/tempdump_$bm' on completion
#Script now detects whether temp/tempdetailedout_$bm and temp/tempsortedout_$bm exist, and if not,
#	runs the command to produce them and delete temp/tempdetailedout_$bm on completion
#
#   ===Version 0.3===
#Violations covered:
#       PriceMismatch
#       ActivityOnRemovedOrder
#       CrossedOrderSpread
#       EqualOrderSpread
#       InsufficientVolume
######################################################################

#===============To do list====================
#TODO: Outputs from RAW files need to be formatted properly to avoid output overload
#	- Sorted by execution time (tag 60?)
#TODO: (Optional) Variable override option if the user wants to output to specific location or with a specific filename
#TODO: Script prints a message of "All securities matched" when fav2name returns nothing
#=============================================

#==========What does this script do?==========
#This script displays the different types of violations found in the FAV files,
#and then displays the related raw messages that contributed to the violations
#from the raw CSV or FIX files.
#
#From the output of the favdump we want to extract the underlying RAW message using its O-tag (e.g. O=OS00MG37)
#favMsgType is the message type (e.g. ENTER, TRADE, AMEND, etc.). This tells us which of the groups of raw messages we need to access e.g. ENTER.csv, TRADE.csv, etc.

#===========Miscellaneous notes ==============
#1. I added sh lintroller.sh as an alias for my own ease of dev/use
#	- Otherwise, it can be called from /data01/kevgat/lintroller.sh
#2. I added alias sudo='sudo ' to my bashrc to make the aforementioned alias work

NUMEXAMPLES=1
MIDFIX=''
JIRA_TICKET=''
NAMEDUMPTAG=''
VERBOSEFLAG=0
OPTDEST=''
BROKERONLYFLAG=0
MERGEONLYFLAG=0

while getopts "be:n:m:s:tv" opt
do
	case $opt in
	  b) 
		 MERGEONLYFLAG=1
		 echo -e "INFO\t Lintroller will run checks only on broker data." 
		 shift 1
		 OPTIND=1 ;;
	  e)
		 BROKERONLYFLAG=1
		 echo -e "INFO\t Lintroller will run checks only on merge data."
		 shift 1
		 OPTIND=1 ;; 
	  m)
		 MIDFIX=$OPTARG
		 echo -e "INFO\t Using MIDFIX $MIDFIX."
		 shift 2
		 OPTIND=1 ;;
	  n)
		 NUMEXAMPLES=$OPTARG
		 echo -e "INFO\t Number of examples set to $NUMEXAMPLES."

		 if [[ ! $NUMEXAMPLES -gt 0 ]]
		 then
		 	echo -e "ERROR\t \"$NUMEXAMPLES\" is not a valid number of examples - exiting."
		 	exit
		 fi

		 shift 2
		 OPTIND=1 ;;
	  s)
		 JIRA_TICKET=$OPTARG
		 echo -e "INFO\t On completion, Lintroller will attach the report to subscription ticket $JIRA_TICKET."
		 shift 2
		 OPTIND=1 ;;
	  t)
		 NAMEDUMPTAG=$OPTARG
		 echo -e "INFO\t Using tag $NAMEDUMPTAG in namedump analysis."
		 shift 2
		 OPTIND=1 ;;
	  v)
		 VERBOSEFLAG=1
		 shift 1
		 OPTIND=1 ;;
	  o)
		 OPTDEST=$OPTARG
		 optdestcheck
		 shift 2
		 OPTIND=1
	esac
done

usage()	{
	echo Lintroller version $VERSION \($LAST_UPDATED\)
	echo "Usage:
	sudo lintroller [-bcmnstv] <broker> <market> <startdate> <enddate>"
	echo Options:
	echo -e "  -b \t\t\t\"Broker only\" switch: runs Lintroller only on broker data." 
	echo -e "  -c \t\t\t\"Merge only\" switch: runs Lintroller only on merge data."
	echo -e "  -m <midfix> \t\tSpecify a midfix for the FAV files."
	echo -e "  -n <no. of examples> \tThe number of examples shown is set to 1 by default."
	echo -e "  -s <JIRA ticket> \tThe JIRA ticket to attach the report to."
	echo -e "  -t <namedump tag> \tSpecify a security tag that you want to perform a namedump on."
	echo -e "  -v \t\t\tVerbose mode switch."
	exit
}

if [[ -z $1 && -z $2 && -z $3 && -z $4 ]]
	then usage
	exit
elif [[ $1 =~ [0-9]+ || $2 =~ [0-9]+ || ! $3 =~ [0-9]+ || ! $4 =~ [0-9]+ ]]
	then usage
	exit
elif [[ ! $1 ]]
	then echo -e "ERROR\t Broker not entered."
	usage
	exit
elif [[ ! $2 ]]
	then echo -e "ERROR\t Market not entered."
	usage
	exit
elif [[ ! $3 ]]
	then echo -e "ERROR\t Startdate not entered."
	usage
	exit
elif [[ ! $4 ]]
	then echo -e "ERROR\t Enddate not entered."
	usage
	exit
elif [[ $3 -gt $4 ]]
	then echo -e "ERROR\t Startdate cannot be after the enddate."
	exit
elif [[ $3 -gt `date +%Y%m%d` ]]
	then echo -e "ERROR\t Startdate entered is in the future."
	exit
elif [[ $4 -gt `date +%Y%m%d` ]]
	then echo -e "ERROR\t Enddate entered is in the future."
	exit
fi

#===============Important variables===============

lintroller='/data01/lintroller'
temp='/data01/lintroller/temp'
detf=$temp/tempsortedout_$bm
startdate=$3
enddate=$4
broker=$1
market=$2
bm="${1}_${2}_b"
filename='INIT_FILENAME'

#These variables are used to navigate through the correct raw or track folders when grepping.
currdate=$3
year=0
month=0
file_path=''

seenVio=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
#This is the array to check whether we have encountered this violation before.

currId=0
currVio=999

noVioFlag=0
noUnmatch=0
noMarketSecFlag=0

#=================================================

polisher()	{
	#Purpose: Removes the INFO and WARNING messages from the final report.
	#Reason: These messages are only relevant for debugging (in -v mode), not for the broker.

	grep WARNING $outfile > ${outfile}_warns
	grep -v INFO $outfile | grep -v WARNING > ${outfile}_p
	cat ${outfile}_warns >> ${outfile}_p
	sudo rm ${outfile}_warns
	mv ${outfile}_p $outfile
}

ticketAttacher()	{
	#Purpose: Attaches the output of the script to a specified JIRA ticket.
	#Reason: To assist in ticket response and improve the documentation/paper trail.
	if [[ -z $JIRA_TICKET ]]
	then
		return
	fi

	file_to_attach="/data01/lintroller/${broker}_${market}/$filename.zip"

	sudo chmod 755 $outfile
	#iconv -f "UTF-8" -t "WINDOWS-1252" $outfile -o /data01/lintroller/${broker}_${market}/${filename}_conv.txt
	awk 'sub("$", "\r")' $outfile > /data01/lintroller/${broker}_${market}/${filename}_conv.txt

	zip -j $file_to_attach /data01/lintroller/${broker}_${market}/${filename}_conv.txt
	sudo chmod 755 $file_to_attach
	sudo rm /data01/lintroller/${broker}_${market}/${filename}_conv.txt

	#Filesize check.
	filesize=`stat -c%s $file_to_attach`

	#If required, the maximum filesize allowed can be changed here. It is currently set to 20MB.
	if [[ $filesize -gt 20000000 ]]
	then
		echo -e "WARNING\t File $filename.zip is too large to be attached to an email. "
		echo -e "INFO\t File can be found on /data01/lintroller/${broker}_${market} on $HOSTNAME."
	else

		comment=''
		echo -e "INFO\t This report will be mailed to $JIRA_TICKET."

		echo -e "INFO\t Please enter a comment in the next 20 seconds."
		read -t 20 comment

		if [[ -z $comment ]]
		then
			echo -e "WARNING\t You have not entered a comment."
			echo -e "INFO\t Using default comment."
			comment="This Lintroller report was produced by `who am i | cut -d' ' -f1` on `date`."
		fi

		if [[ -z $filename ]]
		then
			echo -e "ERROR\t Bug encountered! Filename not correctly specified by Lintroller. Suggest you exit and fix this bug."
			continue

		fi

		echo -e "INFO\t Submitting: \"$comment\" with file $filename."
		echo "$comment" | mail -a "$file_to_attach" -s "$JIRA_TICKET" smbc.jira@nasdaqomx.com

		echo -e "INFO\t Ticket attachment email sent. Please allow up to 30 minutes for it to show up on your ticket."
		echo -e "INFO\t File can also be found on /data01/lintroller/${broker}_${market} on $HOSTNAME."
	fi
	sudo rm /data01/lintroller/${broker}_${market}/${filename}.zip
}

optdestcheck() {
	#Purpose: TODO: Allows the output to be placed in a specific directory (currently unfinished)
	#Reason: To make it easier for the user to view the report if the user does not want to use /data01/lintroller/
	if [[ ! -d $OPTDEST ]]
	then
		echo -e "WARNING\t Specified directory does not exist. It is suggested that you create the directory with the proper rights and run the script again."
		echo -e "INFO\t Exiting..."
		exit
	else
		echo -e "INFO\t Generated reports will be dumped in directory $OPTDEST."
	fi
}

daysCheck()	{
	days_tot=`trday /usr/share/marketconfig/$market/${market}.cfg -d $startdate -e $enddate | wc -l`

	if [[ days_tot -gt 20 ]]
	then
		echo -e "INFO\t You have entered a date range greater than 20 trading days. Are you sure you want to proceed? [y/n]"
		while read -t 20 response
		do
			if [[ $response == 'y' ]]
			then
				break
			elif [[ $response == 'n' ]]
			then
				echo -e "INFO\t Lintroller will now exit."
				exit
			else
				echo -e "INFO\t Response not understood. Are you sure you want to proceed?"
				response=""
				continue
			fi
		done

		if [[ -z $response ]]
		then
			echo -e "INFO\t No response received. Exiting."
			exit
		fi
	elif [[ days_tot -eq 0 ]]
	then
		echo -e "INFO No valid trading days within that date range."
	fi
}

flagReset()	{
	#Purpose: Resets certain flags in the script
	#Reason: Because the script can operate over multiple dates, if data from one data trips a flag,
	#		the flag's status should not carry over to other days.
	noVioFlag=0
	noUnmatch=0
	noMarketSecFlag=0
}

toolcheck() {
	##--Update favtools, which contains favlint, favdump, namedump, trday, etc.
	echo -e "INFO\t Downloading any available favtools updates (favlint, namedump, trday, etc.)"
	sudo yum update favtools -y --enablerepo=cmss-dev > /dev/null
	if [[ ! -f /usr/local/bin/favutcountv2 ]]
	then
		echo -e "INFO\t Favutcountv2 not found in /usr/local/bin/. Installing..."
		sudo yum install qa-cmdtools.noarch -y --enablerepo=cmss-dev
		echo -e "INFO\t Favutcountv2 installed successfully."
	fi
}

controlcheck() {
	contl_count=0

	if [[ -f /smarts/data/${broker}_${market}_m/track/${file_path}.fav.gz ]]
	then
		contl_count=`favcount -e type=CONTL /smarts/data/${broker}_${market}_m/track/${file_path}.fav.gz | grep CONTL | cut -d' ' -f2`
		if [[ ! $contl_count -eq 0 ]]
		then
			echo -e "SUCCESS\t Control message check passed with $contl_count CONTL messages detected."
		else
			echo -e "WARNING\t No control messages detected for $bm on ${currdate}."
		fi
	else
		echo -e "WARNING\t No control messages detected for $bm on ${currdate}."
	fi
}

newscheck() {
	if [[ -f /smarts/data/${broker}_${market}_m/track/${file_path}.I.fav.gz ]]
	then
		echo -e "SUCCESS\t News detected for $bm on ${currdate}."
	else
		echo -e "WARNING\t No news detected for $bm on ${currdate}."
	fi
}

utcheck()	{
	echo -e "INFO\t Generating unmatched trades report..."

	if [[ ! -f /smarts/data/${broker}_${market}_m/track/${file_path}.fav.gz ]]
	then
		echo -e "WARNING\t ${tradeday}.fav.gz not found in ${broker}_${market}_m, skipping UT check."
	elif [[ ! -f /usr/local/bin/favutcountv2 ]]
	then
		echo -e "WARNING\t Favutcountv2 is not installed on this server. Skipping UT check."
	else
		echo
		echo  ====== Unmatched trades report =====
		/usr/local/bin/favutcountv2 /smarts/data/${broker}_${market}_m/track/${file_path}.fav.gz /usr/share/marketconfig/$market/${market}.cfg 2>/dev/null | grep -v "Process is starting" | grep -v "Reading" | grep -v "Result:"
		echo -e "INFO\t Unmatched trades report complete."
	fi
}

secnamefilecomparator()	{
	if [[ -f /smarts/data/${market}/security.name ]]
		then marketcompare="$market"
	elif [[ -f /smarts/data/${market}_i/security.name ]]
		then marketcompare="${market}_i"
	elif [[ -f /smarts/data/${market}_r/security.name ]]
		then marketcompare="${market}_r"
	else
		echo -e "WARNING\t No ${market}_i, ${market}_r, or ${market} found in /smarts/data/."
		noMarketSecFlag=1
		return 1
	fi

	#If you have any questions on how this works, please consult Zachary Campbell or the author of fav2name, ??????

	echo
	echo ===== Unmatched securities report =====
	if [[ ! -z $NAMEDUMPTAG ]]
	then
		for i in `namedump /smarts/data/$bm/security.name | cut -d' ' -f3`
		do
			if [[ $i == ---- ]]; then continue; fi
			#Uncomment the next line if you want to see a pseudo-loading bar.
			#echo -e "INFO\t Looking up ${i}..."
			result=`namedump -e "field[$NAMEDUMPTAG]=$i" /smarts/data/$marketcompare/security.name`
			result+="\n\t$result"
		done
		
		if [[ `echo $result | wc -w` -eq 0  ]]
		then
			echo -e "SUCCESS\t All securities were matched."
		else
			echo -e $result
		fi
	fi

	if [[ ! -f /smarts/data/$bm/house.name ]]
	then
		echo -e "WARNING\t The house.name file was not found for ${bm}. Skipping security.name analysis."
	elif [[ ! -f /smarts/data/$bm/trader.name ]]
	then
		echo -e "WARNING\t The trader.name file was not found for ${bm}. Skipping security.name analysis."
	elif [[ ! -d /smarts/data/$bm/track ]]
	then
		echo -e "WARNING\t FAV data for was not found ${bm}. Skipping security.name analysis."
	elif [[ ! -f /smarts/data/$marketcompare/security.name ]]
	then
		echo -e "WARNING\t The security.name file was not found for ${market}. Skipping security.name analysis."
	else
		sudo mkdir /data01/lintroller/temp/$bm
		sudo ln -s /smarts/data/$bm/house.name /data01/lintroller/temp/$bm 2>/dev/null
		sudo ln -s /smarts/data/$bm/trader.name /data01/lintroller/temp/$bm 2>/dev/null
		sudo ln -s /smarts/data/$bm/track/ /data01/lintroller/temp/$bm 2>/dev/null
		sudo ln -s /smarts/data/$marketcompare/*.name /data01/lintroller/temp/$bm 2>/dev/null

		sudo chown -R favsync.mpl /data01/lintroller/

		echo -e "INFO\t The following securities traded by $bm are unmatched on market $marketcompare for day $currdate:"

		#Note that for some reason, the output from fav2name comes through stderr not stdout
		fav2name --test /data01/lintroller/temp/$bm -s $currdate -e $currdate |& grep -oP "(?<=missing: )[\d\w\.\_\-]+" | sed 's/^/    /' > $temp/tempsecname_$bm

		if [[ $(wc -l ${temp}/tempsecname_$bm | grep -oP "\d+") -eq 0 ]]
		then
			echo -e "SUCCESS\t All securities matched successfully."
		fi

		echo -e "INFO\t Security.name file comparison complete."
		sudo rm -rf /data01/lintroller/temp/$bm
	fi
}

lintdircheck()	{
	#This check only needs to be performed once at the beginning of the script.
	if [[ -d $lintroller/temp ]];
	then
		return
	else
		echo -e "INFO\t Creating directory /data01/lintroller"
		sudo mkdir -m2755 -p /data01/lintroller/temp 2>/dev/null
	fi

	sudo chown -R favsync.mpl /data01/lintroller
}

lintbromardircheck()	{
	#This check needs to occur once for each broker-market.
	if [[ ! -d /smarts/data/${broker}_${marker}_b && ! -d /smarts/data/${broker}_${market}_m ]]
	then
		echo -e "ERROR\t No data found for ${broker}_${market} on /smarts/data/."
		exit
	elif [[ ! -d /data01/lintroller/${broker}_${market} ]];
	then
		echo -e "INFO\t Creating directory /data01/lintroller/${broker}_${market}"
		sudo mkdir /data01/lintroller/${broker}_${market}
		sudo chown -R favsync.mpl /data01/lintroller
	fi
}

namefilecheck() {
	if [[ ! -f /smarts/data/${broker}_${market}_b/security.name  ]];
	then
		echo -e "ERROR\t 'security.name' not found in directory /smarts/data/$bm."
		echo -e "WARNING\t\t --> Any InvalidISINViolations present will not be reported."
	else
		echo -e "INFO\t Generating inputs: running namedump..."
		namedump /smarts/data/$bm/security.name > $temp/tempname_$bm
		echo -e "INFO\t Namedump completed successfully."
	fi
}

favlintgenerator() {
	#Note that the favlint outputs must be ordered alphabetically by violation
	#for the script to function correctly.
	echo -e "INFO\t Running favlint for $bm on $currdate. Please wait."

	if [[ ! -z $MIDFIX ]]
	then
		favlint --use-MIDFIX=$MIDFIX -p all /smarts/data/$bm $currdate 2>/dev/null | grep -v favlint | grep -v JVM > $temp/tempdetailedout_$bm
	else
		favlint -p all /smarts/data/$bm $currdate 2>/dev/null | grep -v favlint | grep -v JVM >  $temp/tempdetailedout_$bm
	fi

	echo -e "INFO\t Favlint completed successfully."
	sort -d -k2 $temp/tempdetailedout_$bm > $temp/tempsortedout_$bm
	sudo rm $temp/tempdetailedout_$bm
}

rawunzipper()	{
#This method makes a temporary, less-able dump of the relevant raw file. It can handle multiple
#raw files for one fav-date.

#NOTE to future maintainers of this script, should anyone be so unlucky:
#If there is a filetype that is not covered by this script, as you can see below it is fairly simple
#	for you to add support for it. Simply use the appropriate method to extract the contents of the
#	file to stdout and then write it to a temporary file named 'tempRawOut_$bm', except
#	for FIX formats, which should be named tempRawOut_$bmGZOut

	rawlist=$(ls /smarts/data/$bm/raw/$year/$month/ | grep -P $currdate)
	for rawfile in $rawlist
	do
		if [[ $rawfile == *".gz" ]];
		then
			version=$(zless /smarts/data/$bm/raw/$year/$month/$rawfile | grep -oPam1 "(?<=8=)[\w.]*[45]\.\d")
			if [[ -z $version ]]
			then
				zless /smarts/data/$bm/raw/$year/$month/$rawfile >> $temp/tempRawOut_$bm
			else
				/usr/local/feedprocessor/bin/fixTextDump /smarts/data/$bm/raw/$year/$month/$rawfile 8=${version} >> $temp/tempRawGZOut_$bm
			fi
		elif [[ $rawfile == *".zip" ]];
		then
			version=$temp/tempRawOut_$bm | grep -oPam1 "(?<=8=)[\w.]*[45]\.\d"
			if [[ -z $version ]]
			then
				unzip -qqc /smarts/data/$bm/raw/$year/$month/$rawfile >> $temp/tempRawOut_$bm #2>/dev/null
			else
				/usr/local/feedprocessor/bin/fixTextDump $temp/tempRawOut_$bm 8=${version} >> $temp/tempRawGZOut_$bm
			fi
		fi
	done
}

bromarcheck() {
	if [[ ! -d /smarts/data/$bm ]]
	then
		if [[ $bm == *_m ]]
		then
			echo -e "WARNING\t /smarts/data/$bm not found - skipping UT, CONTROL and NEWS checks."
			continue
		else
			echo -e "WARNING\t /smarts/data/$bm not found."
		fi
		continue
	else
		echo -e "INFO\t /smarts/data/$bm found."

		if [[ $bm == *_b ]]
		then
			echo -e "INFO\t Attempting to generate Lintroller report."
		fi
	fi
}

rawfavdatecheck() {
	if [[ ! -z $MIDFIX ]]
	then
		if [[ ! -f /smarts/data/$bm/track/${file_path}.${MIDFIX}.fav.gz ]]
		then
			echo -e "ERROR\t FAV not found for $bm on date $currdate using MIDFIX $MIDFIX."
			echo -e "ERROR\t Favlint violation report cannot run without FAV data."

			if [[ -d /smarts/data/$bm/track/$year/$month/ ]]
			then
				echo -e "INFO\t You may consider these other files:"
				ls /smarts/data/$bm/track/$year/$month/
			fi

			sudo rm $outfile
			continue
		fi
	elif [[ ! -f /smarts/data/$bm/track/${file_path}.fav.gz ]];
	then
		echo -e "ERROR\t FAV not found for $bm on date $currdate."
		echo -e "ERROR\t Favlint violation report cannot run without FAV data."

		if [[ -d /smarts/data/$bm/track/$year/$month/ ]]
		then
			echo -e "INFO\t You may consider these other files:"
			ls /smarts/data/$bm/track/$year/$month/
			echo -e "INFO\t Consider using a midfix if necessary."
		fi

		sudo rm $outfile
		continue
	fi

	ls /smarts/data/$bm/raw/${file_path}* > /dev/null 2>&1
	if [[ ! $? -eq 0 ]];
	then
		echo -e "ERROR\t RAW not found for $bm on date $currdate."
		echo -e "ERROR\t Favlint violation report cannot run without RAW data."
		sudo rm $outfile
		continue
	fi

	echo -e "INFO\t Now generating report for $bm on ${currdate}."
	return 0
}

outputhandler()	{
	filename=$(echo ${broker}_${market}_${currdate}_lintroller_`date +%Y.%m.%d_%H.%M.%S`)
	tempoutfile=$lintroller/${broker}_${market}/tempreport_${broker}_${market}_$currdate
	outfile="$lintroller/${broker}_${market}/$filename.txt"
}

lintroller() {
	#It's called lintroller because it picks up the lint from favlint. Brilliant name, right?
	echo -e "INFO\t Creating $outfile."
	echo -e "INFO\t Generating lintroller report..."
	echo $broker $market $currdate
	echo ===== LINTROLLER: =====
	while read -r warn vioType time msgType rest
	do
		if [[ $vioType == "[PriceMismatchViolation]" && seenVio[0] -lt $NUMEXAMPLES ]];
		then
			currVio=0
			expl="The price on the TRADE doesn't match with the latest state of the ORDER - it is either higher than the last bid price or lower than the last ask price. Please make sure that your messages are not out of order. Also, ensure that we are not missing any AMEND messages."
			printHeader $vioType
			rap
		elif [[ $vioType == "[ActivityOnRemovedOrderViolation]" && seenVio[1] -lt $NUMEXAMPLES ]];
		then
			currVio=1
			expl="In this instance we have some activity on an ORDER that was removed (or Fully Traded) on the Order book. Normally there should not be any activity on an ORDER that is fully traded OR deleted from the order book. Please make sure you are not using the same ORDERID for a new order. Also, please check your timestamps and ensure your messages are not out of order."
			printHeader $vioType
			rap
		elif [[ $vioType == "[CrossedOrderSpreadViolation]" && seenVio[2] -lt $NUMEXAMPLES ]];
		then
			currVio=2
			expl="In this instance we are seeing two Orders that are on the opposite side of the book (one BUY and one SELL) and their prices are crossing one another (Buy price is higher than the Sell price), but they have not traded with one another. Since both of these orders were active orders we would have expected to see a TRADE when the second order hits the order book. Please check your data to make sure your timestamps are accurate and that we are not missing any AMEND, TRADE or DELETE message."
			printHeader $vioType
			jazz
		elif [[ $vioType == "[EqualOrderSpreadViolation]" && seenVio[3] -lt $NUMEXAMPLES ]];
		then
			currVio=3
			expl="Two ORDERs that are on the opposite side of the book (one BUY and one SELL) have the same price, but they have not traded with one another. Since both of these orders were active orders we would have expected to see a TRADE when the second order hits the order book. Please check your data to make sure your timestamps are accurate and that we are not missing a AMEND, TRADE or DELETE message."
			printHeader $vioType
			jazz
		elif [[ $vioType == "[InsufficientVolumeViolation]" && seenVio[4] -lt $NUMEXAMPLES ]];
		then
			currVio=4
			expl="We are seeing TRADEs in excess of the ORDER volume. There is simply not enough volume in these orders that could result in the total Traded volume you have provided. Please make sure your messages are not coming out of order and also please check that we haven't missed any AMEND messages."
			printHeader $vioType
			rap

		elif [[ $vioType == "[OddLotFlagSetViolation]" && seenVio[5] -lt $NUMEXAMPLES ]];
		then
			currVio=5
			expl="According to the unit quantity of the following securities, the \"OD\" flag was set incorrectly. Please check the unit quantity to make sure the \"OD\" flag has been set correctly."
			printHeader $vioType
			rap
		elif [[ $vioType == "[MissingOddLotFlagViolation]" && seenVio[6] -lt $NUMEXAMPLES ]];
		then
			currVio=6
			expl="A MissingOddLotFlagViolation occurs a trade message that should have OL flag is missing one."
			printHeader $vioType
			rap
		elif [[ $vioType == "[VolumeSanityViolation]" && seenVio[7] -lt $NUMEXAMPLES ]];
		then
			currVio=7
			expl="The volumes on your ORDER or AMEND messages seem to be incorrect. Please note that ZERO and negative volumes are not accepted by SMARTS."
			printHeader $vioType
			rap
		elif [[ $vioType == "[OrderNotFoundViolation]" && seenVio[8] -lt $NUMEXAMPLES ]];
		then
			currVio=8
			expl="We are seeing messages without an ORDER. Please check your messages to make sure your ORDER is not coming AFTER an AMEND or TRADE. Also please check your data to make sure the ORDER wasn't dropped for some reason. If you have a TRADE that doesn't have an ORDER (i.e. Floor Trade, off-exchange TRADE), please put the TRADE message in the OFFTR.csv file instead of the TRADE.csv file."
			printHeader $vioType
			rap
		elif [[ $vioType == "[UnexpectedCROnTradeViolation]" && seenVio[9] -lt $NUMEXAMPLES ]];
		then
			currVio=9
			expl="We are seeing a TRADE with the CR flag but we are not receiving the ORDER information for both sides. Please either provide the ORDER information for the other side of the TRADE or remove the CR flag. If you provide us two different TRADE messages for the same security that are on opposite sides of each other, with the same volume, price and time, we will cross them internally. You can also tell us your desired buffer time for crossing two Trades. (for example you will like to consider two trades with the same price and volume that are on the opposite side of on another, as a Crossed Trade even if they are 500 milliseconds apart)."
			printHeader $vioType
			rap
		elif [[ $vioType == "[InvalidISINViolation]" && seenVio[10] -lt $NUMEXAMPLES ]];
		then
			currVio=10
			expl="The ISIN provided is not accurate - please check the ISIN code."
			printHeader $vioType
			metal
		elif [[ $vioType == "[TradeInactiveOrderViolation]" && seenVio[11] -lt $NUMEXAMPLES ]];
		then
			currVio=11
			expl="We are seeing a TRADE on an ORDER that was Inactive. Please check the undisclosed volume column of your ENTER/AMEND messages to make sure they are correct. Also please make sure that all AMEND messages are being sent through."
			printHeader $vioType
			rap
		elif [[ $vioType == "[MissingMarketOrderFlagViolation]" && seenVio[12] -lt $NUMEXAMPLES ]]
		then
			currVio=12
			expl="We are seeing Orders with ZERO price where they don't have the MO (market order) flag. Please add the MO flag when the price on an ORDER is ZERO."
			printHeader $vioType
			rap
		elif [[ $vioType == "[DuplicateOrderEntryViolation]" && seenVio[13] -lt $NUMEXAMPLES ]]
		then
			currVio=13
			expl="In this instance we are receiving the Same Order twice. Please make sure that you are not using the same ORDERID twice. Also please make sure that the same ORDER is not sent twice. We should only receive those ORDERS that are sent to the street and internal ORDERs should not be included in the file."
			printHeader $vioType
			rap
		fi
	done < $temp/tempsortedout_$bm

	if [[ $noVioFlag -eq 0 ]]
	then
		echo -e "SUCCESS\t No violations detected by Lintroller."
	fi

	echo ===== BROKER MESSAGE COUNT =====
	if [[ ! -z $MIDFIX ]]
	then
		favcount /smarts/data/$bm/track/${file_path}.${MIDFIX}.fav.gz | egrep -v "TOTAL|FAVID|FINIS" | sed 's/^/    /'
	else
		favcount /smarts/data/$bm/track/${file_path}.fav.gz | egrep -v "TOTAL|FAVID|FINIS" | sed 's/^/    /'
	fi
	echo >> $outfile
	echo -e "INFO\t Lintroller report complete."
}

#Raw file ohtag searcher
rawFormatter() {
	#TODO: Format the output from RAW files properly
	grep -ha $ohtag $temp/tempRawGZOut_$bm
}

#Emphasises output depending on the type of violation
csvFormatter() {
	if [[ $currVio -eq 0 || $currVio -eq 12 ]];				#Emphasises price
	then
		grep $ohtag -ha $temp/tempRawOut_$bm | sort -k3 -k4 -t'|' |  sed -r 's/\|([[:digit:]]+.[[:digit:]]+)\|([[:digit:]]+\.*0*)\|/\|\>>>\1<<<\|\2\|/'

	elif [[ $currVio -eq 1 || $currVio -eq 4 || $currVio -eq 5 || $currVio -eq 8 ]];	#Emphasises volume
	then
		grep $ohtag -ha $temp/tempRawOut_$bm | sort -k3 -k4 -t'|' | sed -r 's/\|([[:digit:]]+.[[:digit:]]+)\|([[:digit:]]+\.*0*)\|/\|\1\|>>>\2<<<\|/'
	elif [[ $currVio -eq 2 || $currVio -eq 3 ]];			#Emphasises a|b (ask|bid)
	then
		grep $ohtag -ha $temp/tempRawOut_$bm | sort -k3 -k4 -t'|' | sed -r 's/\|([[:digit:]]+.[[:digit:]]+)\|([[:digit:]]+\.*0*)\|/\|\>>>\1<<<\|\2\|/' | sed -r 's/\|([aA]|[bB])\|/\|>>>\1<<<\|/'
	elif [[ $currVio -eq 7 || $currVio -eq 9 || $currVio -eq 11 || $currVio -eq 13 ]]; 	#No emphasis
	then
		grep $ohtag -ha $temp/tempRawOut_$bm | sort -k3 -k4
	fi
}

#Extracts the relevant O= tag to search the RAW/FIX/CSV files (i.e. the original trade messages
favex() {

	#File path favex is used for this function only - it is used to capture a midfix if one has been entered.
	file_path_favex=$file_path
	if [[ ! -z $MIDFIX ]]
	then
		file_path_favex=${file_path}.${MIDFIX}
	fi

	#If the message is an OFFTR, then it has a tradeId, not an orderId
	#This is important for OrderNotFoundViolations (I think?)
	if [[ $msgType == "OFFTR" ]];
	then
		favdump -qe "tradeId=$currId" /smarts/data/$bm/track/${file_path_favex}.fav.gz > $temp/tempdump_$bm
	else
		favdump -qe "orderId=$currId" /smarts/data/$bm/track/${file_path_favex}.fav.gz > $temp/tempdump_$bm
	fi

	favDump=$temp/tempdump_$bm
	#Extract the O-tag
	#The regex [^ ] is used here because there could be almost any type of character used in the O-tag.
	ohtag=$(grep -oPm1 '(?<=O=)[^ ]+' $favDump)

	if [[ $ohtag =~ }$ ]]; then ohtag=`echo $ohtag | sed 's/}$//'`; fi
	echo Related RAW messages for orderId=$ohtag:
	#Find original RAW messages with O-tag

	#Determine whether raw file is in FIX or CSV format
	if [[ -f $temp/tempRawGZOut_$bm ]];
	then
		rawFormatter
	else
		csvFormatter
	fi

	((seenVio[currVio]++))
	echo
}

rap() {
	id=$(echo $rest | grep -oP "(?<=id=)(\d+)")
	bid=$(echo $rest | grep -oP "(?<=bidId=)[^,]+")
	ask=$(echo $rest | grep -oP "(?<=askId=)[^\)]+")

	#In this section we want to ensure that we only run favdump once for each orderId.
	#If the bidId is 0, then we want to look at the ask Id

	#In the case of AMEND messages, there isn't an askId or a bidId: only an 'id'
	#Therefore if there is no 'bidId', in the first if statement, we simply use the 'id'

	if [[ -z $bid ]];
	then
		#AMEND messages will reach this line ONLY
		#The second arithmetic check is to ensure that in the edge case where
		#the last ID encountered under one violation becomes the first ID
		#encountered under the next violation, it does not get skipped.

		if [[ $id -eq $currId && ${seenVio[currVio]} -gt 0 ]];
		then
			continue
		else
			currId=$id
		fi
	elif [[ $bid -eq 0 ]];
	then
		if [[ $ask -eq $currId && ${seenVio[currVio]} -gt 0 ]];
		then
			continue
		else
			currId=$ask
		fi
	elif [[ $bid -eq $currId && ${seenVio[currVio]} -gt 0 ]];
	then
		continue
	else
		currId=$bid
	fi

	printExampleHeader
	#Here we print the relevant favlint message, excluding the violation type and the time.
	if [[ $currVio == 0 ]];		#If PriceMismatchViolation
	then
		echo $rest | grep -oP "Trade price \d+.\d+ (greater|less) than (bid|ask) price \d+[.\d+]*"
	elif [[ $currVio == 1 || $currVio == 8 ]];	#If ActivityOnRemovedOrderVio or OrderNotFoundVio
	then
		echo $rest | grep -oP "Referenced OrderState for \w.*"
	elif [[ $currVio == 4 ]];	#If InsufficientVolumeViolation
	then
		echo $rest | grep -oP "Insufficient total (bid|ask) volume to execute \w+"
	elif [[ $currVio ==  5 || $currVio == 6 ]];	#If OddLotFlagSetViolation or MissingOddLotFlag
	then
		echo $rest | grep -oP "Odd Lot .+"
	elif [[ $currVio == 7 ]];			#If VolumeSanityViolation
	then
		echo $rest | grep -oP "\w\w\w\w\w with zero volume."
	elif [[ $currVio == 9 ]];			#If UnexpectedCROnTradeViolation
	then
		echo $rest | grep -oP "CR flag found on .*"
	elif [[ $currVio == 11 ]];			#If TradeInactiveOrderViolation
	then
		echo $rest | grep -oP "Trading inactive (bid|ask) order"
	elif [[ $currVio == 12 ]]; 			#If MissingMarketOrderFlagViolation
	then
		echo $rest | grep -oP "Market Order (MO) not set for zero.*"
	elif [[ $currVio == 13 ]];			#If DuplicateOrderEntryViolation
	then
		echo $rest | grep -oP "Order-id #.+ has already been used"
	fi

	favex
}

#jazz() is used for CrossedOrderSpreadViolations and EqualOrderSpreadViolations.
jazz() {
	bid=$(echo $rest | grep -oP "(\d+)(?= and)")
	ask=$(echo $rest | grep -oP "(?<=ask\\-order #)(\d+)")

	printExampleHeader

	echo $rest at time $time | grep -oiP "The book has remained crossed.+" | sed 's/the/The/'
	echo A. Ask message \#$ask:
	currId=$ask
	favex
	echo B. Bid message \#$bid:
	currId=$bid
	((seenVio[currVio]--))
	favex
}

#metal() is used for InvalidISIN and runs only off the security.name file.
metal() {
	printExampleHeader
	echo $rest
	identifier="$time $msgType "
	grep "${identifier}" $temp/tempname_$bm
	((seenVio[currVio]++))
}

printHeader()	{
	vio=`echo $1 | grep -oP "\w+"`
	numV=`grep -oP "\d+(?= $vio)" $temp/tempsummary_$bm`

	if [[ ${seenVio[currVio]} == 0 ]]; then
		echo ===================================================
		echo -e '\t' $vio - $numV found
		echo ===================================================
		echo
		echo $expl
		echo
	fi
	noVioFlag=1
}

printExampleHeader()	{
	echo \*\*\*\*\* Example $((${seenVio[currVio]}+1)) \*\*\*\*\*
	echo
}

cleanTemps()	{
	if [[ ! `ls $temp | wc -l` -eq 0 ]];
	then
		sudo rm $temp/*  2>/dev/null
		echo -e "INFO\t Temporary files removed successfully."
	fi
	sudo chown -R favsync.mpl /data01/lintroller
}

favlintsummary() {
	echo ===== FAVLINT SUMMARY ===== > $temp/tempsummary_$bm
	cut -d'[' -f2 $temp/tempsortedout_$bm | cut -d']' -f1 | sort | uniq -c | sort -k1 -nr | grep -v TestCase  >> $temp/tempsummary_$bm
	echo
}

mainblock() {
	year=${currdate:0:4}
	month=${currdate:4:2}
	file_path=$year/$month/$currdate

	#For -m, only run this
	if [[ -d /smarts/data/${broker}_${market}_m && $bm == *_m ]]
	then
		if [[ $MERGEONLYFLAG -eq 1 ]]
		then
			echo -e "INFO\t Skipping merge data checks." 
			return
		fi
		utcheck
		newscheck
		controlcheck
	elif [[ $bm == *_b ]]
	then
		if [[ $BROKERONLYFLAG -eq 1 ]]
		then
			echo -e "INFO\t Skipping broker data checks."
			return
		fi

		seenVio=(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		flagReset

		##--Check that trade data exists for that date
		##--Note: If later code is not being run, it is likely because
		##	a) the date entered was not a valid trading day
		##	b) there is no raw file for that date
		## 	c) there is no fav file for that date

		rawfavdatecheck

		##--Run favlint for that date
		favlintgenerator

		rawunzipper

		##--Read favlint violations and generate report
		favlintsummary
		lintroller

		secnamefilecomparator

		##--Save the favlint output
		favlint_filename=$(echo ${broker}_${market}_${currdate}_favlint_`date +%Y.%m.%d_%H.%M.%S`)
		mv $temp/tempsortedout_$bm $lintroller/${broker}_${market}/
		mv $lintroller/${broker}_${market}/tempsortedout_$bm $lintroller/${broker}_${market}/$favlint_filename
	fi

	##--Remove the other date-specific temp files (i.e. the favlint and raw temp files)
	sudo rm $temp/tempRawGZOut_$bm $temp/tempRawOut_$bm 2>/dev/null
}

masterloop() {
	##--Check that /data01/lintroller exists
	lintdircheck

	##--Check that /data01/lintroller/${broker}_${market} exists
	lintbromardircheck

	##--Check the number of days that have been entered is sound
	daysCheck

	##--Check that security.name exists in <broker_market}_b
	namefilecheck

	##--Check that favutcountv2 is installed in the server and that the relevant tools are up to date
	toolcheck

	for tradeday in $(trday /usr/share/marketconfig/$market/${market}.cfg -d $startdate -e $enddate)
	do
		currdate=$tradeday

		##--Generate filename and outputs
		outputhandler

		for i in ${1}_${2}_b ${1}_${2}_m
		do
			bm=$i

			##--Check that /smarts/data/<broker_market> _b and _m exist
			bromarcheck

			if [[ $VERBOSEFLAG -eq 1 ]]
			then
				mainblock | tee -a $outfile
			else
				mainblock >> $outfile
			fi
		done

		#Print summary to screen and then append to file
		cat $temp/tempsummary_${broker}_${market}_b 2>/dev/null

		polisher

		ticketAttacher
	done

	cleanTemps		#Making sure that no temporary files remain
	echo -e "INFO\t Lintroller exited gracefully."
}

masterloop $1 $2

