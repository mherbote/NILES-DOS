COUNTRY=049
DEVICE =d:\dos\ansi.sys
DEVICE =d:\utilitys\driver\ems.sys
DEVICE =d:\utilitys\driver\mdrive.sys -rah -u0
#
 "624k-Diskette  
(De)Aktivieren des GerÑtetreibers fÅr 624k-Disketten
Auswahl des Diskettenlaufwerkes
DEVICE =d:\utilitys\driver\scp624.sys -rah -u%1
0 2
#
 "720k-Diskette  
(De)Aktivieren des GerÑtetreibers fÅr 720k-Disketten
Auswahl des Diskettenlaufwerkes
DEVICE =d:\utilitys\driver\mdrive.sys -rah -u%1
0 5
#
#
 "Zusatzspeicher 
Definieren der Verwendung des Zusatzspeichers
Zusatzspeicher-Verwendung
3
     "E M S - Treiber     
Installieren eines EMS-Treibers
DEVICE =d:\utilitys\driver\ems.sys
       "V D I S K         
Einrichten einer RAM-Floppy    
DEVICE =d:\dos\vdisk.sys 4096 512 512 /E:8
      "R A M drive        
Einrichten einer RAM-Floppy    
DEVICE =d:\dos\ramdrive.sys
#
Externe "Speicher
Definieren der Verwendung von exteren Speichern
Externspeicher
5
     TEST "1     
TEST-Treiber 1
DEVICE =d:\utilitys\driver\test1.sys
     TEST "2     
TEST-Treiber 2
DEVICE =d:\utilitys\driver\test2.sys
     TEST "3     
TEST-Treiber 3
DEVICE =d:\utilitys\driver\test3.sys
     TEST "4     
TEST-Treiber 4
DEVICE =d:\utilitys\driver\test4.sys
     TEST "5     
TEST-Treiber 5
DEVICE =d:\utilitys\driver\test5.sys
#
#
