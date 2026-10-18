*****************************************************
**************  README VOTE.PL V2.1   ***************
*****************************************************
(c) 13. March 99, A. Schnyder, Schweiz, aschnyde@stud.phys.ethz.ch
Bitte melde Bugs an: aschnyde@stud.phys.ethz.ch
Die neuste Version von vote.pl ist erhaeltlich unter: www.datacomm.ch/atair/perlscript

ACHTUNG: 'vote.pl' benoetigt Perl5 oder hoeher!

Vote.pl ist ein Perlscript, das die Daten von verschiedenen Abstimmung speichert und
die Resultate graphisch darstellt. Die Fragen zu einer Abstimmung werden in einen
Formularblock (<form>...</form>) geschrieben. Pro Abstimmungsformular koennen bis zu 26
verschiedene Fragen gestellt und pro Frage bis zu 999 Auswahlmoeglichkeiten angegeben 
werden. Dank IP-Checking und Cookies ist mehrmaliges Abstimmen unmoeglich. Im output-File
kannst du bestimmen, wie die Resultate grafisch dargestellt werden. Mit demKonfigurations-
file passt du 'vote.pl' deinen eigenen Wuenschen an.

NEUE FEATURES DER VERSION 2.0:

* MEHERER ABSTIMMUNGEN: Neu kann 'vote.pl' mehrere Abstimmungen gleichzeitig verwalten. 
   Jede Abstimmung erhaelt einen Namen, der auch in der Konfigurationsdatei stehen muss.
* IP-CHECKING: Das Perlsript speichert die IP-Nummer der Computer, von denen aus bereits    
   abgestimmt wurde. Dadurch kann mehrmaliges Abstimmen vermieden werden.
* COOKIE-CHECKING: 'Vote.pl' sendet an jeden Computer, der Abstimmungsdaten abgeschickt   
   hat, ein Cookie. Falls von demselben Computer aus erneut abgestimmt wird, so kann dies 
   anhand des Cookies festgestellt und verhindert werden.
	  (Ein Cookie ist eine kleine Datei, die beim Aufsuchen einer bestimmten Internet-Seite 
   an den Browser (z.B. Netscape) gesendet wird. Dieser speichert die Datei ab auf der 
   lokalen Festplatte. Wenn diese Seite erneut geladen wird, schickt der Borwser das 
   Cookie an den Absender zurueck.)
* NUR RESULTATE ANZEIGEN: Du kannst nur die Resultate anzeigen lassen, ohne dass vorher
   abgestimmt werden muss.
* ABSTIMMUNGSFORMULAR ERSETZEN / NEUE SEITE ANZEIGEN: Die Ergebnisse werden entweder  
   anstelle des Abstimmungsformulars in der alten Seite, oder in einer neuen Seite 
   angezeigt.

Wenn du schon eine aeltere Version von 'vote.pl' benutzt hast, kannst du jetzt direkt 
gehen zu 'WIE PASSE ICH MEINE ALTEN FILES AN DIE NEUE VERSION 2.0 AN?'.

INSTALLATION UND ZUGRIFFSRECHTE

Das Perlscript 'vote.pl' und die Datei 'config.txt' wird in den cgi-Ordner auf dem Server
kopiert. Das html-Dokument, das die Abstimmungsfragen enthaelt (example.html & test.html),
sowie alle Bilder legst du in den html-Ordner. Alle anderen Files kannst du sonst 
irgendwo auf dem Server speichern. Es ist jedoch am einfachsten, wenn du sie auch in den 
cgi-Ordner kopierst. 
Achte darauf, dass 'vote.pl' ausfuehrbar ist und schreib/lese-Berechtigung besitzt. Alle
Logfiles und die Dateien, in denen die IP-Nummern gespeichert werden, (examp_logfile.txt 
& examp_ip.txt) sollten lesbar und  ueberschreibbar sein. Fuer die uebrigen Files genuegt
die Lese-Berechtigungn.

Hier nun noch einige Bemerkungen zur Installation auf einem UNIX-Server:
Unter Unix muss jedes Perlscript in der ersten Zeile den Pfadnamen von Perl enthalten.
Oefnne also 'vote.pl'  mit einem Texteditor (z.B. emacs) und aendere in der ersten Zeile 
den Pfadnamen:
    z.B.: #!/usr/bin/perl
Es ist ueblich, dass alle Files im cgi-Ordner den Owner 'nobody' haben. Aendere dies 
bitte mit 'chmod'. Als Beispiel, wie man die Zugriffsrechte setzen koennte, ist hier das 
Listing meines cgi-Ordners abgebildet:

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

EINSTELLUNGEN IN DER KONFIGURATIONSDATEI:	

Die Konfigurationsdatei heisst 'config.txt' und befindet sich im gleichen Ordner wie 
'vote.pl'. Du kannst jedoch den Namen dieser Datei aendern und sie an einem andern Ort 
abspeichern.  Wenn du dies moechtest, musst du aber auch den neuen Pfadnamen der 
Konfigurationsdatei ins Perlscript schreiben. Oeffne dazu 'vote.pl' mit einem Texteditor
(z.B. wordpad oder emacs) und aendere den Pfadnamen. 
    z.B.: $config="new_name_of_config";
In der Konfigurationsdatei muessen nun einige Pfadnamen und Einstellungen angegeben 
werden. Die erste Zeile von 'config.txt' enthaelt den Namen der ersten Abstimmung 
zwischen je drei Sternen. Anhand dieses Namens kann 'vote.pl' die verschiedenen 
Einstellungen der jeweiligen Abstimmung zuordnen. Folgendes musst du nun in 'config.txt' 
angeben:

*  html_file: Den lokalen Pfadnamen des html-Dokuments, das die Abstimmungsfragen 
     enthaelt.
*  output_file: Den Pfad des html-Files, mit dem der Output dargestellt werden soll.
*  log_file: Den Pfad des Logfiles. 
*  ip_file: Den Pfad der Datei, in der die IP-Nummer derjenigen Computer abgespeichert 
     wird, die bereits abgestimmt haben.
*  already_voted_file: Pfadname des html-Dokuments, das angezeigt wird, wenn jemand   
     versucht mehrmals abzustimmen.
*  vote_url: Die URL, mir der dein 'vote.pl' aufgerufen wird. Die gleiche URL sollte auch
     im Formular-Block von 'html_file' stehen.
*  checkIP: Ob die IP-Nummer ueberprueft werden soll. (true oder false)
*  checkCookie: Ob mit Hilfe von Cookies merhmaliges Abstimmen verhindert werden soll. 
     (true oder false). ACHTUNG: Nicht alle Browser unterstuetzen Cookies!
*  expiration: Nach wievielen Tagen ein Cookie ablaufen soll. Ist das Cookie abgelaufen, 
     so kann vom entsprechenden Computer aus erneut abgestimmt werden.
*  replace_form: Ob die Resultate ins alte html-Dokument anstelle der Abstimmungsfragen 
    eingefuegt werden sollen. Sonst werden die Ergebnisse in einem neuen Dokument 
    angezeigt.(true oder false)

ACHTUNG: Verwende fuer die Pfadnamen nur Slashs (und keine Backslashs, auch auf WinNT 
nicht!). 
Nach den Einstellungen fuer die erste Abstimmung folgt im Konfigurationsfile der Name der
zweiten Abstimmung und danach die Angaben zur zweiten Abstimmung, usw.

WIE MUSS ICH DEN FORMULAR-BLOCK (<form>...</form>) IM 'html_file' DEFINIEREN?

Bitte benutzt 'get' (method=get) um das Formular abzuschicken.
Pro Zeile solltes du nur einen neuen Radiobutton definieren. Auch fuer die Gruppennamen
und 'values' musst du gewisse Regeln beachten:
Die Namen der Gruppen muessen kleine Buchstaben sein und zwar in alphabethischer
Reihenfolge. Fuer die 'values' verwendest du ganze Zahlen, in aufsteigender Reihenfolge.
Im ersten Input-Feld, musst du den Namen deiner Abstimmung angeben. Verwende dazu ein 
Input-Feld vom Typ 'Hidden'.
Bsp.:
		<form action=http://www.your_server.com/cgi-bin/vote.pl method=get>
		    <input type="Hidden" name="name" value="name_of_the_voting">
		<b>Beste Fernsehserie:</b><br>
				<input type="Radio" name="a" value="1" >Akte X<br>
				<input type="Radio" name="a" value="2" >Outer Limits<br>
		<b>Bester Film:</b><br>
				<input type="Radio" name="b" value="1">Terminator <br>
				<input type="Radio" name="b" value="2">Aliens<br>
				<input type="Radio" name="b" value="3">Titanic<br>
		<input type=submit value="Submit">
		<input type=reset value="Reset">
		</form>

WIE ERSTELLE ICH DAS OUTPUT-FILE?

Im File 'output_file' kannst du die Form des Outputs bestimmen. Dieses File muss in 
html-Code geschrieben werden. Fuer die Anzahl der Stimmen verwendest du folgende 
Variabeln, die durch ein vorangestelltes Dollarzeichen ($) und einen nachgestellten 
Strichpunkt (;) gekennzeichnet werden:
	* $a1;  :	Anzahl Stimmen fuer das erste Element der Gruppe 'a'
	* $%a1; :	Anzahl Stimmen in Prozent fuer das erste Element der Gruppe 'a'
	* $a2;  :	Anzahl Stimmen fuer das zweite Element der Gruppe 'a'	
 * $%a2; : Anzahl Stimmen in Prozent fuer das zweite Element der Gruppe 'a'
	* $b1;  :	Anzahl Stimmen fuer das erste Element der Gruppe 'b'
			
			u.s.w

	* $tot; :	Anzahl abgegebener Stimmen

Die Variablen werden dann vom Perlscript durch die entsprechenden Zahlen ersetzt.

WIE KANN ICH NUR DIE RESULTATE MEINER ABSTIMMUNG ANZEIGEN LASSEN?

Damit 'vote.pl' nur die Resultate der Abstimmung anzeigt, musst du das Perlscript auf 
folgende Weise aufrufen:
   http://your_server.com/cgi-bin/vote.pl?name=name_of_your_voting&action=view

BEMERKUNGEN ZUM LOGFILE:

Jede Abstimmung erhaelt ein eigenes Logfile, deren Pfadname du im 'config.txt' angiebst.
Das Logfile wird beim ersten Aufruf von 'vote.pl' automatisch generiert, sofern es nicht
schon vorhanden ist. Du kannst das Logfile aber auch selber mit einem Texteditor 
generieren; beachte dabei bitte folgende Punkte:
	* am Anfang des Logfile muss stehen: 
		 'Total votes:0'
	* die Daten der einzelnen Gruppen werden durch Zeilenumschaltungen getrennt
 * die Anzahl Stimmen fuer die einzelnen Elemente der Gruppen trennst du durch 
   Leerschlaege
Bsp:
	Total votes:1
	0 0 0 0
	0 0 0 0 0 0 0 0 0 0 0
	0 0
	0 0 0

WIE PASSE ICH MEINE ALTEN FILES AN DIE NEUE VERSION 2.0 AN?

Dieser Abschnitt richtet sich an Personen, die von der Version 1.x auf die Version 2.0 
von 'vote.pl' umsteigen. Die Version 2.0 ist nicht rueckwaertskompatibel. Einige Dateien 
muessen leider angepasst werden:
*  Zuerst wird die Konfigurationsdatei erstellt (siehe 'EINSTELLUNGEN IN DER   
   KONFIGURATIONSDATEI'). 
*  Im Formularblock (<form>...</form>) des 'html_file' musst du das folgende Input-Feld  
   hinzufuegen:
          <input type="Hidden" name="name" value="name_of_the_voting">
   'name_of_the_voting' ersetzt du natuerlich durch den Namen deiner Abstimmung. Dieses 
   Input-Feld sendet den Name der Abstimmung an das Perlscript.
*  In dem File 'examp_out' musst du noch bei allen Variablen einen Strichpunkt (;) 
   hinzufuegen. (Bsp.: $a1 --> $a1; )
*  Nun ist noch die Datei 'already_voted_file' zu erstellen. Diese Datei wird von 
   'vote.pl' angezeigt, falls jemand versucht mehrmals abzustimmen.