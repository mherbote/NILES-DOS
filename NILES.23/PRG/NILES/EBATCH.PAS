{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * EBATCH.PAS                              *
 * Endeprozesse des SYSTEMs                *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     E  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '18.10.89';

var    cs1,cs2  : Text;
       csp      : String;

begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); clrscr;
      fenster(1, 1, 3,80,24,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      exec('D:\UTILITYS\BATCH\AMT.EXE','N E');

      Assign  (cs2,'C:\CONFIG.SYS');
      SetFAttr(cs2,Archive);
      Rewrite (cs2);
      Writeln (cs2,'device=fixt_drv.sys');
      Writeln (cs2,'shell  =D:\UTILITYS\BATCH\consys.exe');
      Close   (cs2);
      SetFAttr(cs2,ReadOnly);

      inline($EA/$00/$00/$FF/$FF);                       { SYSTEM - R E S E T }
end.
