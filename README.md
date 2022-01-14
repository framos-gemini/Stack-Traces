# Stack-Traces
This bash script helps to get the line, the fileName and functionName for each address in the Stack Traces. The script uses addr2line tools to do that. 

By default the addr2line tool for rtems is being used. Inside the docker container this is located in/gem_base/targetOS/RTEMS/rtems/5/bin/powerpc-rtems5-addr2line. In case you want to use it for linux, you would have to change line 22 of analyzeStackTrace.sh to the addr2line path. For example:
   - which addr2line
   - Copy the path and paste it into line 22 of the script. 

## Execution.
The script is executed as follows: ./analyseStackTrace \<pathToBinaryFile\> \<pathToStackTraceFile\> [CSV] 
Parameters:
  - **pathToBinaryFile**: non-optional parameter. Path to the executable file, i.e. the binary file of your application. For example, the crcs binary file it would be /gem_test/framos/crcs_cp/bin/RTEMS-mvme2700/crcs-cp-ioc
  - **pathToStackTraceFile**: Non-optional parameter. Path to the file containing the Stack Trace copied from the telnet. A small excerpt is pasted below. See example file /tmp/StacTracer.txt for more details.
  - **CSV**: Optional parameter. This parameter is used to export the result to CSV format. It will allow you to copy it to an excel sheet and send it in a more readable format to other colleagues.  
