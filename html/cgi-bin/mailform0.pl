#!/usr/bin/perl

                         ### *** IMPORTANT *** ###

       ### *** Make sure the path to PERL above is correct *** ###


      #################################################################
      #                                                               #
      #                       Mail Form Ver 1.0                       #
      #                                                               #
      #                              by                               #
      #                        Ranson Johnson                         #
      #                                                               #
      # E-Mail: ranson@rlaj.com                                       #
      #                                                               #
      # Script name: mailform.pl                                      #
      #                                                               #
      # Copywrite 1997/1998 by Ranson's Scripts all rights reserved   #
      # Sale or re-distribution of this program without prior written #
      # permision is prohibited.                                      #
      #                                                               #
      #################################################################


                      ### *** IMPORTANT *** ###

### *** If FTP'ing this file, be sure to send in ASCII format *** ###

# You must chmod the cgi's to 755 
# For information on chmod see Ranson's FAQ's

#  Configure the varialbles in the configuration section below
#    be careful to not disturb the single (') or double quotes (") 
#    surounding each variable, or the semicolon (;) at the end of 
#    each line.


# This program is set up for Unix mail - Sendmail - /usr/sbin/sendmail
#
# And NT mail gateways
#                       blat
#                       windmail
#                       imail
#
# If the mail program is not in the path for your server, then
#
# ASK YOUR SERVER ADMINISTRATOR FOR THE PATH AND NAME OF THE MAIL PROGRAM
#
# We can not help with this.



#             ### *** CONFIGURATION SECTION *** ###


# Enter the operating system for your server
# Unix = '0' 
# NT = '1'
$operating_system = '0';


                      ### *** Mail *** ###


# Where is your servers mail program? 
# (the address below usually works on UNIX)
$mailprog = '/usr/sbin/sendmail';


            ### *** DO NOT CHANGE ANYTHING BELOW*** ###

if (!(-e "$mailprog")) {
&open_error($mailprog);
}

                         ### *** *** ###
                         ### *** *** ###

&parse_data;

            ### *** Check for Required Fields *** ###

if ($FORM{'REQUIRED'} ne "") {
@Required = split(/,/,$FORM{'REQUIRED'});
foreach $field (sort(@Required)) {
&required("$field") unless($FORM{$field} ne "");
 }
}

                 ### *** SEND THE MAIL *** ###

                   ### *** Unix Mail *** ###

if (($operating_system eq '0')) {   

        open (MAIL, "|$mailprog -t -oi -oem");
        print MAIL"Subject: $FORM{'XX-subject'}\n";
        print MAIL"To: $FORM{'XX-send-to-email'}\n";
        print MAIL"From: $FORM{'XX-email'}\n\n";
if ($FORM{'XX-name'}) {
        print MAIL"Name: $FORM{'XX-name'}\n\n";
}
foreach $key (sort(@FORM)) {

    ($key, $val) = split(/=/,$key); 

    # Convert %XX from hex numbers to alphanumeric
    $key =~ s/%(..)/pack("c",hex($1))/ge;
    $val =~ s/%(..)/pack("c",hex($1))/ge;

$key = "$key\n";

if ($key !~ /XX|REQUIRED/) {
print MAIL"$key $val\n\n";
 }
}

close (MAIL);


}elsif (($operating_system eq '1')) {          


                  ## THIS IS WINDOWS MAIL ##

$temp_msg = 'temp.mail';

open (MAIL, ">$temp_msg") || &open_error($temp_msg);
       
   print MAIL <<"PRINT_END_OF_MAIL";
To: $FORM{'XX-send-to-email'}
From: $FORM{'XX-email'}
Subject: $FORM{'XX-subject'}

PRINT_END_OF_MAIL

if ($FORM{'XX-name'}) {
        print MAIL"Name: $FORM{'XX-name'}\n\n";
}
foreach $key (sort(@FORM)) {

    ($key, $val) = split(/=/,$key); 

    # Convert %XX from hex numbers to alphanumeric
    $key =~ s/%(..)/pack("c",hex($1))/ge;
    $val =~ s/%(..)/pack("c",hex($1))/ge;

$key = "$key\n";

if ($key !~ /XX|REQUIRED/) {
print MAIL"$key $val\n\n";
 }
}

close (MAIL);

if ($mailprog =~ /blat/i) {
system("blat.exe \"$temp_msg\" -s \"$FORM{'XX-subject'}\" -f \"$FORM{'XX-email'}\" -t $FORM{'XX-send-to-email'}");
}
elsif ($mailprog =~ /windmail/i) {
system("\"$mailprog\" -t -t -n $temp_msg");
}
elsif ($mailprog =~ /imail/) {
system ("$mailprog -f $temp_msg -s \"$FORM{'XX-subject'}\" -u $FORM{'XX-email'} -t $FORM{'XX-send-to-email'}");
}
unlink ("$temp_msg");

 }


                   ### *** Redirect *** ###

if ($FORM{'XX-redirect-to-url'} ne "") {
print "Location: $FORM{'XX-redirect-to-url'}\n\n";
}else{

           ### *** Just Print Thank You Screen *** ###


    print "Content-Type: text/html\n\n";
    print <<"EOT";

<HTML>
<HEAD>
<TITLE>Mail Sent</TITLE>
</HEAD>
<BODY BGCOLOR=#FFFFFF Link=#0000FF vlink=#1D307E>
<P>
<B><FONT COLOR=000000 SIZE=+2>Thank You</FONT>
<BR>
<FONT COLOR=FF0000 SIZE=+1>Your Mail Has Been Sent</FONT></B>
<P>
&nbsp;
<P>
</BODY>
</HTML>

EOT
        ## DO NOT DISTURB THE LINE ABOVE 
exit;
}


                         ### *** *** ###

sub parse_data {

  local (*FORM) = @_ if @_;
  local ($i, $key, $val);

  # Read in text
  if (&LocalMethGet) 
  {
    $FORM = $ENV{'QUERY_STRING'};
  } 
  elsif (&LocalMethPost) 
  {
    read(STDIN,$FORM,$ENV{'CONTENT_LENGTH'});
  }

  @FORM = split(/[&;]/,$FORM); 

  foreach $i (0 .. $#FORM) 
  {
    # Convert plusses to spaces
    $FORM[$i] =~ s/\+/ /g;

    # Split into key and value
    # splits on the first =
    ($key, $val) = split(/=/,$FORM[$i],2); 

    # Convert %XX from hex numbers to alphanumeric
    $key =~ s/%(..)/pack("c",hex($1))/ge;
    $val =~ s/%(..)/pack("c",hex($1))/ge;

    # Associate key and value 
    # \0 is the multiple separator
    $FORM{$key} .= "\0" if (defined($FORM{$key})); 
    $FORM{$key} .= $val;
  }
  return scalar(@FORM);
 
} # End sub parse


sub LocalMethGet 
# from Steven Brenner's cgi-lib.pl v1.14
# true if this cgi call was using the GET request, false otherwise
{
  return ($ENV{'REQUEST_METHOD'} eq "GET");
}

sub LocalMethPost 
# from Steven Brenner's cgi-lib.pl v1.14
# true if this cgi call was using the POST request, false otherwise
{
  return ($ENV{'REQUEST_METHOD'} eq "POST");
}



                         ### *** *** ###

sub required {

    local ($errorname) = @_;
    $errorname =~ s/XX\-//;
    print "Content-Type: text/html\n\n";
    print <<"EOT";

<HTML>
<HEAD>
<TITLE>Form Error!</TITLE>
</HEAD>
<BODY BGCOLOR=#FFFFFF Link=#0000FF vlink=#1D307E>
<P>
<B><FONT COLOR=000000 SIZE=+2>Form Error</FONT>
<FONT COLOR=FF0000 SIZE=+2>$errorname</FONT></B>
<P>
&nbsp;
<P>
<CENTER>
<B>A Required field on the form has been left blank.
<BR> 
Please go back to the form and check the field.</B>
<P>
<form><input type="button" value="BACK" onClick=history.back()>
<P>
</CENTER>
</BODY>
</HTML>

EOT
        ## DO NOT DISTURB THE LINE ABOVE 
exit;
}

                         ### *** *** ###

sub open_error
    {

    local ($errorname) = @_;
    print "Content-Type: text/html\n\n";
    print <<"EOT";
<HTML>
<HEAD>
<TITLE>Open Error!</TITLE>
</HEAD>
<BODY BGCOLOR=#FFFFFF Link=#0000FF vlink=#1D307E>
<P>
<HR>
<P>
<H1>Error!</H1>
<P>
<H4>The $this_cgi can not find, or is not able to open the 
specified file:</H4>
<H3>$errorname</H3>
<P>
<B>  
Please check the path and file name in $ENV{'SCRIPT_NAME'}.
<P>
Also check the file permissions (chmod) for the file.
<P>
</BODY>
</HTML>

EOT

exit;
} # End sub open_error