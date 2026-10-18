#!/usr/bin/perl
#############################################
############## VOTE.PL V2.1   ###############
#############################################
#(c) 13. March, 1999 A. Schnyder, Switzerland
# aschnyde@stud.phys.ethz.ch
#get the latest version of 'vote.pl' at: http://www.datacomm.ch/atair/perlscript/
#ATTENTION: 'vote.pl' needs Perl5 or higher!
#Modified for http://tennis.bacia.org by Charlih Chen on 08/16/1999

require 5.000;

print "Content-type: text/html\n";

### CHANGE THE PATHNAME OF $config HERE:
$config="config.txt";
### CHANGE THE PATHNAME OF $config ABOVE.
 
### Declaring four subprograms.
sub printError {
		$errtmp=$_[0];
		print "\n\n"; #Separating header from content
		print "<HTML>\n";
		print "<br><font color=red>PerlScript: $errtmp\n</font>";
		exit;
} 
sub ipcheck { 
		$thisip=$_[0]; 
		if (!(-e $ipfile)) {if (!open(handle14, ">$ipfile")) {printError("ERROR writing $ipfile.");}close handle14;} 
		if (!open(handle15, "$ipfile")) {printError("ERROR reading $ipfile.");} 
		while(<handle15>) { 
			if (/$thisip/) { 
				if (!open(handle16, "$alr_voted_file")) {printError("ERROR reading $alr_voted_file.");} 
				print "\n\n"; #Separating header from content
				while(<handle16>){ 
					print; 
				} 
				close handle16; 
				exit; 
			} 
			$lasttmp=$_; 
		} 
		close handle15; 
		if (!open(handle15, ">>$ipfile")) {printError("ERROR appending $ipfile.");} 
		if (length($lasttmp)>80) {print handle15 "\n";} 
		print handle15 "$thisip "; 
		close handle15; 
} 
sub cookie_check {
		$ctmp='';
		@daytmp=('Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday','Saturday');
		@monthtmp=('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
		if ($cookie_string=~/votepl_$Query{name}=voted/) {
			if (!open(handle16, "$alr_voted_file")) {printError("ERROR reading $alr_voted_file.");} 
				print "\n\n"; #Separating header from content
				while(<handle16>){ 
					print; 
				} 
				close handle16; 
				exit; 
			}
			else {

				$_=$serverPath;
				if (!/.*http:\/\//i) {printError("Error. $serverpath must contain the characters \'http://\'");}
				$_=$';
				if (/www/i) {$_=$';}
				/\/.*/;
				$domain=$`; 
				$_=$&;
				while (/\/.*\//){
					$ctmp.=$&;
					$_=$';
				}
				$datetmp = time+24*3600*$key_settings{expiration};
				$expiration = $daytmp[(gmtime($datetmp))[6]];
				$expiration = $expiration .+ ', ' .+ (gmtime($datetmp))[3] .+ '-' .+ $monthtmp[(gmtime($datetmp))[4]] ;
				$ytmp=(gmtime($datetmp))[5]+1900;
				$expiration = $expiration .+ '-' .+ $ytmp .+ ' 00:00:00 GMT';
			 print "Set-cookie: votepl_$Query{name}=voted;expires=$expiration;domain=$domain;path=$ctmp\n\n";
		}
}									
sub creating_logfile {
		print "<font color=red>Creating a new $logfile...</font>\n";
		if (!open(handle3, ">$logfile")) {printError("ERROR writing $logfile.");}
		print handle3 "Total votes:" .+ "0" .+ "\n";
		$tmp_value=1;
		$tmp_name=97;
		while (<handle>) {
			 if (/form+/) {if (!seek(handle,-30,1)) {printError("ERROR seeking $logfile.");} last;}
				$tmp1= 'name=\"' .+ chr($tmp_name) .+ '\"';
				$tmp2= 'value=\"' .+ $tmp_value .+ '\"';
				if (/$tmp1/i && /$tmp2/i) {
						print handle3 "0 ";
						$tmp_value++
				}
				$tmp1= 'name=\"' .+ chr($tmp_name+1) .+ '\"';
				if (/$tmp1/i && /value=\"1\"/i) {
						if ($tmp_value==1) {printError("ERROR first groupname must be \"a\"\n");}
						print handle3 "\n0 ";
						$tmp_value=2;
						$tmp_name++;
				}
		}
		print handle3 "\n";
		close handle3;
}

### Mainsequence of vote.pl.


###Initializing some variables
$tmp=0;
$set_trig=0;
$i=0;
@tot=();

###Getting http-DATA.
@QueryArray=();
@QueryKey=();
%Query=();
$QueryString=$ENV{'QUERY_STRING'};
$client_addr=$ENV{'REMOTE_ADDR'};
$cookie_string=$ENV{'HTTP_COOKIE'};
@QueryArray=split '&',$QueryString;
foreach(@QueryArray){
		($key, $val) = split ('=',$_);
  $Query{$key} = $val;
}
@QueryKey=keys(%Query);
if ($Query{action}=~/view/i){$view_flag=true;}
else {$view_flag=false;}

### Getting all settings from $config
### Number of settings for each voting:10
$ns=10;
@settings=();
@settemp=();
if (!open(filehandle1,$config)) {printError("ERROR reading $config\n");}
while (<filehandle1>) {
		push(@settings,$_);
}
close (filehandle1);
if ($#settings<$ns) {printError("ERROR $config seems to be empty. Please configure vote.pl with $config.\n");}
if (($#settings+1)%($ns+1) != 0) {printError("ERROR in config-file: $config. Too many (not enough) parameters defined.");}
for ($i=0;$i<$#settings;$i+=($ns+1)) {
		@settemp=split ('\*\*\*',$settings[$i]);
		if ($Query{name} eq $settemp[1]) {
				$confnum=$i;
				$set_trig=1;	last;
		}
}
if ($Query{name} eq '') {printError("ERROR. HTTP-Query must contain a 'name=...'.");}
if ($set_trig == 0){printError ("ERROR. There's no entry in config-file:$config for this name. Please add your name in the config-file.");}
for ($i=$confnum;$i<($confnum+$ns+1);$i++){
		($key, $val) = split (':\s',$settings[$i]);
		$val=~ s/\s+//g;
		$key_settings{$key} = $val;
}
$htmlfile=$key_settings{html_file};
$htmlout=$key_settings{output_file};
$logfile=$key_settings{log_file};
$ipfile=$key_settings{ip_file}; 
$alr_voted_file=$key_settings{already_voted_file};
$serverPath=$key_settings{vote_url}; 
$replace=$key_settings{replace_form};
if (($key_settings{checkCookie} =~ /true/i) && ($view_flag eq "false")){cookie_check;} 
print "\n\n"; #Separating header from content
if (($key_settings{checkIP} =~ /true/i) && ($view_flag eq "false")) {ipcheck($client_addr);} 

###Heart of vote.pl
##Printing the beginning of $htmlfile to the screen.
if ($replace =~ /true/i) {
	if (!open(handle,$htmlfile)) {printError("ERROR reading $htmlfile");}
	while (<handle>) {
			if (/form.*action.*$serverPath/i) {$tmp=1;last;}
			print;
	}
	if (!$tmp) {printError("ERROR $htmlfile does not contain the specified serverpath: $serverPath.\n");}
}
##Openging $logfile and storing all data in $votes
@votes=();
if (!(-e $logfile)) {print "<br><font color=red>PerlScript: ERROR $logfile does not exist.\n</font>"; creating_logfile();}
if (!open(handle2,$logfile)) {printError("ERROR reading $logfile\n");}
$_=<handle2>; 
if (/Total votes:/){
		$total=$';
		$total=~ s/\n//g;}
else {
		printError("ERROR reading 'Total votes' in $logfile.\n");}
@zwsp=();
while(<handle2>){
		push(@zwsp,$_);
}
$i=0;
foreach $logtmp (@zwsp) {
		@tmp=();
		@tmp=split ' ',$logtmp;
		$j=0;
		@votes[$i]=();
		foreach $t (@tmp) {
				$votes[$i][$j] =$t;
				$tot[$i]+=$t;
				$j++;
  }
		$i++;
}
close handle2;
if ($i>26) {printError("ERROR too many groups!\n");}
if ($view_flag eq "true") {goto REPLACE};
$total++;
##Treating $QueryString
foreach $curr_key (@QueryKey) {
		if ((lc($curr_key) eq 'name')|| (lc($curr_key) eq 'action')) {next;}
		$curr_val=$Query{$curr_key};
		if ((ord($curr_key)<97) || (ord($curr_key)>96+$i) || ($curr_key =~ /../)) {
				printError("ERROR reading querystring. Wrong groupname: $curr_key. (If you changed your voting-form, you also have to modify or
						delete the logfile. For details please read the README.)");}
		if (($curr_val !~ /\d/) || ($curr_val == 0) || ($curr_val =~ /..../) || ($votes[ord($curr_key)-97][$curr_val-1] eq '')) {
				printError("ERROR reading querystring. Wrong name of groupelement: $curr_val. (If you changed your voting-form, you also have to modify
					 or delete the logfile. For details please read the README.)");}
		$votes[ord($curr_key)-97][$curr_val-1]++;
		$tot[ord($curr_key)-97]++;
}
##Writing $logfile
if (!open(handle3, ">$logfile")) {printError("ERROR writing $logfile\n");}
print handle3 "Total votes:" .+ $total .+ "\n";
for($k=0;$k<$i;$k++){
		$j=0;
		@tmp=();
		while ($votes[$k][$j] ne ''){
				push(@tmp,$votes[$k][$j]);
				$j++;
		}
		$logtmp=join ' ', @tmp;
		print handle3 "$logtmp\n";
}
close handle3;
REPLACE:
##Replacing the variables inside $htmlout
if (!open(handle4, $htmlout)) {printError("ERROR reading $htmlout\n");}
while(<handle4>) {
	while(m/\$.{2,5}\;/g) {
		if (substr($&,1,1) eq '%') {
			$group_tmp=substr($&,2,1);
			$val_tmp=substr($&,3,length($&)-4);
			$ttmp=ord($group_tmp)-97;
			if ($votes[$ttmp][$val_tmp-1] ne ''){
				if ($tot[$ttmp] != 0){
					$pctmp=int($votes[$ttmp][$val_tmp-1]/$tot[$ttmp]*1000+0.5)/10;}
				else{
					$pctmp=0;}
				$match_tmp='\\'.+ $&;
				s/$match_tmp/$pctmp/;
				}
			}
		elsif (substr($&,1,length($&)-2) eq 'tot'){
			s/\$tot;/$total/;
			}
		else {
			$group_tmp=substr($&,1,1);
			$val_tmp=substr($&,2,length($&)-3);
			$ttmp=ord($group_tmp)-97;
			if ($votes[$ttmp][$val_tmp-1] ne ''){
				$match_tmp='\\'.+ $&;
				s/$match_tmp/$votes[$ttmp][$val_tmp-1]/;
			}
		}
	}
	print;
}
close handle4;
##Writing the rest of $htmlfile to the screen.
if ($replace=~ /true/i){
	while (<handle>) {
			get;
 		last if /form+/;
	}
	while (<handle>) {
		print;
	}
	close handle;
}
exit;
