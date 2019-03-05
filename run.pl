#!/usr/bin/perl

# Modified: November 7, 2015
# Author  : Bahram Z.

use scripts;
use warnings;
use strict;

# ........................
# Functions used in script 
# ........................
#     runner()  ->    displays the main interface of program, using function listdisplay
# listdispay()  ->    shows program startup
#      start()  ->    finds script selected by number for further operation
#       logo()  ->    startup logo
#    options()  ->    shows available options to user for getting the user input
#    isEmpty()  ->    check only if a directory is empty
#     prompt()  ->    provide a sub-shell environment for user tests 
#     viedit()  ->    vi editor opens files with scripts starting the cursor at disired position
#     manage()  ->    wraps all other sub routines
#    viewstr()  ->    writes string in a temp tile and then opens the file to user
#        msg()  ->    emulates typing of a text with selected speed
#     cmdexe()  ->    simulates typing the commands to be executed and shows the output
#  runscript()  ->    simulates executing disired script
#   editfile()  ->    simulates editing a file with ex editor
#        cmd()  ->    types the command 
# speedcheck()  ->    asks speeds level for typing characters on screen
#     search()  ->    finds the "script no" from the files with a collection of the scripts
# ........................





#
# Function listdisplay() displays the main interface of program.
#
sub listdisplay {
system("clear");


my $line = shift;

my $stline = $line - 1;
my $file = 'list'; 
open (FH, "< $file") or die "Can't open $file for read: $!";

my @lines; 
while (<FH>) { push (@lines, $_); } close FH or die "Cannot close $file: $!";


# Here define iteration of the display loop
my $iter = 5; my $i = $stline;

logo();

print " LIST OF AVAILABLE SCRIPTS:\n";
print " -------------------------\n\n";


   while( ($iter > 0) && ($i <= ($stline + 5)) && ($i <= $#lines) ) { 
      print "$lines[$i]"; $i = $i + 1; $iter = $iter - 1; 
   }

options(); 

}






#
# Function runner() displays the main interface of program, using function listdisplay,
# and the conditions for user input
#
sub runner {
system("clear");

my $file = 'list'; 
open (FH, "< $file") or die "Can't open $file for read: $!";

my @lines; 
while (<FH>) { push (@lines, $_); } close FH or die "Cannot close $file: $!";

my $i = 1;

while ($i <= $#lines) {
   listdisplay($i);

   my $input = <STDIN>; chomp($input);

   # CONDITIONS FOR USER INPUT   
   if ($input eq 'b') { exec($^X,$0); }
   elsif ($input eq 'q')  {
      if (-e 'temp' and -d 'temp'){
      print "\n Clear memory?\n [y] to delete, other keys to keep: ";
      my $a = <STDIN>; chomp($a); my $dir = 'temp'; system("rm -rf $dir")  if ($a eq 'y'); }
      print "\nExiting Program ... \n\n"; exit; 
   }

   #elsif ($i > $#lines) { exec($^X,$0); }
   elsif ( ($input =~ /[[:digit:]]$/ ) && ($input != 0) ){ start($input, \@scripts::scr); }
   elsif ( $input eq 'es' ) {  
      system ("clear"); logo(); print "\n Enter number of script to be edited: ";
      my $num = <STDIN>; chomp($num); my $match = "# script no: $num";
      #viedit("./scripts.pm", $match) if ($num =~ /^[[:digit:]]$/); 
      if ($num =~ /[[:digit:]]$/) { viedit("./scripts.pm", $match) ; exec($^X,$0); }
   }
   elsif ( $input eq 'el' ) { system("vi list"); } 
   elsif ( $input eq 's' )  {
      system ("clear"); print " --- Shell Prompt ---\n Enter [q] to abort\n"; print " ..................\n";
      prompt("echo"); 
   } 
   elsif ($input eq 'l')  { 
      system ("clear");
      print " Content of memory:\n"; print " .........................\n"; 
      if( -d "./temp/" and -e "./temp/" and !(isEmpty('temp')) )  { system("ls -1 ./temp/ | sed 's/^/ /'"); }
      else { print " Directory is empty!\n"; }
      print "\n\n Press any key to go back ... "; my $in = <STDIN>;  
   } 
   elsif ( ($input eq 'd') ) { system("rm -rf temp"); 
      print "\n Memory cleared! "; 
      system ("sleep 2"); #exec($^X,$0); 
   }

$i=$i+1;
if ( $i >= $#lines + 1 ) { exec($^X, $0); }
}

}






#
# Function start() gets script number and a string containing 
# the body of a script, then manage that script.  
#
sub start {
my $dir = "temp"; unless(-e $dir and -d $dir) { mkdir($dir) or die "Unable to create $dir\n"; }
my ($i, $arr_ref) = @_;
my @arr = @$arr_ref;
my $scriptfile = './temp/script-' . $i . '.sh';
my $selected = $arr[$i];
my $scrno = $i;
manage($selected, $scrno, $scriptfile);
}





#
# Function logo() prints out the program header
#
sub logo {
        system("clear");
        use POSIX qw(strftime); 
        my $date = strftime "%Y-%m-%d", localtime; 
        my $time = strftime "%H:%M:%S", localtime;

        print " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
        print " BASH SCRIPTS REPOSITORY MANAGER\n";
        print " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
        print " $date             $time\n\n";
}





#
# Function options() prints out the program header
#
sub options {
        my $cnt; open(FH,'list') or die "Damn. $!";
        while (<FH>) { $cnt++ if  !/^\s+?$/;} close FH;
        print "\n\n ...... MENU COMMANDS ......\n";
        print "   [Enter] - loop over the list\n"; 
        print "   [1..$cnt] - index number of the scripts\n";
        print "      [es] - edit embeded scripts in main program\n";    
        print "      [el] - edit above list\n"; 
        print "       [s] - shell prompt tool\n";
        print "       [l] - list of edited script in memory\n";
        print "       [d] - clear memory\n";
        print "       [b] - back to start of the list\n";     
        print "       [q] - quit program\n\n > ";
}





#
# Function isEmpty checks if a directory is empty or not.
#
sub isEmpty{
  my ($dir) = @_;
  my $file;
  if (opendir my $dfh, $dir){
     while (defined($file = readdir $dfh)){
        next if $file eq '.' or $file eq '..';
        closedir $dfh;
        return 0;
     }
     closedir $dfh;
     return 1;
  }else{
     return -1;
  }
}





#
# Function prompt() provides a prompt to run command 
# 
sub prompt {
   my $init = shift;
   system ("echo"); system("$init");
   print " >>> "; 
   my $cmdin = <STDIN>; chomp($cmdin); system ("$cmdin") unless($cmdin eq "q");
   prompt("echo") unless($cmdin eq "q");
}





# 
# Function viedit() opens a vi editor at a line number which 
# that line matches  with a string 
#
sub viedit {
my ($f,$m) = @_;

sub getlinenumber {
my ($filename, $text) = @_;
open(my $fh, "< $filename") or die "Could not open file '$filename' $!";
 
my @line_num = ();    
while (<$fh>) { if ( /$text/ ) { my $num .= $.; push @line_num, $num; last; } } 
close $fh; return($line_num[0]); }

my $n = getlinenumber($f, $m); system ("vi +$n $f"); 
}





#
# Function manage() wraps other subroutins to manage a script. 
# 
sub manage {
my ($exstr, $scrno, $exfile) = @_;

my $speed = speedcheck($exstr, $scrno);
print "\n";
editfile($exfile, $exstr, $speed);
print "\n ..........................................................\n";
print " Script file \'$exfile\' created in 'temp' folder!\n Click [Enter] to execute ... ";
my $pause = <STDIN> ; system ("clear");
system("chmod +x $exfile");
my $cmd = "$exfile ";

if ( $exstr =~ /This script has command line arguments/g ) 
   {
        system ("$cmd ");
        print "\nEnter arguments: "; 
        my $args = <STDIN>; chomp($args);
        $cmd .= $args;
        cmdexe("$cmd", $speed);
        
   }
else {
cmdexe("$cmd", $speed);
}
print "\n\n....................\n";
print "Execution completed!\nClick [Enter] to continue ... ";
my $pause3 = <STDIN> ; system ("clear"); exec($^X,$0);
}





#
# Function viewstr() writes a string into a temp file and then can be viewed via command less
#
sub viewstr {
my $str = shift;

open (my $fh, '<', \$str ) or die "Can not open $str for read: $!";
my @lines;
while (<$fh>) { push (@lines, $_); } close $fh or die "Cannot close $str: $!";

my $i = 0;
while ($i <= $#lines) {

        system("clear");
        print "..................\n";
        print "Scrip quick view :\n";
        print "..................\n";
        my $iter = 20;     # number of lines to be displayed in every page

        while( ($iter > 0) && ($i <= $#lines) )
        {
            print "$lines[$i]";
            $i = $i + 1;
            $iter = $iter - 1;
        }
            print "\n..............................\n";
            print "[q] quit , [Enter] view more : ";
            my $qst = <STDIN>;  chomp($qst);
	    	# open(TTY, "+</dev/tty") or die "no tty: $!"; system "stty  cbreak </dev/tty >/dev/tty 2>&1"; my $qst = getc(TTY); close(TTY);        
            if( $qst eq 'q' ) { system ("clear"); exec($^X,$0); }
            elsif( $i > $#lines ) { viewstr($str); }
}
}





#
# Function msg emulates typing of a text with specific speed
#
sub msg {
    my $str = shift;
    my $speed = shift; chomp($speed);
    my $s1 = 0;
    my $s2 = 0;
    my $s3 = 0;

    if    ($speed == 1) { $s1 = 0.400; $s2 = 3; $s3 = 4; }
    elsif ($speed == 2) { $s1 = 0.300; $s2 = 2; $s3 = 3; }
    elsif ($speed == 3) { $s1 = 0.200; $s2 = 1; $s3 = 2; }
    elsif ($speed == 4) { $s1 = 0.100; $s2 = 0; $s3 = 1; }
    elsif ($speed == 5) { $s1 = 0.001; $s2 = 0; $s3 = 0; }
                  else  { $s1 = 0.200; $s2 = 2; $s3 = 3; }

    my $i = 0;
    my @chars = map substr( $str, $_, 1), 0 .. length($str) -1;

    for(@chars) 
    { 
        if ( $i eq 0 ) { select(undef, undef, undef, rand($s3)); }
        print;
        select(undef, undef, undef, rand($s1));
        if ($i eq ($#chars-1)) { select(undef, undef, undef, rand($s2)); }
        ++$i;
    }

}
                                                                        


#
# ### Function cmdexe #
#
sub cmdexe {
use IO::Handle; STDOUT->autoflush(1);

my $str = shift;
my $speed = shift;

# cases where the prompt sign is not printed
unless ($str=~/^(#4)|^(#3)|^(#2)|^(#1)/) { print "# "; }

# cases where typing the value of the string will be emulated
# the folloeing conditional statments is true when a line starts with "# "
#unless ($str=~/^(#1)|^(#2)|^(#3)|^(#4)|^(#5)|^(tput)/){
unless ($str=~/^(#\d)|^(tput)/) { msg($str, $speed); }


# From here on, avoid having a return to new line, after each execution
use IO::Handle; STDOUT->autoflush(1);

if ($str =~ /^\s*$/) { system(""); }                                        # if we have a blank line 
elsif (($str !~ /^#/) and ($str !~ /^\s*$/ )) {system("bash $str");}             # execute command  
elsif ($str=~/^(#6)/) { $str =~ s/^(#6)//g ; system ("perl -e '$str'"); }   # (6) perl executes string
elsif ($str=~/^(#5)/) { $str =~ s/^(#5)//g ; print $str; }                  # (5) print only command, not the output of command
elsif ($str=~/^(#4)/) { $str =~ s/^(#4)//g ; print $str; }                  # (4) print only a line with no hash sign
elsif ($str=~/^(#3)/) {}                                                    # (3) commenting out inside the source code file
elsif ($str=~/^(#2)/) { $str =~ s/^(#2)//g ; system("$str"); }              # (2) only print output of command
elsif ($str=~/^(#1)/) {                                                     # (1) only run a command in background
        $str =~ s/^(#1)//g ;
        open (my $STDOLD, '>&', STDOUT);
        open (STDOUT, '>>', '/dev/null');
        system($str);
        open (STDOUT, '>&', $STDOLD);
}

}



#
# Function runscript, simulates running a script with a specific speed
#
sub runscript {
my $file = shift;
my $speed = shift;

open (my $infile, "<" , $file) || die "Could not open $file: $!";

my $outputfilename = $file.'.bak';
open (my $outfile, ">" , $outputfilename) || die "Could not open $file: $!";
	
	while(<$infile>)  {
		next if (/<!--/ .. /-->/);
		print $outfile $_;
	}

close $infile; close $outfile;


open my $SCRIPT, $outputfilename or die "Could not open $file: $!";
my @arr;
while( my $line = <$SCRIPT>)  {

     unless(($line =~ /^(#0)/))
       {
          cmdexe($line, $speed);
       }
    
      else {
              $line =~ s/^(#0)//g; push (@arr, $line);
              open my $fh, '>>', "output.txt" or die "Cannot open output.txt: $!";
              if ($line =~ /(######)/)
                {
                  pop @arr;
                  foreach (@arr){ print $fh "$_"; }
                  close $fh; system ("bash output.txt"); 
                  @arr = (); unlink "output.txt";               
               }
         }
}
close $SCRIPT;
unlink $outputfilename if (-e $outputfilename);
}





#
# Function 'editfile' is used to edit a file with some content
# specified as argument for the function.It also simulates the
# ex editor command on screen
#
sub editfile {
my $file = shift;
my $content = shift;
my $speed = shift;

cmd ("ex $file");

open ( MYFILE, '>', $file ) or die "File cannot be created!\n";
print MYFILE $content;
close (MYFILE);

use File::Basename;
my $f = basename($file);
my $ex = "
\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
$f [New File]
Entering Ex mode.  Type \"visual\" to go to Normal mode.
";
print "$ex";
print ": ";
msg("% change", $speed);
sleep 1; print "\n";
msg($content, $speed);
print ": "; msg ("x", 1); sleep 1; print "\n\n";
}





#
# Function cmd("string") types characters of a string
# as if being typed with a typewriter
# Used for typing commands
#
sub cmd {
use IO::Handle; STDOUT->autoflush(1);

my $str = shift;
my @chars = map substr( $str, $_, 1), 0 .. length($str) -1;
print "# "; select(undef, undef, undef, 0.60); #50
print "\n# "; select(undef, undef, undef, rand(0.60)); #40
print "\n# "; select(undef, undef, undef, rand(0.60)); #40

my $i = 0;
for(@chars) {
         print;
         if ($i eq ($#chars)) {sleep 1;}
         select(undef, undef, undef, rand(0.15)); #40
         ++$i;
         }

use IO::Handle; STDOUT->autoflush(1);
#print "\n";
#select(undef, undef, undef, 0.60); #50
}





#
# 'speedcheck' asks the speed level from user
# and returns the speed value.
#
sub speedcheck{
    my ($str, $scrno) = @_;
    system ("clear");
    my $file = 'list';
    open (FH, "< $file") or die "Can't open $file for read: $!";
    my @lines; while (<FH>) { push (@lines, $_); }
    close FH or die "Cannot close $file: $!";
    my $scrdesc = "$lines[$scrno-1]";
    chomp ($scrdesc);
    print " You selected scrip:\n$scrdesc\n\n";
    print " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
    print " Select desired edit speed to create script file,\n";
    print " or just 'run'  or  'view' the content of script.\n";
    print " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
    print " 1) Slow\n 2) Normal\n 3) Fast\n 4) Faster\n 5) Fastest\n\n [b] Back to main list\n";
    print " [r] Run\n [v] View\n\n > ";

   # open(TTY, "+</dev/tty") or die "no tty: $!"; system "stty  cbreak </dev/tty >/dev/tty 2>&1";
   # my $speed = getc(TTY); close(TTY); 
   my $speed = <STDIN>; chomp($speed); 

    if ($speed eq 'r') {
       my $directory = './temp'; 
       unless(-e $directory or mkdir $directory) { die "Unable to create $directory\n"; }
       my $filename = './temp/tempscript.sh';
       open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
          my @strarr = split /\n/, $str;
          foreach my $line(@strarr) { print $fh "$line\n"; }
       close $fh;

       system("chmod +x $filename");
       my $cmd = "$filename ";

	       if ( $str =~ /This script has command line arguments/g )
       		{
        	 system("clear"); system ("$cmd ");
        	 print "\nEnter arguments: "; my $args = <STDIN>; chomp($args);
        	 $cmd .= $args;
                 system ("clear"); cmdexe("$cmd", 3);
                 print "\n\n....................\n";
       		 print "Execution completed!\nClick [Enter] to continue ... ";
          	 my $pause3 = <STDIN> ; system ("clear"); exec($^X,$0);
                }
       		else 
       		{
                 system ("clear"); cmdexe("$cmd", 3);
                 print "\n\n....................\n";
          	 print "Execution completed!\nClick [Enter] to continue ... ";
          	 my $pause3 = <STDIN> ; system ("clear"); exec($^X,$0);
       		}  
    }
    
    elsif ($speed eq 'v') { 
       viewstr($str);
    }

    #elsif ($speed eq 'q') { print "\n\n Terminating program ... \n"; exit; }
    elsif (($speed == 1) || ($speed == 2) || ($speed == 3) || ($speed == 4) || ($speed == 5)) { return $speed; }
    elsif ($speed eq "b") {exec($^X,$0);}
    else { speedcheck($str, 3); }
};

sub search {
my $str = <STDIN>; chomp $str;
system "grep -E 'Description:|script no:' scripts.pm > tmp.txt";

};

#run();
runner();
