#!/usr/bin/perl

require Exporter;
@ISA=qw(Exporter CGI_Lite);
BEGIN{unshift(@INC,"./cgi_modules");};

use CGI_Lite;

$sendmaillocation = "/usr/lib/sendmail";
$fromemail= "TennisGroup";
$rname = "tennisgroup\@hotmail.com";
########################################################################
#                     Registration Code                                     #
########################################################################

  $| = 1;
  print "Content-type: text/html\n\n";

  require "./REG.setup";
  require "$location_of_cgi_sol";


#######################################################################
#                        Gather Form Data.                            #
#######################################################################

$cgi = new CGI_Lite ();
%form_data = $cgi->parse_form_data ();

###################################################################
#                   Output Results Header                         #
###################################################################

  print qq!
  <HTML>
  <HEAD>
  <TITLE>$title</TITLE>
  </HEAD>
  <BODY>
<br><font size=+1> Dear $form_data{'name'},</font>
<br><br><font size=+1>  Congratulation\!\!\!</font> 
<br><font size=+1> $form_data{'email'} has been added into tennis mailing\n</font>
<br><font size=+1> list\. In the meantime, a confirmation letter will be sent\n</font>
<br><font size=+1>to your email address\.</font>
<br>
<br><font size=+1> Tennis Coordinator</font>

  <P>!;


  open(MAIL, "|$sendmaillocation -F $fromemail -f $rname -t $form_data{'email'}");
  print MAIL "To: $form_data{'email'}\n";
  print MAIL "Cc: tennisgroup\@hotmail.com\n";
  print MAIL "Bcc: tennis\@www.bacia.org\n";  
  print MAIL "Subject: Confirmation from Tennis Group\n\n";
#  print MAIL "\n\n";
#  print MAIL "\n";
  print MAIL "Dear $form_data{'name'}\,\n";
#  print MAIL "\n\n";
  print MAIL "Congratulation!!!\n";
  print MAIL "Your email address ($form_data{'email'}) has been added into tennis mailing\n";
  print MAIL "list\. You will receive Tennis and other activities announcements\n";
  print MAIL "regularly in the future\.\n\n";
  print MAIL "\n\n";
  print MAIL "\n";
  print MAIL "Tennis Coordinator\n\n";
  close(MAIL);

###################################################################
#                    Edit the Results Data File.                  #
###################################################################

  &GetFileLock ("$lock_file");

  $date = &date;

  open (RESULTS, ">>$results_database") || &CgiDie ("I am sorry, but I
	was not able to open the results data file in the Edit the
	Results Data File routine.  The value I have is $results_database.
	Would you check the path and the permission.");

  print RESULTS "$form_data{'name'}\|$form_data{'email'}\|";
  print RESULTS "$form_data{'ophone'}\|";
  print RESULTS "$form_data{'hphone'}\|$form_data{'acties'}\|$date\n";


  close (RESULTS);

  open (RESULTS, "$results_database") || &CgiDie ("I am sorry, but I
        was not able to open the results data file in the Edit the
        Results Data File routine.  The value I have is $results_database.
        Would you check the path and the permission.");

  while (<RESULTS>)
    {
    push (@unsorted_rows, $_);
    }
  close (RESULTS);

  @reversed_sorted_rows = sort { $a <=> $b } @unsorted_rows;

  @sorted_rows = reverse (@reversed_sorted_rows);

  open (RESULTS, ">$results_database") || &CgiDie ("I am sorry, but I
        was not able to open the results data file in the Edit the
        Results Data File routine.  The value I have is $results_database.
        Would you check the path and the permission.");

  foreach $sorted_row (@sorted_rows)
    {
    print RESULTS "$sorted_row";
    }
  close (RESULTS);
  &ReleaseFileLock ("$lock_file");


#######################################################################
#                       date Subroutine  .                            #
#######################################################################

sub date
{
   @days = ('Sunday','Monday','Tuesday','Wednesday','Thursday',
            'Friday','Saturday');
   @months = ('January','February','March','April','May','June','July',
              'August','September','October','November','December');

   ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

   if ($hour < 10) { $hour = "0$hour"; }
   if ($min < 10) { $min = "0$min"; }
   if ($sec < 10) { $sec = "0$sec"; }

   $date = "$months[$mon] $mday, 19$year";
}
