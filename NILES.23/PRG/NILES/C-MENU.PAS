{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * C-MENU.PAS                                         *
 * M E N U - SteuerDateien erzeugen                   *
 *                                                    *
 *                   (c) by NILES-SOFT 1989 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,Mount_,Wahl_;

const  copyrc                      = '(c) 89 by NILES-SOFT';
       pc1                         = 'M o d u l :     C  -  M  E  N  U';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '03.05.89';

var    i,j                         :           Integer;

procedure sys_halt(id:integer);
begin Demount_Log; sys_halt1(id); halt(1); end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); Window( 9, 7,70,18); clrscr; Window( 1, 1,80,25);
      fenster(1, 9, 7,70,18,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);
      if ParamCount<3 then sys_halt(30);

      Mount_Log; i:=3;
      repeat c2_write(13,15,'Pfad  E:\BAT\'+ParamStr(i)+'  wird bearbeitet.');
             exec('D:\UTILITYS\BATCH\DBATCH.EXE','D E:\BAT\'+ParamStr(i)+'\');
             if ParamStr(i+1)='-'
                then begin RmDir('E:\BAT\'+ParamStr(i)); j:=IOResult;
                     end
                else begin MkDir('E:\BAT\'+ParamStr(i)); j:=IOResult;
                           if ParamStr(i+1)='*'
                              then exec('D:\UTILITYS\BATCH\DBATCH.EXE',
                                        'C '+ParamStr(2)+'\'+ParamStr(i  )+'\ E:\BAT\'+ParamStr(i)+'\ R')
                              else exec('D:\UTILITYS\BATCH\DBATCH.EXE',
                                        'C '+ParamStr(2)+'\'+ParamStr(i+1)+'\ E:\BAT\'+ParamStr(i)+'\ R');
                     end;
             i:=i+2;
      until i>ParamCount-1;
      exec('D:\UTILITYS\BATCH\DBATCH.EXE','D C:\BAT\BATCH\');

      c1_write(1,1,''); Window( 1, 1,80,25); clrscr; Demount_Log;
      if (ParamStr(1)='r') or (ParamStr(1)='R') then exec('D:\UTILITYS\PUBLIC\INT19O.COM','');
end.
