# Backstage - Backup bei Doppelklick

> "Steck die Festplatte an den Computer, starte das Backup und warte, bis es fertig ist."

## Inhalt

1. [Setup mobiles Gerät](#setup-mobiles-gerät)
1. [Setup Maschine](#setup-maschine)
1. [Setup externe Festplatte](#setup-externe-festplatte)
1. [Setup TrueCrypt-Festplatte](#setup-truecrypt-festplatte)
1. [Setup Choco-Upgrade](#setup-choco-upgrade)
1. [Namensgebung Backups](#namensgebung-backups)
1. [Wiederherstellung](#wiederherstellung)
1. [Hintergrund-Geschichte](#hintergrund-geschichte)

## Setup mobiles Gerät (MTP)

Bevorzugt. MTP steht für "Media Transfer Protocol" und trifft zu, wenn das angesteckte Gerät als Gerät _ohne Laufwerksbuchstaben_ angezeigt wird. Es muss vorm Abstecken nicht ausgeworfen werden und vor dem Backup muss am mobilen Gerät keine extra Aktion durchgeführt werden.

1. Installiere [FreeFileSync](http://www.freefilesync.org/download.php)
1. Lege Verknüpfungen auf die entsprechenden `scripts\backup-*.bat` auf den Desktop
  - Verwende `icons\backstage-mobile.ico` als Icon für die Verknüpfung



## Setup mobiles Gerät (UMS)

UMS steht für "USB Mass Storage" und trifft zu, wenn für das angesteckte Gerät ein Laufwerksbuchstabe vergeben wird.

1. Stelle mit `diskmgmt.msc` sicher, dass die "externe Festplatte" des mobilen Geräts unter `E:` verfügbar ist
1. Kopiere die Datei `setup\backstage.inf` ins Root-Verzeichnis
  1. Ändere in der _kopierten_ `backstage.inf` das `LABEL` auf `Flitzer III`
  1. Verstecke die kopierte Datei
1. Lege Verknüpfungen auf die entsprechenden `scripts\backup-*.bat` auf den Desktop
  - Verwende `icons\backstage-mobile.ico` als Icon für die Verknüpfung

## Setup Maschine

1. Installiere [TrueCrypt](https://www.truecrypt71a.com) Version 7.1a vom 07.02.2012
  - _Hinweis: Nach der Installation kann das Tray-Icon entfernt werden_
1. Installiere [Macrium Reflect Free](http://www.macrium.com/reflectfree.aspx) Version 6.7.708 vom 29.06.2015  
  _Hinweis: In den Defaults bei Advanced die 20 Sekunden Vorlaufzeit abschalten_
1. Klone dieses Repository nach `%ALLUSERSPROFILE%\backstage` bzw. `C:\ProgramData\backstage`
1. Lege Verknüpfungen auf die entsprechenden `scripts\backup-*.bat` auf den Desktop
  - Verwende `icons\backstage.ico` als Icon für die Verknüpfung
1. Stelle mit `diskmgmt.msc` sicher, dass die externe Festplatte unter `S:` verfügbar ist
1. Stelle sicher, dass der Laufwerksbuchstabe `T:` für gemountete TrueCrypt-Festplatten frei ist

## Setup externe Festplatte

1. Formatiere die Festplatte mit dem NTFS-Dateisystem
  1. Schalte die Festplatten-Indizierung aus
  1. Gib der Gruppe _JEDER_ alle Berechtigungen
  1. Ändere den Namen der Festplatte auf `Backup NN`
1. Kopiere den Inhalt von `setup\backup-drive` ins Root-Verzeichnis
  1. Ändere in der _kopierten_ `autorun.ini` das `LABEL` auf `Backup NN`
  1. Verstecke die kopierten Dateien

## Setup TrueCrypt-Festplatte

1. Starte TrueCrypt _**elevated**_ (bei Beendigung der Formatierung mit NTFS werden Admin-Berechtigungen benötigt)
1. Erstelle eine neue Volume
  1. `Create an encrypted file container`
  1. Bei der "_administrator privileges_"-Warnung mit **Nein** fortfahren
  1. `Standard TrueCrypt volume`
  1. Volume Location: `S:\Att22 Florian Win10.tc` (siehe [Namensgebung Backups](#namensgebung-backups))
  1. Encryption Options auf Default lassen
  1. Volume Size: _nach Bedarf_ (Daumenregel: `Aktuelle Auslastung + ~25% Potenzial`)
  1. Volume Password: _vom Maschinen-Besitzer zu wählen_
  1. Volume Format: `NTFS`
1. Mounte erstellte Volume auf Laufwerk `T:`
  1. Schalte die Festplatten-Indizierung aus
  1. Gib der Gruppe _JEDER_ alle Berechtigungen
  1. Ändere den Namen der Festplatte auf `Att22 Florian Win10` (siehe [Namensgebung Backups](#namensgebung-backups))
1. Kopiere den Inhalt von `setup\encrypted-drive` ins Root-Verzeichnis
  1. Ändere in der _kopierten_ `autorun.ini` das `LABEL` auf `Att22 Florian Win10` (siehe [Namensgebung Backups](#namensgebung-backups))
  1. Verstecke die kopierten Dateien

## Setup Choco-Upgrade

Ich verwende [chocolatey.org](http://chocolatey.org), damit ich Maschinen schnell, einfach und ohne viel Mühe einrichte. Um die installierte Software am aktuellsten Stand zu halten, gibt es ein Batch-Script für die _Scheduled Tasks_, das prüft, ob Upgrades vorhanden sind, und diese _nach Rückfrage_ installiert. Sind bei Logon keine Upgrades vorhanden, beendet sich das Script ohne Rückfrage.

1. Klone dieses Repository nach `%ALLUSERSPROFILE%\backstage` bzw. `C:\ProgramData\backstage`
1. Starte Scheduled Tasks: `taskschd.msc`
1. _[Optional]_ Gehe in Unterordner `_Custom`
1. Erstelle neuen Task:
  1. Name: **choco-upgrade**
  1. :ballot_box_with_check: **Run only when user is logged on**
  1. :ballot_box_with_check: **Run with highest privileges**
  1. Trigger: **At log on**
  1. Action: Start a program:
    1. Program/script: `%ALLUSERSPROFILE%\backstage\scripts\choco-upgrade.bat`
    1. Start in: `%ALLUSERSPROFILE%\backstage\scripts\`

## Namensgebung Backups

Der Name eines Backups setzt sich aus folgenden Teilen zusammen:

1. Adresse (3 stellig) + Bezirk (2-stellig)
1. Name des Besitzers
1. Betriebssystem ("Win7" oder "Win8")

Wenn nicht das Betriebssystem gesichert wird, kann die Wahl des Namens entsprechend anders ausfallen, z.B.: "Att22 WD Passport White".

### Namensgebung Beispiele

1. Att22 Florian Win10
1. Lae12 Hans Win8
1. Tue11 Sebastian Win7

## Wiederherstellung

1. Verwende Standard WindowsPE Image, das mit _Macrium Reflect_ erstellt werden kann
  - Aufpassen bei PE Architektur: **32 Bit** kann auf beiden Architekturen verwendet werden
1. Entschlüssle das Backup zuerst auf einer Maschine mit TrueCrypt auf eine andere USB-Festplatte (bevorzugterweise USB 3)
  - WindowsPE hat nur 512MB RAM zur Verfügung - das dauert dann, wenn entschlüsselt _und_ wiederhergestellt wird
  - WindowsPE kennt TrueCrypt nicht - es kann auf ein Image integriert werden, ist aber durch das Entschlüsseln _vor_ dem Wiederherstellungsvorgang nicht notwendig
1. Fahre einmal nach Wiederherstellung des Backups Windows 10 im Abgesicherten Modus mit Netzwerktreibern hoch, um eventuelle Fehlkonfigurationen zu beheben (Quelle: [SuperUser.com](http://superuser.com/a/513746))

## Hintergrund-Geschichte

Im Jahr 2013 habe ich mich hingesetzt und ein Backup-Konzept für die Familie erstellt. Inspiriert dazu haben mich folgende beiden Blog-Einträge von [Scott Hanselman](http://www.hanselman.com/about/) über Datenverlust und Backup-Strategie (Englisch):
- [A basic non-cloud-based personal backup strategy](http://www.hanselman.com/blog/ABasicNoncloudbasedPersonalBackupStrategy.aspx)
- [On Losing Data and a Family Backup Strategy](http://www.hanselman.com/blog/OnLosingDataAndAFamilyBackupStrategy.aspx)

Außerdem hatte ich in den vorangehenden Monaten einige Datenverluste am eigenen Leib in der Familie und in der Arbeit erlebt. Letztendlich ist Marlene Ende 2012 geboren worden, und ich wollte alle unsere Fotos und Videos gesichert wissen.

Im Mai 2013 erreichte ich den ersten Schritt von Backstage: ein niedergeschriebenes [Backup-Konzept](docs/backup-konzept.pdf)!

Anschließend habe ich das Programm _Backstage_ Entwickelt, das den Backup-Vorgang vereinfacht. Die Idee war eigentlich simpel: **starte im Windows Task Scheduler das Programm, warte auf die angesteckte Festplatte, erstelle das Backup, wirf die Festplatte aus**.

Inzwischen - Oktober 2015 - sind etwas mehr als zwei Jahre vergangen. Ich habe bisher vier der erstellten Backup-Images wiederhergestellt:

1. Initialer Test im Jahr 2013
1. März 2014: Wiederherstellung Hans' Daten nach System-Upgrade
1. April 2015: Wiederherstellung meiner Maschine nach einem Beta-Test von Windows 10
1. Juli 2015: Wiederherstellung Magdas Laptop

Außerdem habe ich inzwischen Batch-Scripts erstellt, mit denen die Daten unserer mobilen Geräte gesichert werden. Dazu wird das Handy angesteckt und die Dateien werden mittels `robocopy` auf den NAS kopiert.

Weil ich bei den Batch-Scripts so viel Erfahrung gesammelt habe, stelle ich auch den weiteren Betrieb des Programms _Backstage_ ein und verwende stattdessen dafür auch Batch-Scripts. Sie sind zwar grafisch nicht so ansprechend, aber mit ihnen ist wesentlich weniger Arbeit und Komplexität involviert. Damit nähere ich mich dem Ziel an, weniger Code im Projekt zu haben: [The Best Code is No Code At All](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/) von [Jeff Atwood](https://en.wikipedia.org/wiki/Jeff_Atwood).
