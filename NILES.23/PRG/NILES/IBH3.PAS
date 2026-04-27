{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * IBH3.PAS                      Hilfsprogramm 3      *
 * Installiert Nutzer und die zugehîrigen MenÅs       *
 *                                                    *
 *                   (c) by NILES-SOFT 1989 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,Mount_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     I  B  H  3';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '03.05.89';

var    ch                          :           Char;
       i                           :           Integer;
       h                           :           Text;
       h1,h2,ComSpec               :           String;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); clrscr; 
      fenster(1, 1, 2,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);

      Assign(h,'\INSTALL\MENUE.DAT'); Reset(h);
      if IOResult<>0 then begin Demount_Log; halt(99); end;
      while not Eof(h) do
      begin Readln(h,h2); i:=pos(',',h2);
            if i>0 then begin h1:=copy(h2,1,i-1); Delete(h2,1,i); Mount_Log;
                              exec('E:\UTILITYS\BATCH\'+h1+'.EXE',h2);
                        end;
      end;
      Close(h);

      c1_write(1,1,''); Window( 1, 1,80,25); clrscr; Demount_Log;
end.
