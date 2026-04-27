{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{********************************************
 * RESOLVE.PAS                             *
 * ungel”ste Parameter ersetzen             *
 *                                          *
 *         (c) by NILES-SOFT 1989 VERS. 2.3 *
 *            Programmierer: Marcus Herbote *
 ********************************************}

uses   dos,crt,crt_,Fenster_,Batch_,Mount_;

const  copyrc                      = '(c) 89 by NILES-SOFT';
       pc1                         = 'M o d u l :     R E S O L V E';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '04.05.89';


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); nam:=paramstr(1);
      Mount_Log;

      Demount_Log;
end.
