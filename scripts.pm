#!/usr/bin/perl


# Date: Oct 1, 2015 
# Subject: bash Programming Techniques
# Last modified:  Feb 20, 2018
# Author Bahram Z.

# About this program:
# ...................
# This program is llustration for shell scripting techniques,
# that after selecting a shell script from a rotaing list, then
# it will be edited, created in current directory and finally it 
# will be run on local server, showing the output result.
package scripts;
use warnings;
use strict;

#
# Create string variables containing shell scripts, 
# each string will be an element of array @scr
# 
our @scr= (); 

# script no: 1
# #####################################################
# Description: Read a file line-by-one using while loop
# 
# #####################################################
$scr[1] = <<'EOT';
echo
# If you want to read a file, use while loop instead of for loop:
echo 'read a file line-by-line'
echo '========================'
echo
echo  Enter file name with full path name: 
read -r fname
if [[ -e $fname ]] ; 
then
   while IFS= read -r aline; do printf '%s\n' "$aline" ; done < $fname
else
   echo 'The file $fname does not exist!'
fi
# Description:
# 'read' normally allows long lines to be broken using a trailing backslash character, 
# and normally reconstructs such lines. This slightly surprising behavior can be deactivated using -r.
# printf "%s\n" means printing the format string with escape sequence \n ( new line ),
# if it is not used then the lines of file test will be printed all in a single line.

# end of script
EOT





# script no: 2
# #####################################################################
# Description: Store the return value/output of a commant in a variable
# 
# #####################################################################
$scr[2] = <<'EOM';
echo
echo  'Store the output of a command in a variable'
echo  '==========================================='
echo  'Output for ls -l /'
output=$(ls -l /)      # stdout only; stderr remains uncaptured
echo $output
echo
echo  'Output for df -g 2>&1'
output=$(df -g  2>&1) # both stdout and stderr will be captured
echo $output
echo
echo  'Output for cat /etc/os-release'
output=$(cat /etc/os-release)
echo 'The value of the output is:'
echo

echo
# To see the history without the index numbers:
history | tail -5
echo
history | awk '{$1="" ; print $0}' | tail -5

# end of script
EOM





# script no: 3
# ###########################################################
# Description:Show the latest and oldest files in a directory
#  
# ###########################################################
$scr[3] = <<'EOM';
echo
echo 'Show the latest and oldest modified file'
echo '========================================'
echo  Enter the directory name: 
read -r dir
# Check mtime and atime  using the -nt and -ot operators 
# Get latest modified file:
unset -v latest
for file in "$dir"/*; do
  [[ $file -nt $latest ]] && latest=$file
done
echo The latest modified directory is $latest
# Get oldest modified file:
unset -v oldest
for file in "$dir"/*; do
  [[ -z $oldest || $file -ot $oldest ]] && oldest=$file
done
echo The oldest directory modified is $oldest

# end of script 
EOM





# script no: 4
##########################################################################
# Description: password generator
#
##########################################################################
$scr[4] = <<'EOM';
genpass()
{
	echo
	tr -dc 'a-zA-Z0-9_#@.-' < /dev/urandom | head -c ${1:-14}; 
	echo
}

genpass

# end of script
EOM





# script no: 5 
###########################################################################
# Description: a while loop good example
#
###########################################################################
$scr[5] = <<'EOM';
echo
echo Enter two variables

while read var1 var2
do
	echo $var2 $var1
done

# end of script
EOM





# script no: 6
# ######################################################################################
# Description: a for loop good example
#
# ######################################################################################
$scr[6] = <<'EOM';
echo 
for i in one two "three four"
do
	echo "_-_-_-_- $i _-_-_-_"
done
# end of script
EOM





# script no: 7
# ##############################################################
# Description: c style for loop example 
# 
# ##############################################################
$scr[7] = <<'EOM';
echo
for (( i=0 ; i<5 ; i++))
do
	echo $i
done

# end of script
EOM

# script no: 8
# ##############################################################
# Description: select loop example
# 
# ##############################################################
$scr[8] = <<'EOM';
echo
echo Input a number for a choice
select choice in one two "three four"
do
	echo "$REPLY : $choice"
done

# end of script
EOM


# script no: 9
# ##############################################################
# Description: Using select loop with conditional case example
# 
# ##############################################################
$scr[9] = <<'EOM';
echo
echo "select the operation number
---------------------------
1)List of home directory 
2)Disk usage display 
3)OS information 
4)Latest system log"

read n
case $n in
    1) ls -lh ~/ ;;
    2) df -h /;;
    3) cat /etc/os-release;;
    4) tail -10 /var/log/messages;;
    *) free -m;;
esac

# end of script
EOM

# script no: 10
# ##############################################################
# Description: conditional case for pattern matching example
# 
# ##############################################################
$scr[10] = <<'EOM';
echo
case one in
	o)
		echo 'o'
	;;
	o*)
		echo 'o*'
	;;
	*)
		echo 'nope'
	;;
esac

# end of script
EOM

# script no: 11
# ##############################################################
# Description: Run a list of commands in sub shell or in  
#              current sell
# ##############################################################
$scr[10] = <<'EOM';
echo
# Run in subshell
unset x;(x=hello; echo $x); echo $x

# Run list of commands in current shell
unset x;{ x=hello; echo $x }; echo $x

echo 
echo b; echo a | sort
echo
(echo b; echo a) | sort
echo
echo
echo "$(ps wwf -s $$)"
echo
echo "$(echo "$(ps wwf -s $$)")"
echo
echo "$(echo "$(echo "$(ps wwf -s $$)")")"
echo
echo "$(echo "$(echo "$(echo "$(ps wwf -s $$)")")")"
echo
echo These commands have the same output:
echo In subshell there is not any command
echo 'echo "$(</etc/os-release)"' 
echo 'echo "$(cat /etc/os-release)"' 

# end of script
EOM













1;
