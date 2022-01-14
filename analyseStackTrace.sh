#!/bin/bash
# Script Parameters
executableName=$1
filename=$2
csv=$3

if [ ! -f "$filename" ] || [ ! -f "$executableName" ] || [ $1 == "-h" ]; then
     echo "Error. The script needs the executable and the Stack Trace files"
     echo "Use: ./analyseStackTrace  <pathToBinaryFile> <pathToStackTraceFile> [CSV]"
     echo "   - pathToBinaryFile: path to the binary file. "
     echo "         For example, the crcs binary file it would be /gem_test/framos/crcs_cp/bin/RTEMS-mvme2700/crcs-cp-ioc"
     echo "   - pathToStackTraceFile: path to Stack Trace file. This file contains the Stack Traces copied of the VME booting"
     echo "   - CSV: If you want the output in csv command, you have to specify csv in this parameter. \n \n"
     echo "Example: "
     echo "   bash> ./analyseStackTrace.sh /gem_test/framos/crcs_cp/bin/RTEMS-mvme2700/crcs-cp-ioc /tmp/StacTracera.txt CSV \n\n"
     exit 0
fi

# Global Variables Definition
fileOutputSed="/tmp/addrStackFile.txt"      # This file will contain the back traces informationa
# The following line should be changed for the user if the addr2line tool for rtems is located
# in other location
addrLine=/gem_base/targetOS/RTEMS/rtems/5/bin/powerpc-rtems5-addr2line  
stackTrace="/tmp/stackTraceFirstFilter.txt"   # File used to filter the important information from stackTrace file
i=0

if [ ! -f "$addrLine" ]; then
	echo "It is necessary the addr2line tool to execute this script."
	echo "Please, change the line 22 to the path to the addr2line where it is on the current PC."
	exit 0
fi

# Getting only the address line from Stack Trace file 
filterStackTrace=`grep -E "(\-\-|Stack)" $filename > $stackTrace`
# Filtering the memories address 
cleanStackTraceCmd=`sed 's/\(Stack Trace:\)\|--^//g' $stackTrace > $fileOutputSed`

# For each memories address we will get the line and function name 
# of the source code. To do this, we run the addr2line command 
# with the options -f and -e. 
while IFS= read -r line
do
   if [ -z "$line" ] ; then
	   continue
   fi
   echo "**** Analizing the following addrs, line($i): $line *****"
   IFS=' ' read -r -a addrList <<< "$line"
   for addr in "${addrList[@]}"
   do
	   opts="-f -e $executableName $addr"
	   addrOutput=`$addrLine $opts`
	   if [ $csv == "csv" ] || [ $csv == "CSV"  ]; then
	      addrOutput2="${addrOutput//$'\n'/,}"
	      echo "$addr,$addrOutput2"
	   else
	      addrOutput2="${addrOutput//$'\n'/}"
	      echo "$addr -> $addrOutput2"
           fi
   done
   ((i++))
	   
done <"$fileOutputSed"
