*****************************************************
**************  README VOTE.PL  V2.1  ***************
*****************************************************
(c) 13. March, 1999, A. Schnyder, Switzerland, aschnyde@stud.phys.ethz.ch
Please report bugs to: aschnyde@stud.phys.ethz.ch
download 'vote.pl' at: www.datacomm.ch/atair/perlscript/

ATTENTION: 'vote.pl' needs Perl5 or higher!

'Vote.pl' is a perlscript, that saves tha data of different votings and displays the results graphically. You have to write the questions of your voting in a form-section (<form>...</form>). Per voting-form you can ask 26 different questions and per question you can pretend up to 999 selections. Nobody can vote more than once, because 'vote.pl' saves the IP-numbers of the computers or sends a cookie to them. In the 'output_file' you can define the style of the output. With a configuration-file you modify 'vote.pl' according to your wishes.

NEW FEATURES OF VERSION 2.0:

* SEVERAL VOTINGS: Now 'Vote.pl' can process several votings in
   different html-documents. Each voting has a name, that must 
   be written in the config_file.
* IP-CHECKING: 'Vote.pl' saves the IP-numbers of those computers, 
   where somebody has voted from. Therefore it is impossible to 
   vote twice.
* COOKIE-CHECKING: A Cookie is sent to every computer, that has 
   sent the voting-form to the perlscript. If someone tries to
   vote again from the same computer, 'vote.pl' will recoginze 
   and prevent it.(A Cookie is a little file, that will be sent 
   to your browser, if you visit a special site. The browser 
   saves this file on the local harddisk. When this site is 
   loaded again, the Cookie will be posted back to the sender.)
* SHOW RESULT WITHOUT VOTING: You can see the result of the 
   voting, even if you have not voted. 
* REPLACE VOTING-FORM / DISPLAY RESULTS IN A NEW PAGE:
   Now you can choose, whether the result is displayed in a 
   new page or inserted instead of the voting-form in the old 
   page.

If you used an older version of 'vote.pl', you can now skip the following sections an go to 'HOW DO I ADAPT MY OLD FILES TO THE NEW VERSION 2.0?'.

INSTALLATION AND ACCESS-RIGHTS:

Copy the perlscript 'vote.pl' and the file 'config.txt' to the cgi-folder on your server. You have to move the html-file, that contains the questions for the voting (example.html & test.html),  and all pictures to your html-folder. All other files you can save anywehre on your server.  But it is recommended to put them also into the cgi-folder. (That will make the pathnames shorter!)
'Vote.pl' must be executable, and it has to have read/write permissions for those folders, that contain the logfiles (usually 'cgi-bin'). All logfiles and all files, where the IP-numbers are saved in, (examp_logfile.txt & examp_ip.txt), have to be readable and writeable. The other files should be readable.

Now some notes about the installation on a UNIX-Server:
In the UNIX-World each perlscript begins with the pathname of 'perl'. Therefore you must change this path inside 'vote.pl'. Open the perlscript with a texteditor (e.g. emacs, vi) and modify the first line:
	e.g.: #!/usr/bin/perl
Here is an example, how you could change the access-rights of the files. It is the listing of my cgi-folder.

drwxrwxr-x   2 root     root         1024 Feb 15 00:33 .
drwxrwxr-x   6 root     root         1024 Dec 12 01:20 ..
-rw-r--r--   1 nobody   nobody        525 Feb 11 14:43 config.txt
-rw-rw-rw-   1 nobody   nobody         99 Feb  9 09:56 examp_ip.txt
-rw-rw-rw-   1 nobody   nobody         55 Feb 11 14:43 examp_logfile.txt
-rw-r--r--   1 nobody   nobody       3367 Feb  9 17:03 examp_out.html
-rw-r--r--   1 nobody   nobody        280 Feb  9 09:56 examp_voted.html
-rw-r--r--   1 nobody   nobody       2071 Feb  9 20:25 example.html
-rw-r--r--   1 nobody   nobody       9793 Feb 11 14:12 readme.ger.txt
-rw-r--r--   1 nobody   nobody       7511 Feb 15 00:33 readme.txt
-rw-r--r--   1 nobody   nobody       1095 Feb  9 20:19 test.html
-rw-rw-rw-   1 nobody   nobody         27 Feb  9 16:51 test_ip.txt
-rw-rw-rw-   1 nobody   nobody         23 Feb  9 20:14 test_logfile.txt
-rw-r--r--   1 nobody   nobody        871 Feb  9 09:56 test_out.html
-rwxrwxrwx   1 nobody   nobody       8620 Feb  8 12:02 vote.pl

MODIFICATIONS IN THE CONFIGURATION-FILE:

The configuration-file is called 'config.txt' and should be in the same folder as vote.pl. You can change the name of this file and put it into a different folder. But if you want to do that, you will have to change the pathname of your config-file inside 'vote.pl'. Open 'vote.pl' with a texteditor (e.g. wordpad or emacs) and change the path:
	e.g.: $config="new_name_of_config";
You have to add some pathnames and make some modifications in the config-file. The first line of 'config.txt' contains the name of the first voting. This name must be between three asterisk (*). (e.g.: ***name_of_voting***). You can choose any name you want for your voting. But the name you specify in the 'config.txt' must also be in the 'html_file' (see above). With this name `vote.pl` can find out which configurations belong to which voting-form. Now insert the following specifications in 'congig.txt`:

*  html_file: Local pathname of the file, that conatins the
     questions.
*  output_file: Pathname of your file, that describes the 
     output-style.
*  log_file: Path of the logfile.
*  ip_file: Path of the ip_file. The IP-numbers are saved in 
     this file.
*  already_voted_file: Pathname of a file, that will be 
     displayed, when someone tries to vote twice.
*  vote_url: URL of your copy of vote.pl. The same URL should 
     be in the form-section of 'html_file'.
*  checkIP: (false or true) If you want, that 'vote.pl' checks
     the IP-numbers, you have to insert here 'true'. Else 'false'.
*  checkCookie: (false or true) If you want, that a cookie is 
     sent to every user, to prevent multiple voting, insert 'true'. 
     Else 'false'.
*  expiration: After how many days a cookie should expire. If 
     the cookie has expired, it is possible to vote again from the 
     corresponding computer. 
*  replace_form: (false or true) If you want, that the results 
     are displayed in a new page, insert 'false'. If you want, 
     that 'vote.pl' replaces the voting-form with the results, 
     insert 'true'.

Use only slashes (no backslash!) for your pathnames. After the configurations for the first voting, the name of the second voting follows. And after this the configurations for the second voting, etc.

HOW DO I HAVE TO COMPOSE THE FORM-SECTION (<form>...</form>) IN 'html_file'?

Please use 'get' as method. Each line ought to contain only one input-tag (<input type=...name=...>). The groupnames of the radiobuttons must be single lowercase letters in alphabetic order. For the 'values' please use numbers in rising order.
In the first input-tag you specify the name of your voting. For this purpose use the input-type 'hidden'.
e.g.:
	<form action=http://www.your_server.com/cgi-bin/vote.pl method=get>
	<input type="Hidden" name="name" value="name_of_the_voting">
	<b>Best TV serie:</b><br>
		<input type="Radio" name="a" value="1">X-Files<br>
		<input type="Radio" name="a" value="2">Outer Limits<br>
	<b>Best movie:</b><br>
		<input type="Radio" name="b" value="1">Terminator <br>
		<input type="Radio" name="b" value="2">Aliens<br>
		<input type="Radio" name="b" value="3">Titanic<br>
	<input type=submit value="Submit">
	<input type=reset value="Reset">
	</form>
	
HOW CAN I DISPLAY ONLY THE RESULTS OF MY VOTING?

If you want, that 'vote.pl' displays only the results of the voting, you have to execute it with the following extension:

http://your_server.com/cgi-bin/vote.pl?name=name_of_your_voting&action=view

HOW DO I CREATE THE OUTPUT-FILE?

In the file 'output_file' you can define the style of the output. This file must be written in html-Code.You may use the following variables, that stand for the differnet data of the votings:
  
  * $a1; : number of votes for the first element of group 'a'
  * $%a1;: number of votes in percent for the first element of group 'a'
  * $a2; : number of votes for the second element of group 'a'
  * $%a2;: number of votes in percent for the second element of group 'a'
  * $b1; : number of votes for the first element of group 'b'

	etc.

  * $tot; : total votes
  
Every variable begins with a '$' and ends with a semicolon (;).
Those variables will be replaced with the corresponding numbers by the perlscript.

HOW CAN I DISPLAY ONLY THE RESULTS OF MY VOTING?

If you want, that 'vote.pl' displays only the results of the voting, you have to execute it with the following extension:

http://your_server.com/cgi-bin/vote.pl?name=name_of_your_voting&action=view

NOTES ABOUT THE LOGFILE:

Each voting has its own logfile. You have to specify the pathname of the logfile in 'config.txt'. If $logfile does not exist the first time 'vote.pl' is executed, it will be generated automatically by the perlscript. But you can create $logfile also yourself with a texteditor. To that you have to observe the following rules:
	* at the beginning of $logfile you have to write:
		'Total votes:0'
	* the data of the differnet votings is separated by returns
	* the number of votes for the elements of one group 
		are separated by blanks
e.g.:
	Total votes:0
	0 0 0 0
	0 0 0 0 0 0
	0 0
	0 0 0
	
HOW DO I ADAPT MY OLD FILES TO THE NEW VERSION 2.0?	

This section is for those persons, that replace an older version of 'vote.pl' with the version 2.0. Version 2.0 is not back compatible. You have to adapt some files:
* First you have to create the configuration-file (see 'MODIFICATIONS 
  IN THE CONFIGURATION-FILE').
* In the form-section (<form>...</form>) of 'html_file' you have to 
  add this input-tag:
    <input type="Hidden" name="name" value="name_of_the_voting">
  This input-tag sends then name of the voting to the perlscript.
* In the file 'examp_out' you have to add a semicolon (;) to 
  each variable. (e.g.: $a1 --> $a1;)
* Now create the file 'already_voted_file'. This file will be 
  displayed, if someone tries to vote twice.
