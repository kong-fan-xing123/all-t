#
# To restore, type /bin/bash archive
#
echo Extracting color
cat >color <<\THE-END-OF-DATA
#!/bin/bash -x
for STYLE in 0 1 2 3 4 5 6 7; do
  for FG in 30 31 32 33 34 35 36 37; do
    for BG in 40 41 42 43 44 45 46 47; do
      CTRL="\033[${STYLE};${FG};${BG}m"
      echo -en "${CTRL}"
      echo -n "${STYLE};${FG};${BG}"
      echo -en "\033[0m"
    done
    echo
  done
  echo
done
# Reset
echo -e "\033[0m"

# standard colors
for C in {40..47}; do
    echo -en "\e[${C}m$C "
done
# high intensity colors
for C in {100..107}; do
    echo -en "\e[${C}m$C "
done
# 256 colors
for C in {16..255}; do
    echo -en "\e[48;5;${C}m$C "
done
echo -e "\e(B\e[m"

for C in {0..256}; do
    tput setab $C
    echo -n "$C "
done
tput sgr0
echo
THE-END-OF-DATA
echo Extracting sys_info_page
cat >sys_info_page <<\THE-END-OF-DATA
#!/bin/bash -x
# sys_info_page: program to output a system information page
PROGNAME=$(basename $0)
TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME=$(date +"%x %r %Z")
TIMESTAMP="Generated $CURRENT_TIME, by $USER"
report_uptime () {
cat <<- _EOF_
<H2>System Uptime</H2>
<PRE>$(uptime)</PRE>
_EOF_
return
}
report_disk_space () {
cat <<- _EOF_
<H2>Disk Space Utilization</H2>
<PRE>$(df -h)</PRE>
_EOF_
return
}
report_home_space () {
if [[ $(id -u) -eq 0 ]]; then
cat <<- _EOF_
<H2>Home Space Utilization (All Users)</H2>
<PRE>$(du -sh /home/*)</PRE>
_EOF_
else
cat <<- _EOF_
<H2>Home Space Utilization ($USER)</H2>
<PRE>$(du -sh $HOME)</PRE>
_EOF_
fi
return
}
usage () {
echo "$PROGNAME: usage: $PROGNAME [-f file | -i]"
return
}
write_html_page () {
cat <<- _EOF_
<HTML>
<HEAD>
<TITLE>$TITLE</TITLE>
</HEAD>
<BODY>
<H1>$TITLE</H1>
<P>$TIMESTAMP</P>
$(report_uptime)
$(report_disk_space)
$(report_home_space)
</BODY>
</HTML>
_EOF_
return
}
# process command line options
interactive=
filename=
while [[ -n $1 ]]; do
case $1 in
-f | --file) shift
filename=$1
;;
-i | --interactive) interactive=1
;;
-h | --help) usage
exit
;;
*) usage >&2
exit 1
;;
esac
shift
done
# interactive mode
if [[ -n $interactive ]]; then
while true; do
read -p "Enter name of output file: " filename
if [[ -e $filename ]]; then
read -p "'$filename' exists. Overwrite? [y/n/q] > "
case $REPLY in
Y|y) break
;;
Q|q) echo "Program terminated."
exit
;;
*) continue
;;
esac
fi
done
fi
# output html page
if [[ -n $filename ]]; then
if touch $filename && [[ -f $filename ]]; then
write_html_page > $filename
else
echo "$PROGNAME: Cannot write file '$filename'" >&2
exit 1
fi
else
write_html_page
fi

THE-END-OF-DATA
echo Extracting arg
cat >arg <<\THE-END-OF-DATA
bm="$(basename $0)"
if [ "$#" -eq 0 ];then
echo "$bm: no args" 1>&2
exit 2
fi





echo "--------------------------------------"
printf "| arg: %-29.29d |\n" "$#" 
for i in "$@"
 do
 printf "| %-34.34s |\n\a" "$i"; 
done
echo "--------------------------------------"
THE-END-OF-DATA
