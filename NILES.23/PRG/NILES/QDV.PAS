{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * QDV.PAS                                 *
 * Frage nach Lizenz-Nummer    NILES-DOS   *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,SysLog_,LogNam_,Mount1_,Handle_;

const  copyrc                      = '(c) 88 by NILES-SOFT';
       pc1                         = 'M o d u l :     Q  D  V';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '18.10.89';
       ppp                         = 'E:\UTILITYS\BATCH\';
       lw                          = 'd:';

var    i,j,k,DEC,Name_I            :               Integer;
       _j,_k,i_j,i_k               :               Byte;
       S_Rec                       : record Fill : array[1..21] of byte;
                                            Attr : Byte;
                                            Time : LongInt;
                                            Size : LongInt;
                                            Name : string[12];
                                     end;
       Name                        : array[1..    7] of string[ 13];
       Name_C                      : array[1..   40] of string[ 13];
       Name_A                      : array[1..   40] of string[ 13];
       Name_N                      : array[1..   40] of string[ 13];
       path_d     ,path_progr      :                    string[ 80];
       path_progr2,path_progr3     :                    string[ 80];
       Attr                        :                    Word;
       bbb,byt2                    :                    Byte;
       comm,idat                   : file            of Byte;
       config                      :                    Text;
       First                       :                    Boolean;
       hilf,hilf1,command,liz      :                    string[255];
       J1,J2,M,M1,M2,D1,D2,D11     :                    Word;
       S1,N1,T1                    :                    Word;
       Name_,Pass1,Pass2           :                    string[255];
       hilfc                       : array[0..  255] of byte absolute hilf;
       Reg                         :                    Registers;
       BufferHead                  :                    Integer absolute $40:$1a;
       BufferTail                  :                    Integer absolute $40:$1c;
       ii,iii                      :                    LongInt;

procedure Sys_Halt(id:Integer);
begin Sys_Halt1(id); {$IFDEF Debug} halt(1); {$ELSE} i:=0; while i=0 do ; {$ENDIF} end;

function NextByte_idat:Char;
  var ch:Byte;
begin Read(idat,ch); NextByte_idat:=chr(ch-i_j-i_j+i_k); i_k:=i_k+i_j; end;

function NextString:string;
  var ch  : Char;
      Str : string[255];
begin Str[0]:=#0;
      repeat ch:=NextByte_idat;
             case ch of #10: ;
                        #13: ch:=#255;
                        ',': ch:=#255;
                        else begin Str[        0  ]:=chr(ord(Str[0])+1);
                                   Str[ord(Str[0])]:=ch;
                             end
             end;
      until ch=#255;
      NextString:=Str;
end;



begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
      fenster(1, 7, 6,75,18,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      Mount_Log; exec(ppp+'WRENABLE.COM',lw);
      LogNam_O; Seek(LogNam_d,0); LogNam_R; byt2:=LogNam_p.byt[12];
      LogNam_R; c2_write(10,20,'Ger„te-Nummer           : ');
                for i:=1 to 14 do
                begin Write(chr(LogNam_p.byt[i]-i+byt2)); byt2:=byt2+2*i+i; end;
      LogNam_R; c2_write(12,20,'Lizenz-Nummer  NILES-DOS: ');
                for i:=1 to 14 do
                begin Write(chr(LogNam_p.byt[i]-i+byt2)); byt2:=byt2+4*i;   end;
      LogNam_C;

      if ParamStr(1)<>'NiLeS-soft'
         then begin exec(ppp+'WPROTECT.COM',lw); Demount_Log; end;

      GotoXY( 1,19);
end.
