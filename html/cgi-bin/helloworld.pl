#!/usr/bin/perl
# helloworld.pl
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$now=localtime(time);
print ("Content-type: text/html \n\n");
print ("Hello World.");
print ("Time is $now");
print time;
print ("sec=$sec\n\n");
print ("min=$min\n");
print ("hour=$hour\n");
print ("mday=$mday\n");
print ("mon=$mon\n");
print ("year=$year\n");
print ("wday=$wday\n");
print ("yday=$yday\n");
print ("isdst=$isdst\n");
