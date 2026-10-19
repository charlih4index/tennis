#!/usr/bin/perl

#my_input = $ENV{QUERY_STRING};

read(STDIN, $my_input, $ENV{CONTENT_LENGTH});

#print "Content/type: text/plain\n\n$ENV{QUERY_STRING}";
#print "$my_input";

@fv_pairs = split /\&/ , $my_input;

print "Content-type: text/plain\n\n";

foreach $pair (@fv_pairs) {
    if($pair=~m/([^=]+)=(.*)/) {
       $field = $1;
       $value = $2;
       $value =~ s/\+/ /g;
       $value =~ s/%([\dA-Fa-f]{2})/pack("C", hex($1))/eg;
       $INFO{$field}=$value;
    }
}

open(ONE, "> /home/chap/member/$INFO{'email'}")
	or print "can't fork for one: $!=\n";
print ONE << "EOF";
$INFO{'email'}:$INFO{'firstname'}:$INFO{'lastname'}:$INFO{'gender'}:$INFO{'homephone'}:$INFO{'workphone'}:
EOF
close(ONE) or print "Registration failed. Please try again.";

open(MANY, ">> /home/chap/list")
	or print "can't fork for many: $!=\n";
print MANY << "EOF";
$INFO{'email'}:$INFO{'firstname'}:$INFO{'lastname'}:$INFO{'gender'}:$INFO{'homephone'}:$INFO{'workphone'}:
EOF
close(MANY) or print "Registration failed. Please try again.";

$email="$INFO{'email'}";
open(SENDMAIL, "|/bin/mail $email -s 'CHAP: New Member Confirmation' ")
	or print "can't fork for mail: $!=\n";
	
print SENDMAIL << "EOF";

Dear $INFO{'firstname'} $INFO{'lastname'},

    You have registered as a CHAP member now. From now on
you'll receive CHAP's event email.

CHAP Administrator

PS. This email account is unreachable. If you need to contact
    us, please send email to sbaychap\@bigfoot.com.

EOF
close(SENDMAIL) or print "Registration failed. Please try again.";

print "\n";
print "Dear $INFO{'firstname'} $INFO{'lastname'},\n\n";
print "    Welcome to CHAP. A confirmation email has been\n"; 
print "sent to email address $INFO{'email'}.";
print "\n\n\n";
print "CHAP Administrator\n";


